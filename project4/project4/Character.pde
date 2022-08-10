class Character {
  int w = 150;
  int h = 150;
  
  int fr = 3;
  
  int locX = 500;
  int locY = 500;
  boolean moveUp = false;
  boolean moveDown = false;
  boolean moveRight = false;
  boolean moveLeft = false;
  boolean action = false;
  int lastMoved = 3;
  
  Animation frontWalk;
  Animation backWalk;
  Animation leftWalk;
  Animation rightWalk;

  PImage frontIdle;
  PImage backIdle;
  PImage leftIdle;
  PImage rightIdle;
  
  Character() {
    frontWalk = new Animation("npcforward", 6, 100, 100, w, w, true, fr);
    backWalk = new Animation("npcback", 6, 100, 100, w, w, true, fr);
    leftWalk = new Animation("npcleft", 6, 100, 100, w, w, true, fr);
    rightWalk = new Animation("npcright", 6, 100, 100, w, w, true, fr);
    
    frontIdle = loadImage("npcforward/npcforward00.png");
    backIdle = loadImage("npcback/npcback00.png");
    leftIdle = loadImage("npcleft/npcleft00.png");
    rightIdle = loadImage("npcright/npcright00.png");
  }
  
  void readJoyStick() {
  if (joyStickY > 800) {
      moveUp = true;
      moveDown = false;
      moveRight = false;
      moveLeft = false;
      locY = locY - 10;
    } else if (joyStickY < 200) {
      moveDown = true;
      moveUp = false;
      moveRight = false;
      moveLeft = false;
      locY = locY + 10;
    } else if (joyStickX < 200) {
      moveDown = false;
      moveUp = false;
      moveRight = true;
      moveLeft = false;
      locX = locX + 10;
    } else if (joyStickX > 800) {
      moveDown = false;
      moveUp = false;
      moveRight = false;
      moveLeft = true;
      locX = locX - 10;
    } else if(joyStickX <= 800 && joyStickX >= 200 && joyStickY <= 800 && joyStickY >= 200) {
      moveUp = false;
      moveDown = false;
      moveRight = false;
      moveLeft = false;
    }
  }
  
  void drawCharacter() {
    if(moveUp) {  
      image(backWalk.display(), locX, locY, w, h);
      lastMoved = 1;
    } 
    
    else if(moveDown) {
      image(frontWalk.display(), locX, locY, w, h);
      lastMoved = 3;
    }
    
    else if(moveRight) {
      image(rightWalk.display(), locX, locY, w, h);
      lastMoved = 2;
    }
    
    else if(moveLeft) {
      image(leftWalk.display(), locX, locY, w, h);
      lastMoved = 4; 
    }
    
    if(!moveLeft && !moveRight && !moveDown && !moveUp) {
      if(lastMoved == 1) {
        image(backIdle, locX, locY, w, h);
      } else if(lastMoved == 2) {
        image(rightIdle, locX, locY, w, h);
      } else if(lastMoved == 3) {
        image(frontIdle, locX, locY, w, h);
      } else if(lastMoved == 4) {
        image(leftIdle, locX, locY, w, h);
      }
    }
  }
  
}
