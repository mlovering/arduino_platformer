import processing.serial.*;
String val;
Serial myPort;
boolean firstContact = false;

Character character;

TentScene tentScene;

int bookLocX = 100;
int bookLocY = 100;
boolean closed = true;
PImage bookClosed;
PImage bookOpened;

int buttonLocX = 300;
int buttonLocY = 300;
boolean pressed = false;
PImage buttonPressed;
PImage button;

int joyStickX = 498;
int joyStickY = 490;

boolean lightOn = false;
boolean print1 = false;
boolean print2 = false;

void setup() {
  //print(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 9600);
  myPort.bufferUntil('\n'); 
  
  size(1000, 800);
  frameRate(36);
  
  character = new Character();
  
  bookClosed = loadImage("book/book00.png");
  bookOpened = loadImage("book/book01.png");
  
  buttonPressed = loadImage("button/button01.png");
  button = loadImage("button/button00.png");
  
  tentScene = new TentScene();

}

void draw() { 
  if(lightOn) {
    background(255);
    if(closed) {
      image(bookClosed, bookLocX, bookLocY, 100, 100);
       if(print2) {
          fill(0);
          textSize(24);
          text("Press button to open", 10, 30);
        }
    } else {
      image(bookOpened, bookLocX, bookLocY, 100, 100);
    }
  } else {
    background(0);
    tentScene.drawSceneBackground();
  }
  
  if(pressed) {
    image(buttonPressed, buttonLocX, buttonLocY, 100,100);
  } else {
    image(button, buttonLocX, buttonLocY, 100,100);
  }
  
  if(print1) {
    textSize(24);
    text("Press button to interact", 10, 30);
  }
  
  character.readJoyStick();
  character.drawCharacter();
  
  tentScene.drawSceneForeground();
  
}

//void keyPressed() {
//  if (key == CODED) {
//    if (keyCode == UP) {
//      moveUp = true;
//      moveDown = false;
//      moveRight = false;
//      moveLeft = false;
//      npcLocY = npcLocY - 5;
//    } else if (keyCode == DOWN) {
//      moveDown = true;
//      moveUp = false;
//      moveRight = false;
//      moveLeft = false;
//      npcLocY = npcLocY + 5;
//    } else if (keyCode == RIGHT) {
//      moveDown = false;
//      moveUp = false;
//      moveRight = true;
//      moveLeft = false;
//      npcLocX = npcLocX + 5;
//    } else if (keyCode == LEFT) {
//      moveDown = false;
//      moveUp = false;
//      moveRight = false;
//      moveLeft = true;
//      npcLocX = npcLocX - 5;
//    } else if (keyCode == SHIFT) {
//      action = !action;
//    }
//  }
   
//}

//void keyReleased() {
//  moveUp = false;
//  moveDown = false;
//  moveRight = false;
//  moveLeft = false;
//}


void serialEvent(Serial myPort) {
  val = myPort.readStringUntil('\n');
  if(val != null) {
    val = trim(val);
    if(firstContact == false) {
      if (val.equals("A")) {
        myPort.clear();
        firstContact = true;
        myPort.write("A");
      }
    } else {
      if(val.contains("X-axis: ")) {
        joyStickX = Integer.parseInt(val.substring(8));
      } else if(val.contains("Y-axis: ")) {
        joyStickY = Integer.parseInt(val.substring(8));
      } else if(val.contains("LIGHT-ON")) {
        lightOn = true;
      } else if(val.contains("LIGHT-OFF")) {
        lightOn = false;
      } else if(val.contains("BUTTON-PRESSED")) {
        character.action = true;
      } else if(val.contains("BUTTON-RELEASED")) {
        character.action = false;
      }
      
      if(inRange(character.locX,character.locY,buttonLocX,buttonLocY)) {
        print1 = true;
        if(character.action) {
          pressed = true;
          if(!lightOn) {
            myPort.write('1');
          } else {
            myPort.write('0');
          }
        }
      } else { print1 = false; }
      
      if(inRange(character.locX,character.locY,bookLocX,bookLocY)) {
        print2 = true;
        if(character.action && closed) {
          closed = false;
        } 
      } else { print2 = false; }
      
      myPort.write("A");
      
    }
  }
}

double distance(int x1, int y1, int x2, int y2) {
   double ans = sqrt(pow(x2-x1,2) + pow(y2-y1,2));
   return ans;
}

boolean inRange(int topLeftX1, int topLeftY1, int topLeftX2, int topLeftY2) {
  if(distance(topLeftX1, topLeftY1, topLeftX2, topLeftY2) <= 100) {
    return true;
  }
  return false;
}
