from flask import render_template

from ff.db import get_db

from ff.main import bp

@bp.route('/')
def index():
    return render_template("index.html")
