import processing.serial.*;
String val;
Serial myPort;
boolean firstContact = false;

Character character;
Camera camera;
CollisionSystem collision;

TentScene tentScene;

int joyStickX = 498;
int joyStickY = 490;

boolean lightOn = false;
boolean print1 = false;
boolean print2 = false;

PImage bookClosed;
PImage bookOpened;

int bookLocX = 600;
int bookLocY = 500;
boolean closed = true;

int buttonLocX = 200;
int buttonLocY = 600;
boolean pressed = false;
PImage buttonPressed;
PImage button;

void setup() {
  // connect to Arduino, if available
  myPort = new Serial(this, Serial.list()[3], 9600);
  myPort.bufferUntil('\n'); 
  
  size(1000, 800);
  frameRate(36);
  
  bookClosed = loadImage("book/book00.png");
  bookOpened = loadImage("book/book01.png");
  
  buttonPressed = loadImage("button/button01.png");
  button = loadImage("button/button00.png");
  
  character = new Character();
  
  tentScene = new TentScene();

}

void draw() { 
  background(0);
  tentScene.drawSceneBackground();
  
  if(lightOn) {
    if(closed) {
      image(bookClosed, bookLocX, bookLocY, 100, 100);
       if(print2) {
          textSize(24);
          text("Press button to open", 10, 30);
        }
    } else {
      image(bookOpened, bookLocX, bookLocY, 100, 100);
    }
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
  
  // character.readJoyStick();
    
  character.drawCharacter();
  
  tentScene.drawSceneForeground();
  
  if(!lightOn) {
    tint(0, 153, 204);
  }

  if(inRange(character.locX,character.locY,buttonLocX,buttonLocY)) {
    print1 = true;
    if(character.action) {
      pressed = true;
      if(!lightOn) {
        lightOn = true;
        tint(255, 255, 255);
      } 
    }
  } else { print1 = false; }
  
  if(inRange(character.locX,character.locY,bookLocX,bookLocY)) {
    print2 = true;
    if(character.action && closed) {
      closed = false;
    } 
  } else { print2 = false; }
   
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      character.moveUp = true;
      character.moveDown = false;
      character.moveRight = false;
      character.moveLeft = false;
      character.action = false;
      character.locY = character.locY - 10;
    } else if (keyCode == DOWN) {
      character.moveDown = true;
      character.moveUp = false;
      character.moveRight = false;
      character.moveLeft = false;
      character.action = false;
      character.locY = character.locY + 10;
    } else if (keyCode == RIGHT) {
      character.moveDown = false;
      character.moveUp = false;
      character.moveRight = true;
      character.moveLeft = false;
      character.action = false;
      character.locX = character.locX + 10;
    } else if (keyCode == LEFT) {
      character.moveDown = false;
      character.moveUp = false;
      character.moveRight = false;
      character.moveLeft = true;
      character.action = false;
      character.locX = character.locX - 10;
    } else if (keyCode == SHIFT) {
      character.action = true;
    }
  }
   
}

void keyReleased() {
  character.moveUp = false;
  character.moveDown = false;
  character.moveRight = false;
  character.moveLeft = false;
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
