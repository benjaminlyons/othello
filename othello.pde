boolean changed = true;
Board b;
ComputerPlayer ai;
boolean gameover = false;
void setup(){
  size(900, 700);
  b = new Board();
  ai = new ComputerPlayer();
}

void draw(){
  if(changed){
    b.display();
    changed = false;
  }
}

void mousePressed(){
  b.mouseToPiece(mouseX, mouseY); 
  changed = true;
}

void keyPressed(){
}

void keyReleased(){
  if( key == 'n' && b.turn == 1 && !gameover){
    ai.move(b);
    changed = true;
  } else if (key == 'm' && b.turn == -1 && !gameover){
    ai.move(b);
    changed = true;
  } else if (keyCode == LEFT && !gameover){
     b.turn = -b.turn;
     changed = true;
  }
}

/*
 * NEXT STEPS:
 * Better endgame condition (ie check for possible moves)
 * Evaluation Function
 * Alpha Beta Pruning
 * Maybe add highlights for possible moves?
 */
