class ComputerPlayer{
  int player; // or -1
  double evaluatePosition(Board b){
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
    double scalar = 10;
    if(b.empty_count < 10){
      
    }
    return scalar*(ai_score - enemy_score);
  }

  double evaluationByMobility(Board b){
    double scalar = max(min(5, b.empty_count - 5), 0);
    return scalar * (double) b.generatePossibleMoves().size();
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
    
    double scalar;
    if(b.empty_count > 20){
        
    } else {

    }
    return scalar * (sum_ai - sum_enemy);
  }

  void move(Board b){
    player = b.turn;
    MoveEvalPair pair;
    if(player == -1){
      pair = minimax(b, 3);
    } else {
      pair = minimax(b, 5);
    }
    println("Picked:", b.turn, pair.mv.x_index, pair.mv.y_index, pair.eval);
    println();
    /* println(evaluatePosition(b)); */
    b.place(pair.mv);
  }

  MoveEvalPair minimax(Board b, int depth){
    ArrayList<Square> moves = b.generatePossibleMoves();
    if(depth == 1){
      double optimalScore = -b.turn*player*10000000;
      Square optimalMove = moves.get(0);
      Board temp;
      int res;
      for(Square m : moves){
        temp = new Board(b);
        res = temp.ai_place(m);
        double score;
        if ( res * player > 0 ){
          score = 100000000;  
        } else if ( res * player == 0){
          score = evaluatePosition(temp);
        } else {
          score = -100000000;
        }

        if(b.turn == player && score > optimalScore){
          optimalScore = score;
          optimalMove = m;
        } else if (b.turn != player && score < optimalScore){
          optimalScore = score;
          optimalMove = m;
        }
      }
      /* println("Optimal: ", b.turn, optimalMove.x_index, optimalMove.y_index, optimalScore); */
      /* println(); */
      return new MoveEvalPair(optimalMove, optimalScore);
    } else {
      double optimalScore = -b.turn*player*10000000;
      Square optimalMove = moves.get(0);
      Board temp;
      int res;
      for(Square m : moves){
        temp = new Board(b);
        res = temp.ai_place(m);
        double score;
        if ( res * player > 0 ){
          score = 100000000;  
        } else if ( res * player == 0){
          MoveEvalPair bestNext = minimax(temp, depth-1);
          score = bestNext.eval;
        } else {
          score = -100000000;
        }

        if(b.turn == player && score > optimalScore){
          optimalScore = score;
          optimalMove = m;
        } else if (b.turn != player && score < optimalScore){
          optimalScore = score;
          optimalMove = m;
        }
      }
      /* println("Optimal: ", b.turn, optimalMove.x_index, optimalMove.y_index, optimalScore); */
      /* println(); */
      return new MoveEvalPair(optimalMove, optimalScore);
    }
  } 
} 

    class MoveEvalPair{
      Square mv;
      double eval;
      MoveEvalPair(Square m, double ev){
        mv = m;
        eval = ev;
      }
    }
