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


@bp.route('/neetcode')
def neetcode():
    db = get_db()
    problems = db.execute(
        'SELECT *, pa.name as pattern FROM problems p '
        'JOIN problem_tags pt ON p.id = pt.problem_id '
        'JOIN tags t ON pt.tag_id = t.id '
        'JOIN problem_patterns pp ON p.id = pp.problem_id '
        'JOIN patterns pa ON pp.pattern_id = pa.id '
        'WHERE t.name = "neetcode"'
    ).fetchall()
    return render_template('problems/neetcode.html', problems=problems)
