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
