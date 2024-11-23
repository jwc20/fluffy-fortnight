from flask import (
    Blueprint, render_template
)

from ff.db import get_db

from ff.problems import bp


# bp = Blueprint('problems', __name__)
# bp = Blueprint('problems', __name__, url_prefix='/problems')

# @bp.route('/')
# def index():
#     db = get_db()
#     problems = db.execute(
#         'SELECT * FROM problems p'
#     ).fetchall()
#     return render_template('problems/index.html', problems=problems)
