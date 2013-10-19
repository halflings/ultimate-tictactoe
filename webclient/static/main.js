// Initialization
SYMBOL = {1: 'X', 2: 'O', 0: '&nbsp;'}
PLAYABLE = [6]
BOARD = [ [1, 1, 0, 0, 0, 2, 0, 0, 0], [1, 0, 1, 0, 0, 0, 2, 2, 2], [1, 0, 0, 2, 0, 0, 1, 0, 2],
          [1, 0, 2, 1, 0, 2, 1, 2, 0], [0, 2, 0, 0, 1, 0, 2, 2, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0],
          [1, 1, 0, 0, 0, 0, 0, 0, 0], [1, 1, 0, 0, 2, 0, 2, 0, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0] ];
STATE = [0, 1, 0, 2, 0, 0, 0, 0, 0];

// TODO : Require AI to return the last move to update this
LAST_MOVE = {grid:1, cell:6, player:2};

updateGame = function() {
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
} 

$(document).ready(function() {
    updateGame();

    //Adding callbacks
    $('.gamefield > ul > li').click(function(event) {
        var cell = $(event.target);
        var grid = cell.parent();

        if (grid.attr('class') != 'playable' || BOARD[grid.index()][cell.index()] != 0) {
            return;
        }

        // Updating the grid with the move and displaying it
        LAST_MOVE.player = 3 - LAST_MOVE.player;
        LAST_MOVE.grid = grid.index() + 1;
        LAST_MOVE.cell = cell.index() + 1;
        BOARD[grid.index()][cell.index()] = LAST_MOVE.player; 

        updateGame();



        console.log('Sending : ');
        console.log({
            board: BOARD,
            player: current_player,
            grid:grid.index() + 1,
            cell:cell.index() + 1
          });


        $.ajax({
            url: '/play',
            method: 'POST',
            data: {
                board: BOARD,
                player: current_player,
                grid:grid.index() + 1,
                cell:cell.index() + 1
            },
            success : function (data) {
                console.log('RECEIVED : ');
                console.log(data);
            }

        });
        
    }); // End of cell-click event

 
});
