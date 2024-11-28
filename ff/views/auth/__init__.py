from flask import Blueprint

bp = Blueprint('auth', __name__)

from ff.views.auth import routes
