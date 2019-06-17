import java.util.ArrayList;
class Board{

  int[][] board = new int[8][8];
  int turn = 1;
  color dark = color(0, 255, 0);
  color light = color(0, 0, 255);
  float sq_size = min((width-300)/8, (height-100)/8);
  int empty_count = 60;

  Board(){
    // initialize board
    for(int i = 0; i < 8; i++){
      for(int j = 0; j < 8; j++){
        board[i][j] = 0;
      }
    }

    board[3][3] = 1;
    board[4][4] = 1;
    board[3][4] = -1;
    board[4][3] = -1;
  }

  Board(Board b){
    for(int i = 0; i < 8; i++){
      for(int j = 0; j < 8; j++){
        board[i][j] = b.board[i][j];
      }
    }
    turn = b.turn;
    empty_count = b.empty_count;
  }

  void display(){
    background(100, 100, 100);
    // first display the checkerboard
    float x = 50;
    float y = 50;
    boolean dark_square = true;


    for( int ix = 0; ix < 8; ix++){
      for( int iy = 0; iy < 8; iy++ ){
        if(dark_square){
          fill(0);
        } else {
          fill(255);
        }
        square(x, y, sq_size);

        //display the pieces
        if(board[ix][iy] > 0){
          fill(dark);
          circle(x+sq_size/2, y+sq_size/2, 0.9*sq_size);
        } else if(board[ix][iy] < 0){
          fill(light);
          circle(x+sq_size/2, y+sq_size/2, 0.9*sq_size);
        }
        y += sq_size;
        dark_square = !dark_square;
      }
      dark_square = !dark_square;
      x += sq_size;
      y = 50;
    }

    // generate the score
    // fix this later cuz this is pathetic
    int s1 = 0;
    int s2 = 0;
    for(int i = 0; i < 8; i++){
      for(int j = 0; j < 8; j++){
        if(board[i][j] == 1){
          s1++;
        } else if(board[i][j] == -1){
          s2++;
        }
      }
    }
    textSize(50);
    fill(dark);
    text("P1: " + s1,  width - 250, height*3.0/7.0);
    fill(light);
    text("P2: " + s2, width - 250, height*4.0/7.0);

    if(turn == 1){
      fill(dark);
      circle(width - 50, height*2.85/7.0, 40);
    } else {
      fill(light);
      circle(width - 50, height*3.85/7.0, 40);
    }
  }

  void place(int ix, int iy){
    if(!checkValid(ix, iy)){
      println("Invalid Placement Try Again");
      return;
    }

    // place the piece
    board[ix][iy] = turn;
    empty_count--;

    // loop through and flip each direction
    for(int dx = -1; dx <= 1; dx++){
      for(int dy = -1; dy <= 1; dy++){
        if(dx != 0 || dy != 0){
          if(checkDirection(ix, iy, dx, dy)){
            flipDirection(ix, iy, dx, dy);
          }
        }
      }
    }

    turn = -turn;
    if(checkGameOver()){
      gameover();
    }
  }

  void place(Square s){
    place(s.x_index, s.y_index);
  }

  // this function skips some of the checks because they are not important for
  // the ai. Returns the value of the winner if it exists or 0 if not
  private int ai_place(int ix, int iy){
    board[ix][iy] = turn;
    empty_count--;

    // loop through and flip each direction
    for(int dx = -1; dx <= 1; dx++){
      for(int dy = -1; dy <= 1; dy++){
        if(dx != 0 || dy != 0){
          if(checkDirection(ix, iy, dx, dy)){
            flipDirection(ix, iy, dx, dy);
          }
        }
      }
    }

    turn = -turn;
    if(checkGameOver()){
      int sum = 0;
      for(int i = 0; i < 8; i++){
        for(int j = 0; j < 8; j++){
          sum += board[i][j];
        }
      }
      return sum;
    }
    return 0;
  }

  private int ai_place(Square s){
    return ai_place(s.x_index, s.y_index);
  }

  void flipDirection(int ix, int iy, int dx, int dy){
    while(board[ix+dx][iy+dy]*turn < 0 && ix + dx >= 0 && ix + dx <= 7 && iy + dy >= 0 && iy + dy <= 7){
      ix = ix + dx;
      iy = iy + dy;
      board[ix][iy] = turn;
    }
  }

  boolean checkValid(int ix, int iy){
    // check in every direction
    return board[ix][iy] == 0 && 
      ( checkDirection(ix, iy, -1, -1) 
        || checkDirection(ix, iy, -1, 0)
        || checkDirection(ix, iy, -1, 1)
        || checkDirection(ix, iy, 0, -1)
        || checkDirection(ix, iy, 0, 1)
        || checkDirection(ix, iy, 1, -1)
        || checkDirection(ix, iy, 1, 0)
        || checkDirection(ix, iy, 1, 1));
  }

  boolean checkDirection(int ix, int iy, int dx, int dy){
    // then checking placement out of bounds
    if( ix + dx < 0 || iy + dy < 0 || ix + dx > 7 || iy + dy > 7){
      return false;
    }
    if(board[ix+dx][iy+dy] == 0 || board[ix+dx][iy+dy] == turn){
      return false;
    }
    while(ix + dx >= 0 && ix + dx <= 7 && iy + dy >= 0 && iy + dy <= 7 && board[ix+dx][iy+dy]*turn < 0){
      ix = ix + dx;
      iy = iy + dy;
    }
    if(ix + dx > 7 || ix + dx < 0 || iy + dy > 7 || iy + dy < 0 || board[ix+dx][iy+dy] != turn){
      return false;
    }
    return true;
  }

  void mouseToPiece(int x, int y){
    // first convert x, y to proper coordinates
    int ix = floor((x - 50)/sq_size);
    int iy = floor((y - 50)/sq_size);
    if(ix < 0 || ix > 7 || iy < 0 || iy > 7){
      return;
    }
    /* println(ix, iy); */
    /* for(int dx = -1; dx <= 1; dx++){ */
    /*   for(int dy = -1; dy <= 1; dy++){ */
    /*     if(dx != 0 || dy != 0){ */
    /*       println(dx, dy, checkDirection(ix, iy, dx, dy)); */
    /*     } */
    /*   } */
    /* } */
    place(ix, iy);
  }

  boolean checkGameOver(){
    return empty_count == 0 || !validMovesRemain();
  }

  void gameover(){
    // generate the score
    // fix this later cuz this is pathetic
    int s1 = 0;
    int s2 = 0;
    for(int i = 0; i < 8; i++){
      for(int j = 0; j < 8; j++){
        if(board[i][j] == 1){
          s1++;
        } else if(board[i][j] == -1){
          s2++;
        }
      }
    }
    textSize(32);
    text("GAME OVER!", width-200, 5*height/7.0);
    changed = false;
  }

  ArrayList<Square> generatePossibleMoves(){
    ArrayList<Square> moves = new ArrayList<Square>();
    for(int ix = 0; ix < 8; ix++){
      for(int iy = 0; iy < 8; iy++){
        if(board[ix][iy] == 0){
          if(checkValid(ix, iy)){
            moves.add(new Square(ix, iy)); 
          }
        }
      }
    }
    return moves;
  }

  //checks if the player has a valid move (more efficient than above method)
  boolean validMovesRemain(){
    for(int ix = 0; ix < 8; ix++){
      for(int iy = 0; iy < 8; iy++){
        if(board[ix][iy] == 0){
          if(checkValid(ix, iy)){
            return true;
          }
        }
      }
    }
    return false;
  }

}

class Square{
  int x_index, y_index;
  Square(int x, int y){
    x_index = x;
    y_index = y;
  }
}
