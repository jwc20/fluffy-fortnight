import os
from pathlib import Path
from scripts.etl.fetch_lc_problems import get_lc_problems
import asyncio
import pandas as pd

def is_sql_file_empty(file_path):
    """Check if SQL file is empty or contains only whitespace."""
    return Path(file_path).stat().st_size == 0 or not Path(file_path).read_text().strip()

async def generate_sql_problems_table_insert_query(csv_filepath, sql_problems_table_insert_query_dir):
    """Generate SQL insert queries for problems table."""
    df = pd.read_csv(csv_filepath)
    for index, row in df.iterrows():
        problem_id = row['frontend_question_id']
        title = row['question__title']
        title_slug = row['question__title_slug']
        difficulty = row['difficulty']
        paid_only = row['paid_only']
        insert_query = f"INSERT INTO problems (leetcode_number, title, link, difficulty_rating, is_premium) VALUES ({problem_id}, '{title}', '{title_slug}', {difficulty}, {paid_only});"
        sql_file_path = sql_problems_table_insert_query_dir / f"{problem_id}.sql"

        filename = csv_filepath.replace('scripts/db/seed/csv/', '').replace('.csv', '') + '.sql'

        with open(f'999999_{sql_file_path}_insert_{filename}', 'w') as f:
            f.write(insert_query)



def init_seed(_db, _current_app):
    sql_dir = Path(_current_app.root_path) / '..' / 'scripts'/ 'db' / 'seed' / 'sql'

    csv_filepath = asyncio.run(get_lc_problems())
    print(f"CSV file path: {csv_filepath}")

    # sql_problems_table_insert_query_dir = Path(_current_app.root_path) / '..' / 'scripts'/ 'db' / 'seed' / 'sql' / 'problems_table'

    # Generate SQL insert queries for problems table
    asyncio.run(generate_sql_problems_table_insert_query(csv_filepath, sql_dir))

    sql_files = sorted([f for f in sql_dir.glob('*.sql')])

    for sql_file in sql_files:
        # Check if file is empty
        if is_sql_file_empty(sql_file):
            print(f"Warning: Skipping empty SQL file: {sql_file.name}")
            continue

        try:
            with sql_file.open('r', encoding='utf-8') as f:
                sql_content = f.read()
                _db.executescript(sql_content)
            _db.commit()
            print(f"Successfully executed: {sql_file.name}")
        except Exception as e:
            print(f"Error executing {sql_file.name}: {str(e)}")


# if __name__ == '__main__':
#     init_seed(init_seed())
#     print("Database seeded.")