class Animation {
  PImage[] frames;
  int frameCount, curFrame, frameRate, overallFrame;
  int frameItr;
  int locX, locY;
  int w, h;
  boolean loop;
  
  Animation(String prefix, int count, int locX, int locY, int w, int h, boolean loop, int frameRate) {
    frameCount = count;
    frames = new PImage[frameCount];
    for (int i = 0; i < frameCount; i++) {
      String filepath = prefix + "/" + prefix + nf(i,2) + ".png";
      frames[i] = loadImage(filepath);
    }
    
    this.locX = locX;
    this.locY= locY;
    this.w = w;
    this.h = h;
    this.loop = loop;
    this.frameRate = frameRate;
    
    overallFrame = 0;
   
  }
  
  PImage display() { 
    overallFrame = overallFrame + 1;
    if(overallFrame % this.frameRate == 0) {
      curFrame = (curFrame + 1);
      if(curFrame == frameCount && this.loop) {
        curFrame = 0;
      } else if (curFrame >= frameCount && !this.loop) {
        curFrame = frameCount-1;
      }
    }
    return frames[curFrame]; 
  }
  
  PImage reverseAnimation() { 
    if(curFrame != 0) {
      curFrame = (curFrame - 1);
      return frames[curFrame];
    } 
    else { return frames[0]; }
  }
}
