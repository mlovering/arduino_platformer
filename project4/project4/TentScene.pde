class TentScene {
  
  PImage tentTop;
  PImage tentTopBeams;
  PImage tentBottom;
  PImage tentBottomBeams;
  
  
  TentScene() {
    tentTop = loadImage("tent/tentTop_B.png");
    tentTopBeams = loadImage("tent/tentTop_T.png");
    tentBottom = loadImage("tent/tentBottom_B.png");
    tentBottomBeams = loadImage("tent/tentBottom_T.png");
  }
  
  void drawSceneBackground() {
    image(tentTop, 100, -200, 800,800);
    image(tentBottom, 100, height-228,800,800);
  }

  void drawSceneForeground() {
    image(tentTopBeams, 100, -12, 800,800);
    image(tentBottomBeams, 96, 560,800,800);
    
  }
  
  
}
