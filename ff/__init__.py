import os
from flask import Flask

def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev',
        DATABASE=os.path.join(app.instance_path, 'ff.sqlite'),
    )

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
    from ff.main import bp as main_bp
    app.register_blueprint(main_bp)
    app.add_url_rule('/', endpoint='index')

    # from ff.auth import auth
    # app.register_blueprint(auth.bp)

    from ff.auth import bp as auth_bp
    app.register_blueprint(auth_bp, url_prefix='/auth')

    # register blueprint for problems
    # from ff.problems import problems
    # app.register_blueprint(problems.bp)
    # app.add_url_rule('/', endpoint='index')

    @app.route('/test/')
    def test_page():
        return '<h1>Testing the Flask Application Factory Pattern</h1>'


    return app
