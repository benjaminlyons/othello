boolean changed = true;
Board b;
void setup(){
  size(900, 700);
  b = new Board();
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

/*
 * NEXT STEPS:
 * Better endgame condition (ie check for possible moves)
 * Evaluation Function
 * Alpha Beta Pruning
 * Maybe add highlights for possible moves?
 */
