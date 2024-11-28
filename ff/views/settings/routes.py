from flask import render_template

from ff.views.settings import bp

@bp.route('/')
def index():
    return render_template('settings/index.html')
