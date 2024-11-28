from flask import Blueprint

bp = Blueprint('settings', __name__)

from ff.views.settings import routes