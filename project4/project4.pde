import processing.serial.*;
String val;
Serial myPort;
boolean firstContact = false;

Animation frontNPC;
Animation backNPC;
Animation leftNPC;
Animation rightNPC;

PImage front;
PImage back;
PImage left;
PImage right;

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

int npcLocX = 100;
int npcLocY = 100;
boolean moveUp = false;
boolean moveDown = false;
boolean moveRight = false;
boolean moveLeft = false;
boolean action = false;
int lastMoved = 3;

int joyStickX = 498;
int joyStickY = 490;

boolean lightOn = false;
boolean print1 = false;
boolean print2 = false;

void setup() {
  //print(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 9600);
  myPort.bufferUntil('\n'); 
  
  size(600, 450);
  frameRate(36);
  
  frontNPC = new Animation("npcforward", 6, 100, 100, 150, 150, true, 6);
  backNPC = new Animation("npcback", 6, 100, 100, 150, 150, true, 6);
  leftNPC = new Animation("npcleft", 6, 100, 100, 150, 150, true, 6);
  rightNPC = new Animation("npcright", 6, 100, 100, 150, 150, true, 6);
  
  front = loadImage("npcforward/npcforward00.png");
  back = loadImage("npcback/npcback00.png");
  left = loadImage("npcleft/npcleft00.png");
  right = loadImage("npcright/npcright00.png");
  
  bookClosed = loadImage("book/book00.png");
  bookOpened = loadImage("book/book01.png");
  
  buttonPressed = loadImage("button/button01.png");
  button = loadImage("button/button00.png");
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
  
  readJoyStick();
  
  if(moveUp) {  
    image(backNPC.display(), npcLocX, npcLocY, backNPC.w, backNPC.h);
     lastMoved = 1;
  }
  
  else if(moveDown) {
    image(frontNPC.display(), npcLocX, npcLocY, frontNPC.w, frontNPC.h);
     lastMoved = 3;
  }
  
  else if(moveRight) {
    image(rightNPC.display(), npcLocX, npcLocY, rightNPC.w, rightNPC.h);
     lastMoved = 2;
  }
  
  else if(moveLeft) {
    image(leftNPC.display(), npcLocX, npcLocY, leftNPC.w, leftNPC.h);
    lastMoved = 4; 
  }
  
  if(!moveLeft && !moveRight && !moveDown && !moveUp) {
    if(lastMoved == 1) {
      image(back, npcLocX, npcLocY, 150, 150);
    } else if(lastMoved == 2) {
      image(right, npcLocX, npcLocY, 150, 150);
    } else if(lastMoved == 3) {
      image(front, npcLocX, npcLocY, 150, 150);
    } else if(lastMoved == 4) {
      image(left, npcLocX, npcLocY, 150, 150);
    }
  }
  
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

void readJoyStick() {
  if (joyStickY > 800) {
      moveUp = true;
      moveDown = false;
      moveRight = false;
      moveLeft = false;
      npcLocY = npcLocY - 3;
    } else if (joyStickY < 200) {
      moveDown = true;
      moveUp = false;
      moveRight = false;
      moveLeft = false;
      npcLocY = npcLocY + 3;
    } else if (joyStickX < 200) {
      moveDown = false;
      moveUp = false;
      moveRight = true;
      moveLeft = false;
      npcLocX = npcLocX + 3;
    } else if (joyStickX > 800) {
      moveDown = false;
      moveUp = false;
      moveRight = false;
      moveLeft = true;
      npcLocX = npcLocX - 3;
    } else if(joyStickX <= 800 && joyStickX >= 200 && joyStickY <= 800 && joyStickY >= 200) {
      moveUp = false;
      moveDown = false;
      moveRight = false;
      moveLeft = false;
    }
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
        action = true;
      } else if(val.contains("BUTTON-RELEASED")) {
        action = false;
      }
      
      if(inRange(npcLocX,npcLocY,buttonLocX,buttonLocY)) {
        print1 = true;
        if(action) {
          pressed = true;
          if(!lightOn) {
            myPort.write('1');
          } else {
            myPort.write('0');
          }
        }
      } else { print1 = false; }
      
      if(inRange(npcLocX,npcLocY,bookLocX,bookLocY)) {
        print2 = true;
        if(action && closed) {
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
