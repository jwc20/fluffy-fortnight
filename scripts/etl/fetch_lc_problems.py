import requests
import json
import datetime
import pandas as pd
from pathlib import Path

# TODO: To get leetcode progression data, we need to have login information
# import dotenv
# dotenv.load_dotenv()

current_datetime = datetime.datetime.now()
current_datetime_str = current_datetime.strftime('%Y-%m-%d_%H-%M-%S')

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

def fetch_lc_problems_as_json():
    resp = requests.post('https://splash.tearsjobs.careers/run', json={
        'lua_source': script,
        'url': 'https://leetcode.com/api/problems/algorithms/'
    })

    _data = json.loads(resp.json()['json'])
    _data = json.loads(_data)
    return _data

def export_as_json(_data):
    with open(f'lc_problems_{current_datetime_str}.json', 'w') as f:
        json.dump(_data, f)

def create_lc_problems_df(_data):
    problems = _data["stat_status_pairs"]
    headers = ["frontend_question_id", "question__title", "question__title_slug", "difficulty", "paid_only"]
    return pd.DataFrame([[ p["stat"]["frontend_question_id"], p["stat"]["question__title"], p["stat"]["question__title_slug"], p["difficulty"]["level"], p["paid_only"] ] for p in problems], columns=headers)

def export_as_csv_zip(_data):
    problems = _data["stat_status_pairs"]
    df = create_lc_problems_df(_data)
    df.to_csv(f'lc_problems_{current_datetime_str}.zip', index=False, compression=compression_opts)

def export_as_csv(_data):
    # filepath = Path('scripts/db/seed/csv') / f'lc_problems_{current_datetime_str}.csv'

    filepath = Path('scripts/db/seed/csv') / f'lc_problems_{current_datetime_str}.csv'

    df = create_lc_problems_df(_data)
    df.to_csv(filepath, index=False)

def get_lc_problems():
    data = fetch_lc_problems_as_json()
    export_as_csv(data)


# if __name__ == '__main__':
#     data = fetch_lc_problems_as_json()
#     # export_as_json(data)
#     export_as_csv(data)
