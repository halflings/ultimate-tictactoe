// Initialization
SYMBOL = {1: 'X', 2: 'O', 0: '&nbsp;'}

$(document).ready(function() {

    PLAYABLE = [6]
    BOARD= [ [1, 1, 0, 0, 0, 2, 0, 0, 0], [1, 0, 1, 0, 0, 0, 2, 2, 2], [1, 0, 0, 2, 0, 0, 1, 0, 2],
             [1, 0, 2, 1, 0, 2, 1, 2, 0], [0, 2, 0, 0, 1, 0, 2, 2, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0],
             [1, 1, 0, 0, 0, 0, 0, 0, 0], [1, 1, 0, 0, 2, 0, 2, 0, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0] ];

    LAST_MOVE = {grid:1, cell:6, player:2};

    next_player = LAST_MOVE.player;
    current_player = 3 - next_player;

    // Displaying the current player
    $('.current-player').text(SYMBOL[current_player]);
    $('.next-player').text(SYMBOL[next_player]);

    // Filling the grids
    for(var i = 0; i < BOARD.length; i++) {
        var grid = BOARD[i];
        for (var j = 0; j < grid.length; j++) {
            cell_v = grid[j];
            cell_s = SYMBOL[cell_v];
            $('.gamefield > ul:nth-child('+(i + 1)+') > li:nth-child('+(j + 1)+')').html(cell_s).removeAttr('class');
        }
    }

    // Marking-up playable cells
    for (var i = 0; i < PLAYABLE.length; i++) {
        $('.gamefield > ul:nth-child('+PLAYABLE[i]+')').attr('class', 'playable');
    }

    // Marking-up the last move
    $('.gamefield > ul:nth-child('+(LAST_MOVE.grid)+') > li:nth-child('+(LAST_MOVE.cell)+')').attr('class', 'last-move');

 
});