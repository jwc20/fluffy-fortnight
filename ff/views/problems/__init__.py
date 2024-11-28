from flask import Blueprint

bp = Blueprint('problems', __name__)

from ff.views.problems import routes