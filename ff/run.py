"""
For debugging in pycharm
"""
# from ff import create_app
#
# app = create_app()
#
# def main():
#     print("welcome to ff!")
#
# if __name__ == "__main__":
#     main()
#     port = app.config.get('PORT', 5000)
#     app.run(host='localhost', port=port, debug=True)

from flask.cli import FlaskGroup
from ff import create_app

cli = FlaskGroup(create_app=create_app)

if __name__ == '__main__':
    cli()