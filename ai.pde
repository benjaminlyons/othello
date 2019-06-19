class ComputerPlayer{
  int player; // or -1
  int overall_depth = 6;
  double evaluatePosition(Board b){
    if(b.checkGameOver()){
      int sum = 0;
      for(int i = 0; i < 8; i++){
        for(int j = 0; j < 8; j++){
          sum += b.board[i][j];
        }
      }
      if(sum * player > 0){
        return 1000000;
      } else if (sum * player < 0){
        return -1000000;
      } else {
        return 0;
      }
    }
    /* println("Weights: " + weightBySquare(b)); */
    /* println("Count: " + countDifference(b)); */
    /* println("Mobility: " + evaluationByMobility(b)); */
    /* println("Total: " + (weightBySquare(b) + countDifference(b) + evaluationByMobility(b))); */
    /* println(); */
    return weightBySquare(b) + countDifference(b) + evaluationByMobility(b);   
  }

  double countDifference(Board b){
    int ai_score = 0;
    int enemy_score = 0;
    for(int i = 0; i < 7; i++){
      for(int j = 0; j < 7; j++){
        if(b.board[i][j] == player){
          ai_score += 1;
        } else if (b.board[i][j] == -player){
          enemy_score += 1;
        }
      }
    }
    if(ai_score == 0){
      return -1000000;
    }
    if(enemy_score == 0){
      return 1000000;
    }
    double dif = (ai_score - enemy_score) * 10;
    if(b.empty_count <= overall_depth){
      return dif;
    } else if (b.empty_count < 10){
      dif = 0.09*(10-b.empty_count)*dif + 0.1;
    } else {
      dif = dif * .001;
    }
    return dif;
  }

  double evaluationByMobility(Board b){
    double movement = b.generatePossibleMoves().size();
    movement *= 3;
    /* if(b.empty_count <= 20){ */
    /*   movement = (1-0.05*(20-b.empty_count))*movement; */
    /* } */
    return movement;
  }

  // relative square values were found online
  double weightBySquare(Board b){
    double[][] weights = new double[8][8];

    // Sadly, I don't know if there's a better
    // way to do this than simply hard coding it like this  
    // cuz this makes me want to puke :(
    // edges
    weights[0][0] = 150;
    weights[0][7] = 150;
    weights[7][0] = 150;
    weights[7][7] = 150;
    weights[1][0] = -8;
    weights[1][7] = -8;
    weights[6][0] = -8;
    weights[6][7] = -8;
    weights[2][0] = 8;
    weights[2][7] = 8;
    weights[5][0] = 8;
    weights[5][7] = 8;
    weights[3][0] = 6;
    weights[3][7] = 6;
    weights[4][0] = 6;
    weights[4][7] = 6;
    weights[0][1] = -8;
    weights[0][6] = -8;
    weights[0][2] = 8;
    weights[0][5] = 8;
    weights[0][4] = 8;
    weights[0][3] = 8;
    weights[7][1] = -8;
    weights[7][6] = -8;
    weights[7][2] = 8;
    weights[7][3] = 6;
    weights[7][4] = 6;
    weights[7][5] = 8;

    // inner layer
    weights[1][1] = -24;
    weights[1][6] = -24;
    weights[6][1] = -24;
    weights[6][6] = -24;

    for(int i = 2; i < 6; i++){
      weights[1][i] = -4;
      weights[6][i] = -4;
      weights[i][1] = -4;
      weights[i][6] = -4;
    }

    for(int i = 3; i < 5; i++){
      weights[2][i] = 4;
      weights[5][i] = 4;
      weights[i][2] = 4;
      weights[i][5] = 4;
    }
    weights[2][2] = 7;
    weights[2][5] = 7;
    weights[5][2] = 7;
    weights[5][5] = 7;
    weights[3][3] = 0;
    weights[4][4] = 0;
    weights[3][4] = 0;
    weights[4][3] = 0;

    double sum_ai = 0;
    double sum_enemy = 0;
    for(int xi = 0; xi < 7; xi++){
      for(int yi = 0; yi < 7; yi++){
        if(b.board[xi][yi] == player){
          sum_ai += weights[xi][yi];
        } else if(b.board[xi][yi] == -player){
          sum_enemy += weights[xi][yi];
        }
      }
    }

    double dif = sum_ai - sum_enemy;
    /* if(b.empty_count <= 16){ */
    /*   dif = (b.empty_count * (32.0 - (double)b.empty_count) / 256.0) * dif; */
    /* } */
    return dif;
  }

  void move(Board b){
    player = b.turn;
    if(b.empty_count < 15){
       overall_depth = b.empty_count;
    }
    ArrayList<Square> moves = b.generatePossibleMoves();
    Square optimalMove = moves.get(0);
    double optimalScore = -10000000;
    Board temp;
    double score;
    // loop through each possible move
    for(Square mv : moves){
      temp = new Board(b); 
      // make the move
      temp.ai_place(mv);
      /* score = minimax(temp, overall_depth-1); */
      score = alphabeta(temp, overall_depth - 1, -10000000, 10000000);
      // if its a good move, then use it
      if(score > optimalScore){
        optimalMove = mv;
        optimalScore = score;
      }
    }

    println("Picked: ", optimalMove.x_index, optimalMove.y_index, optimalScore);
    println();
    b.place(optimalMove);
  } 

  double minimax(Board b, int depth){
    if(depth == 0 || b.checkGameOver() || !b.validMovesRemain()){
      return evaluatePosition(b);
    } else {
       double optimalScore = - player * b.turn * 1000000;
       ArrayList<Square> moves = b.generatePossibleMoves();
       Board temp;
       double score;
       for(Square mv : moves){
         temp = new Board(b);
         temp.ai_place(mv);
         score = minimax(temp, depth - 1);
         if(player == b.turn && score > optimalScore){
            optimalScore = score;
         } else if(player != b.turn && score < optimalScore){
            optimalScore = score;
         }
       }
       return optimalScore;
    }
  } 
  
  // a is minimum score we are assured of
  // b is maximum score the minimum player is assured of
  double alphabeta(Board b, int depth, double a, double beta){
    if(depth == 0 || b.checkGameOver() || !b.validMovesRemain()){
      return evaluatePosition(b);
    }
    // if we are trying to maximize
    if(player == b.turn){
      double optimalScore = -player*b.turn*1000000;
      ArrayList<Square> moves = b.generatePossibleMoves();
      Board temp;
      double score;
      for(Square mv : moves){
        temp = new Board(b);
        temp.ai_place(mv);
        score = alphabeta(temp, depth-1, a, beta);

        if(score  > a){
          a = score;
        }

        if(score > optimalScore){
          optimalScore = score;
        }
        if(beta <= a){
          return optimalScore;
        }
      }
      return optimalScore;
    } else { // here we are trying to minimize
      double optimalScore = -player*b.turn*1000000;
      ArrayList<Square> moves = b.generatePossibleMoves();
      Board temp;
      double score;
      for(Square mv : moves){
        temp = new Board(b);
        temp.ai_place(mv);
        score = alphabeta(temp, depth-1, a, beta);
        if(score < beta){
          beta = score;
        }
        if(score < optimalScore){
          optimalScore = score;
        }
        if(beta <= a){
          return optimalScore;
        }
      }
      return optimalScore;
    }
  }
} 
