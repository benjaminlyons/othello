/* NOTE: NEED TO REMEMBER TO GO BACK THROUGH CODE AND REFACTOR
 * right now, this code is a complete mess and honestly makes me feel
 * sick. i think its working pretty well though so there's that...
 *
 */
boolean changed = true;
Board b;
ComputerPlayer ai;
boolean gameover = false;
boolean showMoves = true;
Board last;
void setup(){
  /* size(900, 700); */
  size(900, 700);
  surface.setSize((int)(.8*displayHeight+200), (int)(.8*displayHeight));
  surface.setLocation(100, 100);
  b = new Board();
  ai = new ComputerPlayer();
  last = new Board();
}

void draw(){
  if(changed){
    b.display();
    changed = false;
  }
}

void mousePressed(){
  last = new Board(b);
  b.mouseToPiece(mouseX, mouseY); 
  changed = true;
}

void keyPressed(){
}

void keyReleased(){
  if( key == 'n' && b.turn == 1 && !gameover){
    last = new Board(b);
    ai.move(b);
    changed = true;
  } else if (key == 'm' && b.turn == -1 && !gameover){
    last = new Board(b);
    ai.move(b);
    changed = true;
  } else if (keyCode == DOWN && !gameover){
    last = new Board(b);
    b.turn = -b.turn;
    changed = true;
  } else if (key == 'h'){
    showMoves = !showMoves;
    changed = true;
  } else if (key == 'r'){
    b = new Board();
    last = new Board();
    ai = new ComputerPlayer();
    changed = true;
    gameover = false;
  } else if (key == 'u'){
    b = last;
    changed = true;
  }
}

