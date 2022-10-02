/*
- *Student*: Alberto Salgado Harres
- *Programm*: Digital Media Master at Hfk Bremen
- *Semester*: SS2022
- *Date*: 2.10.2022
- *Matrikelnummer*: 33853
- *Class*: Autonomous Agents
- *Lecturer*: Prof. Tim Laue 
*/

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import java.util.Collections;
import processing.sound.*;


Box2DProcessing box2d;
SumoJumpEngine gameEngine;
PImage backgroundImage;
boolean gameIsInitialized = false;

boolean timerEnabled = false;              // Set to true, if the level should have a time limit
boolean disablePlayerCollisions = false;   // Set to true, if the players should not collide with each other

// Timer related variables:
SinOsc sine;
int countDownDuration = 60000;                           // Time in milliseconds
int countDownStartTime = 0;                              // Point of time when countdown starts
int countDownlastFullSecond = countDownDuration / 1000;
int countDownRemainingTime = countDownDuration;
boolean countDownFinished = false;

String nameOfCurrentLevel = "level2.csv";
int widthOfCurrentLevel   = -1;
int heightOfCurrentLevel  = -1;

void setup() {
  size(1024, 700);
  surface.setResizable(true);
  sine = new SinOsc(this);
  sine.freq(1500);
}


void initGame() {
  // We need the level size before we can start everything else:
  String[] lines = loadStrings(nameOfCurrentLevel);
  for (String line : lines) {
    String[] params = split(line, ';');
    if (params[0].equals("W")) {
      widthOfCurrentLevel  =  int(params[1]);
      heightOfCurrentLevel =  int(params[2]);
    } 
  }
  if (widthOfCurrentLevel == -1 || heightOfCurrentLevel == -1) {
    println("The level description in " + nameOfCurrentLevel + " did not specify the level size (attribute W)!");
    exit();
  }
  surface.setSize(widthOfCurrentLevel, heightOfCurrentLevel);

  // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);  
  box2d.createWorld();
  box2d.setGravity(0, -98.1);
  // Turn on collision listening!
  box2d.listenForCollisions();

  // Create the engine
  gameEngine = new SumoJumpEngine(nameOfCurrentLevel);

  // Create the players
  //gameEngine.addController( new SumoJumpExampleKeyCtrl());
  gameEngine.addController( new SumoJumpExampleRandomDemoAgent());
  gameEngine.addController( new SumoJumpExampleRandomDemoAgent());
  gameEngine.addController( new AlbertoAgent());

  // Initialize countdown
  countDownStartTime = millis();

  // Load and scale background image
  createBackgroundImage();
}


void createBackgroundImage() {
  backgroundImage = loadImage("backgroundImage.png");
  // This is a stupid solution:
  backgroundImage.resize(widthOfCurrentLevel, heightOfCurrentLevel);
  // TODO: Scale and crop proper background images
}


void keyPressed() {
  if (keyCode == 'D') {
    gameEngine.toggleAgentDebugDrawingDisplay();
  } else if (keyCode == 'S') {
    gameEngine.toggleAgentStatusDrawingDisplay();
  } else if (keyCode == 'R') {
    initGame();
  }
}


void handleCountDown() {
  int currentTime = millis();
  int endOfCountDown = countDownStartTime + countDownDuration;
  countDownRemainingTime = 0;
  if (currentTime < endOfCountDown) // Is there still some time left?
    countDownRemainingTime = endOfCountDown - currentTime;
}


void drawBackground() {
  imageMode(CORNER);
  image(backgroundImage, 0, 0);
}


void drawCountDown() {
  // Split for display:
  int seconds = countDownRemainingTime / 1000;
  int milliSecondsRemaining = countDownRemainingTime - seconds*1000;

  // Tick
  if (seconds < countDownlastFullSecond && seconds < 10 && seconds > 0) {
    sine.freq(1500);
    sine.play();
  }
  if ((milliSecondsRemaining > 0 && milliSecondsRemaining < 800) || seconds > 10)
    sine.stop();

  // Draw seconds in huge black numbers
  textAlign(RIGHT);
  textSize(50);
  fill(0);
  text(seconds, width-100, 70);

  // Draw milliseconds in small orange numbers
  textAlign(LEFT);
  textSize(30);
  fill(255, 128, 0);
  text(milliSecondsRemaining, width-100, 70);
}


void draw() {
  if(!gameIsInitialized) {
    initGame();
    gameIsInitialized = true;
  }

  drawBackground();
  if (timerEnabled && gameEngine.getWinner() == null)
    handleCountDown();
  if (gameEngine.getWinner() == null && countDownRemainingTime > 0) {
    box2d.step();
    gameEngine.step();
  }
  gameEngine.draw();
  if (timerEnabled)
    drawCountDown();
  if (gameEngine.getWinner() != null) {
    textAlign(CENTER);
    textSize(120);
    fill(255, 200, 100);
    text("WINNER!", width/2, height/2.5);
    text(gameEngine.getWinner().getName(), width/2, height/1.5);
    textSize(20);
    textAlign(LEFT);
    text("Press R for restart", 30, 30);
  }
  if (countDownRemainingTime == 0) {
    textAlign(CENTER);
    textSize(120);
    fill(255, 200, 100);
    text("TIME IS UP!", width/2, height/2.5);
    sine.freq(500);
    sine.play();
  }
}


// Collision event function
void beginContact(Contact cp) {
  gameEngine.beginContact(cp);
}


void endContact(Contact cp) {
  // empty...
}
