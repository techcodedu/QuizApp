from flask import Flask
from flask_mysqldb import MySQL

app = Flask(__name__)

app.secret_key = 'quiz_app'

# Configure the database
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'quizgamedb'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

from quizapp.routes import *
