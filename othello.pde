boolean changed = true;
Board b;
void setup(){
  size(700, 700);
  b = new Board();
}

void draw(){
    b.display();
}

void mousePressed(){
  b.mouseToPiece(mouseX, mouseY); 
  changed = true;
}

/*
 * NEXT STEPS:
 * Generate all possible moves
 * Better endgame condition (ie check for possible moves)
 * Display whose turn it is
 * Evaluation Function
 * Alpha Beta Pruning
 */
