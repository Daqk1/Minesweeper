import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS =20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList mines = new ArrayList <MSButton>();
//ArrayList of just the minesweeper buttons that are mined
void setup ()
{
  size(1000, 1000);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );
  buttons = new MSButton [NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++)
    for (int c = 0; c < NUM_COLS; c ++)
      buttons[r][c] = new MSButton(r, c);


  for (int i = 0; i < 50; i ++) {
    setMines();
  }
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c ++) {
      buttons[r][c].setLabel(countMines(r, c));
    }
  }
}
public void setMines()
{
  final int rows = (int)(Math.random()*NUM_ROWS);
  final int col = (int)(Math.random()*NUM_COLS);
  if (mines.contains(buttons[rows][col]) == false) {
    mines.add(buttons[rows][col]);
  }
}


public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  int countUntouchedMines = 0;
  int countTouchedSpaces = 0;
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c ++) {
      if(buttons[r][c].clicked == false && mines.contains(buttons[r][c]) == true){
        countUntouchedMines ++;
    }
      if(buttons[r][c].clicked == true && mines.contains(buttons[r][c]) == false){
        countTouchedSpaces ++;
    }
  }
  }
  if(countUntouchedMines == mines.size() && countTouchedSpaces == (NUM_ROWS*NUM_COLS - mines.size())){
    return true;
  }else{
    return false;
  }
}
public void displayLosingMessage()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c ++) {
      buttons[r][c].clicked = true;
    }
  }
  buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("You Lose");
}
public void displayWinningMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("You Win");

}
public boolean isValid(int r, int c)
{
  if (r >= 0 && r < buttons.length && c >= 0 && c < buttons[r].length)
    return true;
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row - 1; r <= row+1; r++) {
    for (int c = col - 1; c <= col+1; c++) {
      if (isValid(r, c) && mines.contains(buttons[r][c]) && mines.contains(buttons[row][col]) == false) {
        numMines ++;
      }
      }
    }
  
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 1000/NUM_COLS;
    height = 1000/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    if (mouseButton == RIGHT) {
      if (flagged == true) {
        flagged = false;
      } else {
        flagged = true;
        clicked = false;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else {
      if (isValid(myRow, myCol-1) && buttons[myRow][myCol-1].clicked == false && mines.contains(buttons[myRow][myCol-1]) == false && buttons[myRow][myCol].myLabel == "") { //left
        buttons[myRow][myCol-1].mousePressed();
      }
      if (isValid(myRow, myCol+1) && buttons[myRow][myCol+1].clicked== false&& mines.contains(buttons[myRow][myCol+1]) == false && buttons[myRow][myCol].myLabel == "") { //right
        buttons[myRow][myCol+1].mousePressed();
      }
      if (isValid(myRow-1, myCol) && buttons[myRow-1][myCol].clicked== false&& mines.contains(buttons[myRow-1][myCol]) == false && buttons[myRow][myCol].myLabel == "") { // up
        buttons[myRow-1][myCol].mousePressed();
      }
      if (isValid(myRow+1, myCol) && buttons[myRow+1][myCol].clicked== false&& mines.contains(buttons[myRow+1][myCol]) == false && buttons[myRow][myCol].myLabel == "") { //down
        buttons[myRow+1][myCol].mousePressed();
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    if(clicked == true){
      text(myLabel, x+width/2, y+height/2);
    }
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    if(newLabel == 0){
      myLabel = "";
    }else{
    myLabel = ""+ newLabel;
  }
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
