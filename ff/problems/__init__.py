from flask import Blueprint

bp = Blueprint('problems', __name__)

from ff.problems import problems