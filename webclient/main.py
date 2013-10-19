from flask import Flask, render_template, request
import json
from subprocess import Popen, PIPE, STDOUT

# Initializing the app
app = Flask(__name__)

def serialize_state(board, grid_n, cell_n, last_player):
    ser = str()
    ser += ":- ['ai1.pl'].\n"
    ser += ':- asserta(gameField({})).\n'.format(json.dumps(board))
    ser += ':- asserta(lastMove({}, {}, {})).\n'.format(grid_n, cell_n, last_player)

    return ser

def ai_call(board, grid_n, cell_n, last_player):
    with open('../input.pl', 'w') as input_file:
        input_file.write(serialize_state(board, grid_n, cell_n, last_player))

    p = Popen(['prolog', '-q', '-s', '../main.pl'], stdin=PIPE, stdout=PIPE, stderr=STDOUT)
    output = p.communicate()
    print "OUTPUT = ", output[0].strip()
    output_tokens = output[0].strip().split(' ')
    board = json.loads(output_tokens[0])
    playable_grids = json.loads(output_tokens[1])
    state = json.loads(output_tokens[2])
    last = json.loads(output_tokens[3])
    last_move = dict(grid=last[0], cell=last[1], player=last[2])
    return dict(board=board, playable=playable_grids, state=state, last_move=last_move)


@app.route("/")
def index():
    return render_template('index.html')

@app.route("/play", methods=["POST"])
def play():
    data = json.loads(request.form.keys()[0])

    # Applying the current player's move
    player = int(data['player'])
    grid = int(data['grid'])
    cell = int(data['cell'])
    board = data['board']
    board[grid - 1][cell - 1] = player

    # Calling the AI for the next move
    print 'Calling AI with :', board, grid, cell, player
    resp = ai_call(board, grid, cell, last_player=player)
    
    return json.dumps(resp)

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
