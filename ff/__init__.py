import os
from flask import Flask
from ff.config import Config

def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_object(Config(app.instance_path))

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    # init db
    from ff import db
    db.init_app(app)

    # register blueprints
    from ff.views.main import bp as main_bp
    app.register_blueprint(main_bp)
    app.add_url_rule('/', endpoint='index')

    from ff.views.auth import bp as auth_bp
    app.register_blueprint(auth_bp, url_prefix='/auth')

    from ff.views.problems import bp as problems_bp
    app.register_blueprint(problems_bp, url_prefix='/problems')

    from ff.views.settings import bp as settings_bp
    app.register_blueprint(settings_bp, url_prefix='/settings')


    @app.route('/test/')
    def test_page():
        return '<h1>Testing the Flask Application Factory Pattern</h1>'


    return app
