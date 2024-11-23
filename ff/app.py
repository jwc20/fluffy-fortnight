from flask import Flask, render_template
from flask_wtf import FlaskForm
from wtforms import StringField, FormField, FieldList, IntegerField, Form
from wtforms.validators import Optional
from collections import namedtuple
import sqlite3
import sqlalchemy
#
# def main():
#     print("Hello from fluffy-fortnight!")
#
#
# if __name__ == "__main__":
#     main()



from ff import create_app

app = create_app()

if __name__ == "__main__":
    app.run()