from flask import Blueprint

bp = Blueprint('main', __name__)

from ff.main import routes