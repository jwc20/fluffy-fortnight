import os
from pathlib import Path


def is_sql_file_empty(file_path):
    """Check if SQL file is empty or contains only whitespace."""
    return Path(file_path).stat().st_size == 0 or not Path(file_path).read_text().strip()


def init_seed(_db, _current_app):
    sql_dir = Path(_current_app.root_path) / '..' / 'scripts'/ 'db' / 'seed' / 'sql'

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