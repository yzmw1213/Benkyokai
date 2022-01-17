from flask import Flask

app = Flask(__name__)


@app.route('/', methods=['GET'])
def index():
    return 'Hello index'


@app.route('/user', methods=['GET'])
def getUser():
    return 'Hello user'


app.run('0.0.0.0', 5000, debug=True)
