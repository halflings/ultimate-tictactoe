// Initialization
SYMBOL = {1: 'X', 2: 'O', 0: '&nbsp;'}
PLAYABLE = [1, 2, 3, 4, 5, 6, 7, 8, 9]
// BOARD = [ [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0],
//           [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0],
//           [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0]];

// BOARD = [ [1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1],
//           [1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 0, 0, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1],
//           [1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1, 1]];

BOARD = [ [1, 1, 0, 0, 0, 0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0],
               [1, 1, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 1, 0, 2, 2, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0],
               [1, 1, 0, 0, 0, 0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0] ]


STATE = [0, 0, 0, 0, 0, 0, 0, 0, 0];
LAST_MOVE = {grid:-1, cell:-1, player:2};

checkWinner = function() {
    // Horizontal  
    for (var i = 0; i < STATE.length; i+= 3) {
        if (STATE[i] == STATE[i+1] && STATE[i+1] == STATE[i+2]) {
            return STATE[i];
        }
    }

    // Vertical
    for (var i = 0; i < 3; i++) {
        if (STATE[i] == STATE[i+3] && STATE[i+3] == STATE[i+6]) {
            return STATE[i];
        }
    }

    // Diagonal
    if ((STATE[0] == STATE[4] && STATE[4] == STATE[8]) || (STATE[2] == STATE[4] && STATE[4] == STATE[5])) {
        return STATE[4];
    }

    return 0;
}

updateGame = function() {
    var next_player = LAST_MOVE.player;
    var current_player = 3 - next_player;

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

    // Clearing all previous marking
    $('.gamefield > ul').removeAttr('class');
    // Marking-up playable cells
    for (var i = 0; i < PLAYABLE.length; i++) {
        $('.gamefield > ul:nth-child('+PLAYABLE[i]+')').addClass('playable');
    }

    // Applying grid states (won, etc.)
    for (var i = 0; i < STATE.length; i ++) {
        var grid_state = STATE[i];
        if (grid_state != 0) {
            $('.gamefield > ul:nth-child('+(i + 1)+')').addClass('won player' + grid_state);
        }
    }

    // Marking-up the last move
    $('.gamefield > ul:nth-child('+(LAST_MOVE.grid)+') > li:nth-child('+(LAST_MOVE.cell)+')').attr('class', 'last-move');


    // Checking if the game ended
    winner = checkWinner();

    if (winner != 0) {
        // Do something
    }
} 

$(document).ready(function() {
    updateGame();

    //Adding callbacks on cell clicks
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


        var sent_data = {
            board: BOARD,
            player: LAST_MOVE.player,
            grid:grid.index() + 1,
            cell:cell.index() + 1
          }
        console.log('Sending : ');
        console.log(sent_data);

        $.ajax({
          url: "/play",
          type: 'POST',
          data: JSON.stringify(sent_data),
          dataType: "json",
          success: function (data) {
                console.log('RECEIVED : ');
                console.log(data);

                PLAYABLE = data.playable;
                STATE = data.state;
                BOARD = data.board;
                LAST_MOVE = data.last_move;

                updateGame();
          }
        });
        
    }); // End of cell-click event

 
}); // End of document initialization
