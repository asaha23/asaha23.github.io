FWorld  canvas; // this is where the action happens
PImage  canvasWallpaper;

float canvasPrevX;
float canvasPrevY;
float canvasPrevW;
float canvasPrevH;
float canvasPrevR;
float canvasPrevB;

//--------------------------------------------------------//

void setupSimulation() {
  canvas            = new FWorld();  // setup fisica world 
  setCanvasDimensions();
}

void setCanvasDimensions() {
  float canvasX = canvasArea.x();
  float canvasY = canvasArea.y();
  float canvasW = canvasArea.w();
  float canvasH = canvasArea.h();
  float canvasR = canvasArea.r();
  float canvasB = canvasArea.b();
  
  canvas.setEdges(canvasX, canvasY, canvasR, canvasB, color(0, 0));
  canvas.top.setPosition(canvas.top.getX(), canvasY - 10);
  canvas.right.setPosition(canvasR + 9, canvas.right.getY());
  canvas.bottom.setPosition(canvas.bottom.getX(), canvasB + 9);
  canvas.left.setPosition(canvasX - 10, canvas.left.getY());
  canvas.top.setHeight(10);
  canvas.right.setWidth(10);
  canvas.bottom.setHeight(10);
  canvas.left.setWidth(10);
  
  canvasPrevX = canvasX;
  canvasPrevY = canvasY;
  canvasPrevW = canvasW;
  canvasPrevH = canvasH;
  canvasPrevR = canvasR;
  canvasPrevB = canvasB;
}

void updateSimulation() {
  canvas.setEdgesFriction(0);
  canvas.setEdgesRestitution(defEdgeRestitution);
  canvas.setGravity(canvasGravityX, canvasGravityY);
  
  // attempt to get sim to respond to changes in canvasArea.  May be broken.
  if (canvasPrevX != canvasArea.x() ||
      canvasPrevY != canvasArea.y() ||
      canvasPrevW != canvasArea.w() ||
      canvasPrevH != canvasArea.h() ||
      canvasPrevR != canvasArea.r() ||
      canvasPrevB != canvasArea.b() ) {
    setCanvasDimensions();
  }
}

void displaySimulation() {
  // sim background
  if (canvasWallpaper != null) { 
    drawCanvasWallpaper(190);
  }
  // update physics
  canvas.draw(this);
  if (paused == false) {
    canvas.step();
  }
  // current selection box
  if (currentMolecule != null && currentMolecule.speciesName.equals(currentSpeciesName)) {
    drawCurrentMolBox();
  }
}

//--------------------------------------------------------//

void setCanvasWallpaper(String wallpaperFile) {
  canvasWallpaper = loadImage(wallpaperFile);
}

void drawCanvasWallpaper(int overlayAlpha) {
  pushStyle();
    fill(color(127));
    noStroke();
    rect(canvasArea.x(), canvasArea.y(), canvasArea.w(), canvasArea.h());       
    float imageW = canvasWallpaper.width; 
    float imageH = canvasWallpaper.height;
  
    int imageQntyHoriz = ceil(canvasArea.w() / imageW);
    int imageQntyVert = ceil(canvasArea.h() / imageH);
  
    for (int i = 0; i < imageQntyHoriz; i++) {
      for (int j = 0; j < imageQntyVert; j++) {
        float imageX = canvasArea.x() + (i * imageW);
        float imageY = canvasArea.y() + (j * imageH);
        image(canvasWallpaper, imageX, imageY);
      }
    }
    fill(color(0, overlayAlpha));
    rect(canvasArea.x(), canvasArea.y(), canvasArea.w(), canvasArea.h());
  popStyle();
}

void drawCurrentMolBox() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(color(255, 127, 0, 127));
  rectMode(CENTER);
  rect(currentMolecule.getX(), currentMolecule.getY(), 100, 80);
  popStyle();
}

FBody[] getCanvasEdges() {
  FBody[] canvasEdges = new FBody[4];
  int j = 0;
  for (int i = 0; i < canvas.getBodies().size(); i++){
    String obj = canvas.getBodies().get(i).toString();
    if (obj.contains("FBox") == true) {
      canvasEdges[j] = (FBody)canvas.getBodies().get(i);
      j++;
    }
  }
  return canvasEdges;
}
