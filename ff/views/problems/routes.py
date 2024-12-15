from flask import render_template, abort
from jinja2 import TemplateNotFound

from ff.db import get_db
from ff.views.problems import bp


def get_patterns(problems):
    patterns = {}
    for problem in problems:
        if problem["patterns"] is None:
            continue
        else:
            problem_patterns = problem["patterns"].split(",")
            for pattern in problem_patterns:
                pattern = pattern.strip()
                if pattern in patterns:
                    patterns[pattern] += 1
                else:
                    patterns[pattern] = 1
    return patterns


def write_query():
    return (
        "with selected_problems as ("
        "SELECT p.id, p.leetcode_number, p.title, p.link, p.description,"
        "p.difficulty_rating as difficulty,"
        "p.is_premium, p.created_at, p.updated_at, p.deleted_at,"
        "p.deleted, t.name as tag_name, GROUP_CONCAT(pa.name, ', ') as patterns "
        "FROM problems p "
        "LEFT JOIN problem_tags pt ON p.leetcode_number=pt.problem_id "
        "LEFT JOIN tags t ON pt.tag_id=t.id "
        "LEFT JOIN problem_patterns pp ON p.leetcode_number=pp.problem_id "
        "LEFT JOIN patterns pa ON pp.pattern_id=pa.id "
        "WHERE CASE WHEN ? IS NULL THEN 1=1 ELSE t.endpoint = ? END "
        "GROUP BY p.id "
        "ORDER BY p.leetcode_number"
        ") "
    )


# https://flask.palletsprojects.com/en/stable/patterns/sqlite3/
# def query_db(query, args=(), one=False):
def query_db(query, args, one=False):
    if len(args) == 2:
        _endpoint, _pattern = args
        if _endpoint == "index":
            _endpoint = None

        _pattern = f"{_pattern}"
        cur = get_db().execute(
            query,
            (
                _endpoint,
                _endpoint,
                _pattern,
            ),
        )

    else:
        _endpoint = args[0]
        if _endpoint == "index":
            _endpoint = None

        cur = get_db().execute(
            query,
            (
                _endpoint,
                _endpoint,
            ),
        )

    rv = cur.fetchall()
    cur.close()
    return (rv[0] if rv else None) if one else rv


@bp.route("/", defaults={"page": "index"})
@bp.route("/<page>")
@bp.route("/<page>/<pattern>")
def show(page, pattern=None):
    try:
        query = write_query()

        if pattern is None:
            query += "SELECT * FROM selected_problems;"
            problems = query_db(
                query,
                (page,),
            )
        else:
            query += "SELECT * FROM selected_problems WHERE instr(patterns, ?) > 0;"
            problems = query_db(
                query,
                (
                    page,
                    pattern,
                ),
            )

        all_patterns = get_patterns(problems)
        return render_template(
            f"problems/{page}.html.jinja2", problems=problems, all_patterns=all_patterns
        )
    except TemplateNotFound:
        abort(404)
