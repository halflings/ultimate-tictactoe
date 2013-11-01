from flask import Flask, render_template, request
import json
from subprocess import Popen, PIPE, STDOUT

# Initializing the app
app = Flask(__name__)

def ai_call(ai, board, grid_n, cell_n, last_player):
    ser = str()
    ser += ":- ['{}'].\n".format(ai)
    ser += ':- asserta(gameField({})).\n'.format(json.dumps(board))
    ser += ':- asserta(lastMove({}, {}, {})).\n'.format(grid_n, cell_n, last_player)

    with open('../input.pl', 'w+') as input_file:
        input_file.write(ser)

    p = Popen(['prolog', '-q', '-s', '../main.pl'], stdin=PIPE, stdout=PIPE, stderr=STDOUT)
    raw_output = p.communicate()
    output = raw_output[0].strip()
    output_tokens = output.split(' ')

    try:
        board = json.loads(output_tokens[0])
        playable_grids = json.loads(output_tokens[1])
        state = json.loads(output_tokens[2])
        last = json.loads(output_tokens[3])
        last_move = dict(grid=last[0], cell=last[1], player=last[2])
        return dict(board=board, playable=playable_grids, state=state, last_move=last_move)
    except ValueError as e:
        print "OUTPUT =\n{}\n".format(output)
        raise e

def nextPlayer(player):
    return 1 if player == 2 or player == -1 else 2

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
    ai = data['ai']
    finish_game = data['finish_game']
    board = data['board']
    board[grid - 1][cell - 1] = player


    if not finish_game:
        # Calling the AI for one move
        player_ai = ai[str(nextPlayer(player))]
        resp = ai_call(player_ai, board, grid, cell, last_player=player)
    else:
        # Calling the AI until the game is over
        playing = True
        while playing:
            player_ai = ai[str(nextPlayer(player))]
            resp = ai_call(player_ai, board, grid, cell, last_player=player)

            board = resp['board']
            grid, cell, player = resp['last_move']['grid'], resp['last_move']['cell'], resp['last_move']['player']

            playing = len(resp['playable']) != 0


    return json.dumps(resp)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8037, debug=True)
