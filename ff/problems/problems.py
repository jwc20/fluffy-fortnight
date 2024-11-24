from flask import render_template

from ff.db import get_db
from ff.problems import bp



def write_query(endpoint):
    if endpoint is not None:
        return (
            'SELECT p.id, p.leetcode_number, p.title, p.link, p.description, p.difficulty_id as difficulty, p.solution_notes, p.time_complexity, p.space_complexity, p.is_premium, p.created_at, p.updated_at, p.deleted_at, p.deleted, t.name as tag_name, GROUP_CONCAT(pa.name, ", ") as patterns '
            'FROM problems p '
            'JOIN problem_tags pt ON p.id=pt.problem_id '
            'JOIN tags t ON pt.tag_id=t.id '
            'JOIN problem_patterns pp ON p.id=pp.problem_id '
            'JOIN patterns pa ON pp.pattern_id=pa.id '
            'WHERE t.endpoint="%s" '
            'GROUP BY p.id '
            'ORDER BY p.leetcode_number;' % endpoint
        )
    else:
        return (
            'SELECT p.id, p.leetcode_number, p.title, p.link, p.description, p.difficulty_id as difficulty, p.solution_notes, p.time_complexity, p.space_complexity, p.is_premium, p.created_at, p.updated_at, p.deleted_at, p.deleted, GROUP_CONCAT(pa.name, ", ") as patterns '
            'FROM problems p '
            'JOIN problem_patterns pp ON p.id=pp.problem_id '
            'JOIN patterns pa ON pp.pattern_id=pa.id '
            'GROUP BY p.id '
            'ORDER BY p.leetcode_number;'
        )


def execute_query(query):
    db = get_db()
    return db.execute(query).fetchall()

def get_patterns(problems):
    patterns = {}
    for problem in problems:
        problem_patterns = problem['patterns'].split(',')
        for pattern in problem_patterns:
            if pattern in patterns:
                patterns[pattern] += 1
            else:
                patterns[pattern] = 1
    return patterns


@bp.route('/')
def index():
    query = write_query(None)
    problems = execute_query(query)
    patterns = get_patterns(problems)
    return render_template('problems/index.html', problems=problems, patterns=patterns)


@bp.route('/neetcode150')
def neetcode150():
    query = write_query('neetcode150')
    problems = execute_query(query)
    patterns = get_patterns(problems)
    return render_template('problems/neetcode150.html', problems=problems, patterns=patterns)

@bp.route('/blind75')
def blind75():
    query = write_query('blind75')
    problems = execute_query(query)
    patterns = get_patterns(problems)
    return render_template('problems/blind75.html', problems=problems, patterns=patterns)

