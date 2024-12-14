import os
from pathlib import Path
import asyncio
import pandas as pd
import aiofiles
from scripts.etl.fetch_lc_problems import get_lc_problems


async def is_sql_file_empty(file_path):
    """Check if SQL file is empty or contains only whitespace asynchronously."""
    try:
        async with aiofiles.open(file_path, "r") as f:
            content = await f.read()
            return not content.strip()
    except FileNotFoundError:
        return True


async def generate_sql_insert_query(row):
    """Generate a single SQL insert query from a DataFrame row."""

    # Escape single quotes in title by replacing ' with ''
    escaped_title = row['question__title'].replace("'", "''")
    escaped_slug = row['question__title_slug'].replace("'", "''")

    return (
        f"INSERT INTO problems (leetcode_number, title, link, difficulty_rating, is_premium) "
        f"VALUES ({row['frontend_question_id']}, '{escaped_title}', "
        f"'{escaped_slug}', {row['difficulty']}, {row['paid_only']});"
    )


async def write_sql_file(sql_file_path, content):
    """Write content to SQL file asynchronously."""
    async with aiofiles.open(sql_file_path, "w") as f:
        await f.write(content)


async def generate_sql_problems_table_insert_query(
    csv_filepath, sql_problems_table_insert_query_dir
):
    """Generate SQL insert queries for problems table asynchronously."""
    # Read CSV file (pandas operation is CPU-bound, so run in executor)
    loop = asyncio.get_event_loop()
    df = await loop.run_in_executor(None, pd.read_csv, csv_filepath)

    # Generate SQL file path for combined queries
    filename = csv_filepath.stem + ".sql"
    sql_file_path = sql_problems_table_insert_query_dir / filename

    # Generate all queries
    queries = []
    queries.append("DELETE FROM problems WHERE 1=1;")  # Clear table before inserting new data
    for _, row in df.iterrows():
        query = await generate_sql_insert_query(row)
        queries.append(query)

    # Combine all queries with newlines
    combined_queries = "\n".join(queries)

    # Write all queries to a single file
    await write_sql_file(sql_file_path, combined_queries)
    print(f"✓ Generated SQL file with {len(queries)} insert queries: {filename}")


async def execute_sql_file(db, sql_file):
    """Execute a single SQL file."""
    try:
        async with aiofiles.open(sql_file, "r", encoding="utf-8") as f:
            sql_content = await f.read()
            await asyncio.to_thread(db.executescript, sql_content)
        print(f"✓ Successfully executed: {sql_file.name}")
    except Exception as e:
        print(f"Error executing {sql_file.name}: {str(e)}")


async def init_seed(db, current_app):
    """Initialize database seeding with async operations."""
    try:
        # Set up directories
        sql_dir = Path(current_app.root_path) / ".." / "scripts" / "db" / "seed" / "sql"
        sql_dir.mkdir(parents=True, exist_ok=True)

        # Fetch LeetCode problems
        csv_filepath = await get_lc_problems()
        print(f"✓ CSV file generated at: {csv_filepath}")

        # Generate SQL insert queries
        await generate_sql_problems_table_insert_query(csv_filepath, sql_dir)

        # Get list of SQL files
        sql_files = sorted(sql_dir.glob("*.sql"))

        # Check files and execute SQL
        for sql_file in sql_files:
            if await is_sql_file_empty(sql_file):
                print(f"Warning: Skipping empty SQL file: {sql_file.name}")
                continue

            await execute_sql_file(db, sql_file)

        # Commit all changes
        await asyncio.to_thread(db.commit)
        print("✓ Database seeding completed successfully")

    except Exception as e:
        print(f"Error in init_seed: {str(e)}")
        raise


# if __name__ == "__main__":
#     asyncio.run(init_seed(db, current_app))
