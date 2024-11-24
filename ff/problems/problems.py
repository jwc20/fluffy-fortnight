from flask import render_template

from ff.db import get_db
from ff.problems import bp

@bp.route('/')
def index():
    db = get_db()
    problems = db.execute(
        'SELECT * FROM problems'
    ).fetchall()
    return render_template('problems/index.html', problems=problems)


@bp.route('/neetcode150')
def neetcode150():
    db = get_db()
    problems = db.execute(
        'SELECT p.id, p.leetcode_number, p.title, p.link, p.description, p.difficulty_id, p.solution_notes, p.time_complexity, p.space_complexity, p.is_premium, p.created_at, p.updated_at, p.deleted_at, p.deleted, t.name as tag_name, GROUP_CONCAT(pa.name) as patterns '
        'FROM problems p '
        'JOIN problem_tags pt ON p.id=pt.problem_id '
        'JOIN tags t ON pt.tag_id=t.id '
        'JOIN problem_patterns pp ON p.id=pp.problem_id '
        'JOIN patterns pa ON pp.pattern_id=pa.id '
        'WHERE t.endpoint="neetcode150" '
        'GROUP BY p.id '
        'ORDER BY p.leetcode_number;'
    ).fetchall()

    patterns = {}
    for problem in problems:

        problem_patterns = problem['patterns'].split(',')
        for pattern in problem_patterns:
            if pattern in patterns:
                patterns[pattern] += 1
            else:
                patterns[pattern] = 1

    return render_template('problems/neetcode150.html', problems=problems, patterns=patterns)

@bp.route('/blind75')
def blind75():
    db = get_db()
    problems = db.execute(
        'SELECT p.id, p.leetcode_number, p.title, p.link, p.description, p.difficulty_id, p.solution_notes, p.time_complexity, p.space_complexity, p.is_premium, p.created_at, p.updated_at, p.deleted_at, p.deleted, t.name as tag_name, GROUP_CONCAT(pa.name) as patterns '
        'FROM problems p '
        'JOIN problem_tags pt ON p.id=pt.problem_id '
        'JOIN tags t ON pt.tag_id=t.id '
        'JOIN problem_patterns pp ON p.id=pp.problem_id '
        'JOIN patterns pa ON pp.pattern_id=pa.id '
        'WHERE t.endpoint="blind75" '
        'GROUP BY p.id '
        'ORDER BY p.leetcode_number;'
    ).fetchall()

    patterns = {}
    for problem in problems:

        problem_patterns = problem['patterns'].split(',')
        for pattern in problem_patterns:
            if pattern in patterns:
                patterns[pattern] += 1
            else:
                patterns[pattern] = 1

    return render_template('problems/blind75.html', problems=problems, patterns=patterns)

