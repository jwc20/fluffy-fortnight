import requests
import json
import datetime
import pandas as pd
from pathlib import Path
import asyncio
import aiohttp

current_datetime = datetime.datetime.now()
current_datetime_str = current_datetime.strftime("%Y-%m-%d_%H-%M-%S")

script = """
splash:go(args.url)
splash:wait(5)

local get_json = splash:jsfunc([[
    function() {
        return JSON.stringify(document.body.innerText);
    }
]])

local json = get_json()
return {json=json}
"""


async def fetch_lc_problems_as_json():
    """Fetch LeetCode problems asynchronously using aiohttp."""
    async with aiohttp.ClientSession() as session:
        async with session.post(
            "https://splash.tearsjobs.careers/run",
            json={
                "lua_source": script,
                "url": "https://leetcode.com/api/problems/algorithms/",
            },
        ) as response:
            resp_json = await response.json()
            data = json.loads(resp_json["json"])
            return json.loads(data)


async def export_as_json(data, filename=None):
    """Export data as JSON asynchronously."""
    if filename is None:
        filename = f"lc_problems_{current_datetime_str}.json"

    async with aiofiles.open(filename, "w") as f:
        await f.write(json.dumps(data))
    return filename


def create_lc_problems_df(data):
    """Create DataFrame from LeetCode problems data."""
    problems = data["stat_status_pairs"]
    headers = [
        "frontend_question_id",
        "question__title",
        "question__title_slug",
        "difficulty",
        "paid_only",
    ]
    return pd.DataFrame(
        [
            [
                p["stat"]["frontend_question_id"],
                p["stat"]["question__title"],
                p["stat"]["question__title_slug"],
                p["difficulty"]["level"],
                p["paid_only"],
            ]
            for p in problems
        ],
        columns=headers,
    )


async def export_as_csv(data, filepath):
    """Export DataFrame as CSV asynchronously."""
    df = create_lc_problems_df(data)

    # sort by frontend_question_id
    df = df.sort_values(by='frontend_question_id')

    # Use run_in_executor for CPU-bound pandas operation
    loop = asyncio.get_event_loop()
    await loop.run_in_executor(None, df.to_csv, filepath)
    return filepath


async def get_lc_problems():
    """Main function to orchestrate the fetching and processing of LeetCode problems."""
    try:
        # Fetch the data
        data = await fetch_lc_problems_as_json()
        print("✓ Successfully fetched LeetCode problems")

        # Create the directory if it doesn't exist
        filepath = (
            Path("scripts/db/seed/csv") / f"lc_problems_{current_datetime_str}.csv"
        )
        filepath.parent.mkdir(parents=True, exist_ok=True)

        # Export to CSV
        await export_as_csv(data, filepath)
        print(f"✓ Successfully exported to CSV: {filepath}")

        return filepath

    except Exception as e:
        print(f"Error in get_lc_problems: {str(e)}")
        raise


# if __name__ == "__main__":
#     asyncio.run(get_lc_problems())
