from flask import render_template, abort
from jinja2 import TemplateNotFound

from ff.db import get_db
from ff.views.problems import bp


def write_query(endpoint):
    if endpoint is not None:
        # Get all problems from neetcode150 or blind75 tags.
        # Example: http://127.0.0.1:8742/problems/neetcode150
        return (
            f"""SELECT p.id, p.leetcode_number, p.title, p.link, p.description, 
            p.difficulty_rating as difficulty, 
            p.is_premium, p.created_at, p.updated_at, p.deleted_at, 
            p.deleted, t.name as tag_name, GROUP_CONCAT(pa.name, ", ") as patterns 
            FROM problems p 
            LEFT JOIN problem_tags pt ON p.leetcode_number=pt.problem_id 
            LEFT JOIN tags t ON pt.tag_id=t.id 
            LEFT JOIN problem_patterns pp ON p.leetcode_number=pp.problem_id 
            LEFT JOIN patterns pa ON pp.pattern_id=pa.id 
            WHERE t.endpoint="{endpoint}" 
            GROUP BY p.id 
            ORDER BY p.leetcode_number;"""
        )
    else:
        # Get all problems from leetcode.
        # Example: http://127.0.0.1:8742/problems/
        return """SELECT p.id, p.leetcode_number, p.title, p.link, p.description, 
            p.difficulty_rating as difficulty, 
            p.is_premium, p.created_at, p.updated_at, p.deleted_at, 
            p.deleted, GROUP_CONCAT(pa.name, ", ") as patterns
            FROM problems p
            LEFT JOIN problem_patterns pp ON p.leetcode_number=pp.problem_id
            LEFT JOIN patterns pa ON pp.pattern_id=pa.id
            GROUP BY p.id
            ORDER BY p.leetcode_number;"""


def execute_query(query):
    db = get_db()
    return db.execute(query).fetchall()


# https://flask.palletsprojects.com/en/stable/patterns/sqlite3/
def query_db(query, args=(), one=False):
    cur = get_db().execute(query, args)
    rv = cur.fetchall()
    cur.close()
    return (rv[0] if rv else None) if one else rv


def get_patterns(problems):
    patterns = {}
    for problem in problems:
        if problem["patterns"] is None:
            continue
        else:
            problem_patterns = problem["patterns"].split(",")
            for pattern in problem_patterns:
                if pattern in patterns:
                    patterns[pattern] += 1
                else:
                    patterns[pattern] = 1
    return patterns



@bp.route('/', defaults={'page': 'index'})
@bp.route('/<page>')
def show(page):
    print(page)
    try:
        query = write_query(page)
        problems = execute_query(query)
        patterns = get_patterns(problems)
        return render_template(f'problems/{page}.html.jinja2', problems=problems, patterns=patterns)
    except TemplateNotFound:
        abort(404)

#
# @bp.route("/")
# def index():
#     query = write_query(None)
#     problems = execute_query(query)
#     patterns = get_patterns(problems)
#     return render_template("problems/index.html.jinja2", problems=problems, patterns=patterns)
#
#
# @bp.route("/neetcode150")
# def neetcode150():
#     query = write_query("neetcode150")
#     problems = execute_query(query)
#     patterns = get_patterns(problems)
#     return render_template(
#         "problems/neetcode150.html.jinja2", problems=problems, patterns=patterns
#     )
#
#
# @bp.route("/blind75")
# def blind75():
#     query = write_query("blind75")
#     problems = execute_query(query)
#     patterns = get_patterns(problems)
#     return render_template(
#         "problems/blind75.html.jinja2", problems=problems, patterns=patterns
#     )
