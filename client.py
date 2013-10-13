#!/usr/bin/env python
# -*- coding: utf-8 -*-

import itertools

# RAW_BOARD = [ [0, 1, 0, 1, 2, 1, 0, 0, 1], [0, 1, 0, 1, 2, 1, 0, 0, 1], [0, 1, 0, 1, 2, 1, 0, 0, 1],
#               [0, 1, 0, 1, 2, 1, 0, 0, 1], [0, 1, 0, 1, 2, 1, 0, 0, 1], [0, 1, 0, 1, 2, 1, 0, 0, 1],
#               [0, 1, 0, 1, 2, 1, 0, 0, 1], [0, 1, 0, 1, 2, 1, 0, 0, 1], [0, 1, 0, 1, 2, 1, 0, 0, 1] ]

# RAW_BOARD = [ [0, 0, 0, 0, 1, 0, 0, 0, 0], [0, 2, 0, 0, 0, 0, 0, 1, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0],
#               [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 2, 0, 0, 0, 0, 0], [1, 2, 0, 0, 0, 0, 0, 1, 0],
#               [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 2, 0, 0, 0, 0, 0, 2, 2], [0, 0, 0, 0, 0, 0, 0, 0, 0] ] 

RAW_BOARD = [ [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0] ]


def split_boards(raw_board):
    result = [[0 for i in xrange(3)] for j in xrange(3)]

    for n, subboard in enumerate(raw_board):
        x, y = n % 3, n / 3
        result[x][y] = [subboard[i*3:(i+1)*3] for i in xrange(3)]
    
    return result

def merge_boards(board):
    board = reduce(list.__add__, board)
    return [reduce(list.__add__, sb) for sb in board]

BOARD = split_boards(RAW_BOARD)

# After 'split_boards', the board looks like this:
# BOARD = [ [ [[0, 1, 0], [1, 2, 1], [0, 0, 1]], [[0, 1, 0], [1, 2, 1], [0, 0, 1]], [[0, 1, 0], [1, 2, 1], [0, 0, 1]] ],
#           [ [[0, 1, 0], [1, 2, 1], [0, 0, 1]], [[0, 1, 0], [1, 2, 1], [0, 0, 1]], [[0, 1, 0], [1, 2, 1], [0, 0, 1]] ],
#           [ [[0, 1, 0], [1, 2, 1], [0, 0, 1]], [[0, 1, 0], [1, 2, 1], [0, 0, 1]], [[0, 1, 0], [1, 2, 1], [0, 0, 1]] ] ]

SYMBOL = {0: '_', 1: 'X', 2: 'O'}

def print_miniboard(miniboard):
    print ' '*3,
    for i in xrange(3):
        print '{}'.format(i),
    print ''
    for j, line in enumerate(miniboard):
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

            for i, subboard in enumerate(boards_line):
                print '|'.join(SYMBOL[val] for val in subboard[l]),
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

def play(miniboard, player):
    print ''
    print_miniboard(miniboard)
    print ''

    valid_move = False
    while not valid_move:
        x, y = get_coords('Quelle case souhaitez vous jouer?')
        valid_move = miniboard[x][y] == 0
        if not valid_move:
            print '* Case déjà occupée! Veuillez choisir une autre case.\n'    
    miniboard[x][y] = player
    
    print ''
    print_miniboard(miniboard)
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
    x, y = get_coords('Quelle grille souhaitez vous choisir pour débuter le jeu?')
    haha = "name"
    
    while True:
        print ''
        print '# '*40
        print '# TOUR DU JOUEUR {} (Signe "{}")'.format(player, SYMBOL[player])
        print '#  -> Ce tour se fera sur la grille ({}, {})'.format(x, y)
        print '# '*40
        print ''
        print_board(BOARD, x, y)

        x, y = play(BOARD[x][y], player)
        player = 3 - player
