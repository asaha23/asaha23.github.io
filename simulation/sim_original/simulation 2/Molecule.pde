class Molecule extends FPoly {
	String 	speciesName;
	int 		moleculeID = 0;
	float 	mass;
  RShape 	shapeFullSVG;
  RShape 	shapeObject;
  RShape 	shapeOutline;
  RPoint 	centroid;
  float  	speciesMass = 1;
  float 	x;
  float 	y;
  float 	w;
  float 	h;
  float 	maxVel = 200;
  float 	minVel = 100;
  float 	maxRotVel;
  float 	minRotVel;
  float 	angle = random(TWO_PI); // starting angle
  float 	magnitude = defMolVelocity;  // starting velocity
  // variables to store movement data while paused
  float 	storeVelX;
  float 	storeVelY;
  float 	storeRotation;
  float 	storeAngVel;

  
  Molecule(String speciesName_, float x_, float y_) {
    super();
    mass = 50; // eventually, this will be calculated via lookup table
    speciesName = speciesName_;
    x = x_;
    y = y_;
    shapeFullSVG  = RG.loadShape(getSpeciesFilename(speciesName));
    shapeObject   = shapeFullSVG.getChild("object");
    shapeOutline  = shapeFullSVG.getChild("outline");

    if (shapeObject == null || shapeOutline == null) {
      println("ERROR: Couldn't find the shapes called 'object' and 'outline' in the SVG file.");
      shapeFullSVG  = RG.loadShape("svg/Generic.svg");
      shapeObject   = shapeFullSVG.getChild("object");
      shapeOutline  = shapeFullSVG.getChild("outline");
      return;
    }

    w = shapeOutline.getWidth() * defMoleculeScale;
    h = shapeOutline.getHeight() * defMoleculeScale;
    
    // Make the shapes fit in a rectangle of size (w, h)
    // that is centered in 0
    shapeObject.transform(-w/2, -h/2, w, h); 
    shapeOutline.transform(-w/2, -h/2, w, h);
    
    // creates vertexes for all points in the shape
    RPoint[] points = shapeOutline.getPoints();
    if (points==null) return;
    for (int i=0; i<points.length; i++) {
      vertex(points[i].x, points[i].y);
    }
    
    setDensity(speciesMass);
    setPosition(x, y);
    setRotation(angle+PI/2);
    setVelocity(magnitude*cos(angle), magnitude*sin(angle));
    
    storeVelX      = getVelocityX();
    storeVelY      = getVelocityY();
    storeRotation  = getRotation();
    storeAngVel    = getAngularVelocity();
    
    setDamping(defDamping);
    setAngularDamping(defDamping); 
    setRestitution(defRestitution);
    setFriction(defFriction);
    
    centroid = shapeOutline.getCentroid();
  }
  
  String speciesName() {
    return speciesName;
  }
  
  float getVelocity() {
    float v = sqrt(pow(getVelocityX(), 2) + pow(getVelocityY(), 2));
    return v;
  }
  
  void adjustVelocity() { 	// this function limits the speed of molecules so they don't go too fast or slow
    // movement curtail
    if (getVelocity() < minVel) {
      setVelocity(getVelocityX() * 1.01, getVelocityY() * 1.01);
    }
    if (getVelocity() > maxVel) {
      setVelocity(getVelocityX() * .99, getVelocityY() * .99);
    }
    // extreme movement curtail
    if (getVelocity() > maxVel * 3) {
      setVelocity(getVelocityX() * .75, getVelocityY() * .75);
    }
  }
  
  void relocateLostMolecule() {
    float distance = (h + w) * 2;
    if (getX() > canvasArea.r + distance || 
        getX() < canvasArea.x - distance || 
        getY() > canvasArea.b + distance || 
        getY() < canvasArea.y - distance) {
      setPosition(canvasArea.mx, canvasArea.my);
    }
  }
  
  void pauseMotion() {
    // variables to store movement data while paused
    storeVelX      = getVelocityX();
    storeVelY      = getVelocityY();
    storeAngVel    = getAngularVelocity();
    
    setVelocity(0, 0);
    setAngularVelocity(0);
  }
  
  void unpauseMotion() {
    setVelocity(storeVelX, storeVelY);
    setAngularVelocity(storeAngVel);
  }
  
  // draw is a FPoly class overloaded (I think)
  void draw(PGraphics applet) {
    adjustVelocity();
    
    preDraw(applet);
    shapeObject.draw(applet);
    postDraw(applet);
    
    relocateLostMolecule();
  }
}
