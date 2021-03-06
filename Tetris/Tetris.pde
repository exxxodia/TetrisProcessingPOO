// necesario instalar librerio Sound 1.3.2
import processing.sound.*;
//valores default del juego
PImage img;
SoundFile file;
String audioName="theme.mp3";
String path;
int w = 10; //celdas de ancho
int h = 20; // celdas de alto
int q = 25; //tamaño de bloque alto*ancho
int delayTime;//tiempo retraso entre movimientos
int currentTime; //tiempo actual
int r = 0;//rotacion de la pieza
int level = 1;//nivel del juego
int clearLines = 0;//puntaje

//propiedades del texto a mostrar para usuario
int txtSize = 25;
int textColor = color(211, 77, 135);
//estado del juego, game over o gome on
boolean gameOver = false;
boolean gameOn = false;
//inicializa todos los objetos
Grid grid;
Piece piece;
Piece nextPiece;
Pieces pieces;
Score score;

void setup()
{
  path = sketchPath(audioName);
  file = new SoundFile(this, path);
  size(550, 600);
  textSize(30);
  file.play();
}

void initialize() {
  level = 1;
  clearLines = 0;
  delayTime = 999;
  currentTime = millis();
  score = new Score();
  grid = new Grid();
  pieces = new Pieces();
  piece = new Piece(-1);
  nextPiece = new Piece(-1);
}

void draw()
{
  img = loadImage("img01.jpg");
  background(img);
  if (grid != null) {//mientras que grid no sea nulo
    grid.drawGrid();
    if (score.points > 10) {
      grid.Obstacle();
    }

    int now = millis();
    //si gameOn pasa a ser true, establece el tiempo de ejecucion a n, empezar de nuevo
    if (gameOn) {
      if (now - currentTime > delayTime) {
        currentTime = now;
        piece.oneStepDown();
      }
    }
    piece.display(false);
    score.display();
  }
  //dibuja el cuadro de dialogo cuando pierde
  if (gameOver) {
    String s = "Fin del Juego";
    textAlign(CENTER);
    text(s, 120, 220, 300, 100 );
  }
  //cuadro de dialogo para empezar el juego
  if (!gameOn) {
    String s = "Presione ENTER para comenzar";
    textAlign(CENTER);
    text(s, 120, 220, 300, 100 );
  }
}
//se encarga de mostrar la siguiente pieza en UI
void goToNextPiece() {
  piece = new Piece(nextPiece.type);
  nextPiece = new Piece(-1);
  r = 0;
}
//permite aumentar la dificultad = mas rapido
void goToNextLevel() {
  score.addLevelPoints();
  level = 1 + int(clearLines / 10);
  delayTime *= .5;//disminuye el tiempo para mover pieza, 50%
}
//funcion que detecta la tecla oprimida
void keyPressed() {
  if (key == CODED && gameOn) {
    switch(keyCode) {
    case LEFT:
    case RIGHT:
    case DOWN:
    case UP:
    case SHIFT:
      piece.inputKey(keyCode);
      break;
    }
  } else if (key == ENTER) {
    if (!gameOn) {
      initialize();
      gameOver = false;
      gameOn = true;
    }
  }
}
