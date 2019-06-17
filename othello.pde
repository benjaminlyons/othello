boolean changed = true;
Board b;
ComputerPlayer ai;
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
  if( key == 'n' && b.turn == 1){
    ai.move(b);
    changed = true;
  } else if (key == 'm' && b.turn == -1){
    ai.move(b);
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
