#!/usr/bin/env python
# -*- coding: utf-8 -*-

from subprocess import Popen, PIPE, STDOUT
import json


def format_board(raw_board):
    result = [[0 for i in xrange(3)] for j in xrange(3)]

    for n, grid in enumerate(raw_board):
        x, y =  n / 3, n % 3
        result[x][y] = [grid[i*3:(i+1)*3] for i in xrange(3)]
    
    return result

def serialize_board(board):
    board = reduce(list.__add__, board)
    return [reduce(list.__add__, grid) for grid in board]

# RAW_BOARD = [ [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0],
#               [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0],
#               [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0] ]


# A board where all the grids can be taken in a one turn, except for the central grid
RAW_BOARD = [ [1, 1, 0, 0, 0, 0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0],
               [1, 1, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 1, 0, 2, 2, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0],
               [1, 1, 0, 0, 0, 0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0] ]

PLAYABLE = [(i,j) for i in xrange(3) for j in xrange(3)]
STATE = [0 for i in xrange(9)]
BOARD = format_board(RAW_BOARD)

def ai_call(ai, grid_n, cell_n, last_player):
    ser = str()
    ser += ":- ['{}'].\n".format(ai)
    ser += ':- asserta(gameField({})).\n'.format(json.dumps(BOARD))
    ser += ':- asserta(lastMove({}, {}, {})).\n'.format(grid_n, cell_n, last_player)

    with open('input.pl', 'w+') as input_file:
        input_file.write(ser)

    p = Popen(['prolog', '-q', '-s', 'main.pl'], stdin=PIPE, stdout=PIPE, stderr=STDOUT)
    output = p.communicate()
    print "OUTPUT = ", output[0].strip()
    output_tokens = output[0].strip().split(' ')
    board = json.loads(output_tokens[0])
    playable_grids = [((i-1) / 3, (i-1) % 3) for i in json.loads(output_tokens[1])]
    won_grids = json.loads(output_tokens[2])
    return dict(board=board, playable=playable_grids, state=won_grids)


# After 'format_board', the board looks like this:
# BOARD = [ [ [[0, 1, 0], [1, 2, 1], [0, 0, 1]], [[0, 1, 0], [1, 2, 1], [0, 0, 1]], [[0, 1, 0], [1, 2, 1], [0, 0, 1]] ],
#           [ [[0, 1, 0], [1, 2, 1], [0, 0, 1]], [[0, 1, 0], [1, 2, 1], [0, 0, 1]], [[0, 1, 0], [1, 2, 1], [0, 0, 1]] ],
#           [ [[0, 1, 0], [1, 2, 1], [0, 0, 1]], [[0, 1, 0], [1, 2, 1], [0, 0, 1]], [[0, 1, 0], [1, 2, 1], [0, 0, 1]] ] ]

SYMBOL = {0: '_', 1: 'X', 2: 'O'}

def print_grid(grid):
    print ' '*3,
    for i in xrange(3):
        print '{}'.format(i),
    print ''
    for j, line in enumerate(grid):
        print ' {} '.format(j),
        print '|'.join(SYMBOL[val] for val in line)

    print ''


def print_board(board, x=-1, y=-1):
    print ' '*4,
    for i in xrange(3):
        print '  {}    '.format(i),
    print ''
    print ' '*4 + '# '*12
    for j, boards_line in enumerate(board):

        for l in xrange(3):
            print ' {} #'.format(j if l == 1 else ' '),

            for i, grid in enumerate(boards_line):
                print '|'.join(SYMBOL[val] for val in grid[l]),
                print '#' if i in {y - 1, y} and j == x else '|',
            print ''
        
        line_sep = ' '*3 + '#'
        for n in xrange(24):
            line_sep += '#' if n  / 8 == y and j in {x - 1, x} else '−'  

        print line_sep

def get_coords(message):
    while True:
        try:
            x, y = map(int, raw_input('{} (format: ligne,colonne). Ex: 1,2 \n'.format(message)).split(','))
            return x, y
        except ValueError, TypeError:
            print "* Coordonnées invalides, merci de choisir d'autres coordonnées.\n"

def play(grid, player):
    print ''
    print_grid(grid)
    print ''

    valid_move = False
    while not valid_move:
        x, y = get_coords('Quelle case souhaitez vous jouer?')
        valid_move = grid[x][y] == 0 and STATE[x * 3 + y] == 0
        if not valid_move:
            print '* Case déjà occupée! Veuillez choisir une autre case.\n'    
    grid[x][y] = player
    
    print ''
    print_grid(grid)
    print ''

    return x, y

if __name__ == '__main__':
    
    print ' ____ ___.__   __  .__                __          '
    print '|    |   \\  |_/  |_|__| _____ _____ _/  |_  ____  '
    print '|    |   /  |\\   __\\  |/     \\\\__  \\\\   __\\/ __ \\ '
    print '|    |  /|  |_|  | |  |  Y Y  \\/ __ \\|  | \\  ___/ '
    print '|______/ |____/__| |__|__|_|  (____  /__|  \\___  >'
    print '                            \\/     \\/          \\/ '
    print '___________.__                 ___________                       ___________            '
    print '\\__    ___/|__| ____           \\__    ___/____    ____           \\__    ___/___   ____  '
    print '  |    |   |  |/ ___\\   ______   |    |  \\__  \\ _/ ___\\   ______   |    | /  _ \\_/ __ \\ '
    print '  |    |   |  \\  \\___  /_____/   |    |   / __ \\\\  \\___  /_____/   |    |(  <_> )  ___/ '
    print '  |____|   |__|\\___  >           |____|  (____  /\\___  >           |____| \\____/ \\___  >'
    print '                   \\/                         \\/     \\/                              \\/ '
    print '-'*100
    print ''
    
    player = 1
    print_board(BOARD)
    
    while PLAYABLE:
        if len(PLAYABLE) == 1:
            g_x, g_y = PLAYABLE[0][0], PLAYABLE[0][1]
        else:
            valid_grid = False
            while not valid_grid:
                print_board(BOARD, -1, -1)
                g_x, g_y = get_coords('Quelle grille souhaitez vous choisir? (parmi: {})'.format(PLAYABLE))
                valid_grid = (g_x, g_y) in PLAYABLE

        print ''
        print '# '*40
        print '# TOUR DU JOUEUR {} (Signe "{}")'.format(player, SYMBOL[player])
        print '#  -> Ce tour se fera sur la grille ({}, {})'.format(g_x, g_y)
        print '# '*40
        print ''


        print_board(BOARD, g_x, g_y)
        c_x, c_y = play(BOARD[g_x][g_y], player)
        print_board(BOARD,g_x,g_y)
        # Calling the AI
        grid_n = g_x * 3 + g_y + 1
        cell_n = c_x * 3 + c_y + 1
        data = ai_call('ai1.pl', grid_n, cell_n, last_player=1)
        
        print 'raw board', data['board']
        print 'board', format_board(data['board'])
        BOARD = format_board(data['board'])


        PLAYABLE = data['playable']
        STATE = data['state']
