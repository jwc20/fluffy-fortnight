import os
from flask import Flask
from dotenv import load_dotenv

load_dotenv()


def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)

    port = os.getenv('FLASK_RUN_PORT', 8412)

    app.config.from_mapping(
        SECRET_KEY=os.getenv('FLASK_SECRET_KEY', 'dev'),
        DATABASE=os.path.join(app.instance_path, 'ff.sqlite'),
        PORT=port
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

    from ff.auth import bp as auth_bp
    app.register_blueprint(auth_bp, url_prefix='/auth')

    from ff.problems import bp as problems_bp
    # app.register_blueprint(problems.bp)
    app.register_blueprint(problems_bp, url_prefix='/problems')


    @app.route('/test/')
    def test_page():
        return '<h1>Testing the Flask Application Factory Pattern</h1>'


    return app
