from flask import (
    Blueprint, render_template
)
import functools
from flask import (Blueprint, flash, g, redirect, render_template, request, session, url_for)
from werkzeug.security import check_password_hash, generate_password_hash
from ff.db import get_db

from ff.main import bp


@bp.route('/')
def index():
    print("index")
    return render_template("index.html")
    # return '<h1>Testing the Flask Application Factory Pattern</h1>'