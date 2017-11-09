float   canvasGravityX 	= 0;
float   canvasGravityY 	= 0;

float   minMolVelocity 	= 1;
float   defMolVelocity 	= 150;
float   maxMolVelocity 	= 200;

float   defDamping 			= 0;
float   defRestitution 	= 1; // 1 = normal
float   defEdgeRestitution = 1;
float   defFriction 		= 1;

float   minMoleculeScale = .25;
float   defMoleculeScale = .75;
float   maxMoleculeScale = 2;

FWorld  canvas; // this is where the action happens
PImage  canvasWallpaper;

float canvasPrevX;
float canvasPrevY;
float canvasPrevW;
float canvasPrevH;
float canvasPrevR;
float canvasPrevB;

ArrayList allItemsAL = new ArrayList();
ArrayList allUnitsAL = new ArrayList();
ArrayList allLessonsAL = new ArrayList();
ArrayList allSimulationsAL = new ArrayList();


////////////
// CANVAS //
////////////

void startSimulation() {
  canvas = new FWorld();  // start fisica world 
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
	// these are fisica methods: canvas is the fisica world
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

// this is the collision listener function.
void contactStarted(FContact contact) {
  // Draw in green an ellipse where the contact took place
  //fill(0, 170, 0);
  //ellipse(contact.getX(), contact.getY(), 20, 20);
	if (getMolecules().contains(contact.getBody1()) && getMolecules().contains(contact.getBody2())) {
    react((Molecule)contact.getBody1(), (Molecule)contact.getBody2(), contact.getX(), contact.getY());
	}
}

// return the four canvas edges in an array
FBody[] getCanvasEdges() {
  FBody[] canvasEdges = new FBody[4];
  int j = 0;
	// get all fisica bodies
  for (int i = 0; i < canvas.getBodies().size(); i++){
    String obj = canvas.getBodies().get(i).toString();
		// parse for the four canvas edges
    if (obj.contains("FBox") == true) {
      canvasEdges[j] = (FBody)canvas.getBodies().get(i);
      j++;
    }
  }
  return canvasEdges;
}


//////////
// TIME //
//////////

int runTotal()   { return millis() - runStart; }
int netPlayed()  {
  if (paused == true) {
    return netPlayed;
  } else {
    return netPlayed + timeSinceLastEvent();
  }
}
int netPaused()  {
  if (paused == true) {
    return netPlayed + timeSinceLastEvent();
  } else {
    return netPlayed;
  }
}
int timeSinceLastEvent() {
  return runTotal() - lastEvent;
}

int prevRunNumber = 0;
int runStart = millis();
int runNumber = 0;
Boolean paused = true;
int lastEvent;
int netPaused;
int netPlayed;
int prevTU;
int prevSecond;
int prevMinute;
int prevHour;

void startTime() {
  resetTime();
}

void resetTime()  {
  runStart      = millis();
  runNumber++;
  lastEvent     = runStart;
  netPaused     = 0;
  netPlayed     = 0;
  prevTU        = 0;
  prevSecond    = 0;
  prevMinute    = 0;
  prevHour      = 0;
  println("simulation has been RESET");
}

void toggleTimer() {
  if (paused == true) {
    startTimer();
  } else {
    pauseTimer();
  }
}

void pauseTimer() {
  addTime();
  paused = true;
  println("timer has PAUSED");
  //timePanel.playPauseButton.buttonType = "play"; // FIX
  for (int i = 0; i < getMolecules().size(); i++) {
    Molecule currMolecule = (Molecule)getMolecules().get(i);
    currMolecule.pauseMotion();
  }
}
void startTimer() {
  addTime();
  paused = false;
  println("timer has STARTED");
  //timePanel.playPauseButton.buttonType = "pause"; // FIX
  for (int i = 0; i < getMolecules().size(); i++) {
    Molecule currMolecule = (Molecule)getMolecules().get(i);
    currMolecule.unpauseMotion();
  }
}

void addTime() {
  if (paused == true) {
    netPaused = netPaused + timeSinceLastEvent();
  } else if (paused == false) {
    netPlayed = netPlayed + timeSinceLastEvent();
  } else {
    println("paused is NULL... FIX ME");
  }
  lastEvent = runTotal();
}

void updateTime() {
  // don't forget... these will only run if the sim is paused
  if (currentRun()     > prevRunNumber) { fireEveryRun(); }
  if (currentTU()      > prevTU)        { fireEveryTU(); }
  if (currentSecond()  > prevSecond)    { fireEverySecond(); }
  if (currentMinute()  > prevMinute)    { fireEveryMinute(); }
  if (currentHour()    > prevHour)      { fireEveryHour(); }
  updatePrevValues();
}

void fireEveryRun()     {}
void fireEveryTU()      {
  updateHistory();
}
void fireEverySecond()  {}
void fireEveryMinute()  {}
void fireEveryHour()  {}

void updatePrevValues() {
  prevRunNumber = currentRun();
  prevTU     = currentTU();
  prevSecond = currentSecond();
  prevMinute = currentMinute();
  prevHour   = currentHour();
}

int currentRun()    { return runNumber; }
int currentTU()     { return floor(netPlayed()/(1000/countsPerSecond)); }
int currentSecond() { return floor(netPlayed()/1000); }
int currentMinute() { return floor(netPlayed()/(1000*60)); }
int currentHour()   { return floor(netPlayed()/(1000*60*60)); }

String currentTimeFormatted() {
  String timeForm;
  int hourForm  = currentHour();
  int minForm   = floor(currentMinute()%60);
  int secForm   = floor(currentSecond()%60);
  if (hourForm > 0) {
    timeForm = hourForm + ":" + nf(minForm, 2) + ":" + nf(secForm, 2);
  } else {
    timeForm = nf(minForm, 2) + ":" + nf(secForm, 2);
  }
  return timeForm;
}


///////////
// ITEMS //
///////////

int	nextUnit        		= 0;
int	nextLesson      		= 0;
int	nextSimulation  		= 0;
int	selectedUnit				= 0;
int	selectedLesson			= 0;
int	selectedSimulation 	= 0;
int	currentUnit 				= -1;  // are all of these necessary?
int	currentLesson 			= -1;
int	currentSimulation 	= -1;

HashMap allItemsRanked = new HashMap();

String[] allItems = new String[] {
  //"01:  Modeling and Matter",
  "02:  Solutions",
	"02-01:  Dissolving and Dissociation to Produce Solutions",
	"02-01-01:  Teacher Simulation",
	//"02-02:  Exploring Solubility at the Submicroscopic Level",
	"02-03:  Predicting Solubility - Varying Solvents and Solutions",
	"02-03-01: Sodium-Chloride",
	"02-03-02: Glycerol",
	"02-03-03: Silicon-Dioxide",
	"02-03-04: Calcium-Chloride",
	"02-03-05: Acetic-Acid",
	"02-03-06: Pentane",
	"02-03-07: Sodium-Bicarbonate",
	"02-04:  Factors Affecting Solubility",
	"02-04-01: Select Your Own Solution",
	//"02-05:  Determining Concentration",
	"02-06:  Saturation",
	"02-06-01:  Teacher Simulation",
	//"02-07:  Creating Solubility Curves",
  //"03:  Reactions",
  //"04:  Gas Laws and Pressure",
  //"05:  Thermodynamics",
  //"06:  Kinetics",
  //"07:  Equilibrium",
  "08:  Acids and Bases",
  "08-02:  Acid Base Theory",
  "08-02-01:  Hydrochloric Acid",
  "08-02-02:  Sodium Hydroxide",
  "08-02-03:  Hydrochloric Acid + Sodium Hydroxide",
  "08-02-04:  Hydrochloric Acid + Ammonia",
  "08-02-05:  Cyanide + Hydrogen Bromide",
  "08-02-06:  Boron Trichloride + Chlorine Ion",
  "08-03:  Disassociation of Acids and Bases",
  "08-03-01:  Strong acid added to water",
  "08-03-02:  Weak acid added to water",
  "08-03-03:  Strong base added to water",
  "08-03-04:  Weak base added to water",
  "08-04:  Identifying Acids and Bases and Mathematical Relationships",
  "08-04-01:  Acetic Acid added to water",
  "08-04-02:  Lithium Hydroxide added to water",
  "08-04-03:  Methylamine added to water",
  "08-04-04:  Nitric Acid added to water",
  "08-06:  Titration Curves: Strong Base into Strong Acid",
  "08-06-01:  Hydrochloric Acid + Sodium Hydroxide",
  "08-07:  Titration Curves",
  "08-07-01:  Strong acid + weak base",
  "08-07-02:  Weak acid + strong base",
  "08-07-03:  Weak acid + weak base",
  "08-08:  Buffers",
  "08-08-01:  Buffered solution"//,
  //"09:  Nuclear Chemistry"
};

String getItemId(String item) {
  String[] strings = split(item, ":");
  return strings[0];
}

String getItemText(String item) {
  String[] strings = split(item, ":");
  return trim(strings[1]);
}

Integer getItemUnit(String itemId) {
  int output;
  if (itemId.length() >= 2) {
    output = int(itemId.substring(0, 2));
    return output;
  } else {
    return -1;
  }
}

Integer getItemLesson(String itemId) {
  int output;
  if (itemId.length() >= 5) {
    output = int(itemId.substring(3, 5));
    return output;
  } else {
    return -1;
  }
}

Integer getItemSimulation(String itemId) {
  int output;
  if (itemId.length() >= 8) {
    output = int(itemId.substring(6, 8));
    return output;
  } else {
    return -1;
  }
}

String getItem(String itemId) {
  String output = "";
  for (int i=0; i<allItems.length; i++) {
    String currentItemId = getItemId(allItems[i]);
    if (currentItemId.equals(itemId)) {
      output = allItems[i];
    }
  }
  return output;
}

String getItemType(String itemId) {
  String type = null;
  String[] idParts = split(itemId, "-");
  if      (idParts.length == 1) {type = "unit";}
  else if (idParts.length == 2) {type = "lesson";}
  else if (idParts.length == 3) {type = "simulation";}
  else                          {type = null;}
  return type;
}

String[] filterByType(String[] items, String type) {
  ArrayList itemsAL = convertStringArrayToArrayList(items);
  itemsAL = filterByType(itemsAL, type);
	return convertArrayListToStringArray(itemsAL);
}

ArrayList filterByType(ArrayList items, String type) {
  String item;
  String checkType;
  ArrayList itemsToRemove = new ArrayList();
  for (int i=0; i<items.size(); i++) {
    item = (String)items.get(i);
    checkType = getItemType(item);
    if (!type.equals(checkType)) {
      itemsToRemove.add(item);
    }
  }
  for (int i=0; i<itemsToRemove.size(); i++) {
    items.remove(itemsToRemove.get(i));
  }
  return items;
}

ArrayList filterByUnit(ArrayList items, int unit_) {
	ArrayList tmpAL = new ArrayList();
	String item;
	for (int i = 0; i<items.size(); i++) {
		item = (String)items.get(i);
		if (getItemUnit(item) == unit_) {
			tmpAL.add(item);
		}
	}
	return tmpAL;
}

ArrayList filterByLesson(ArrayList items, int lesson_) {
	ArrayList tmpAL = new ArrayList();
	String item;
	for (int i = 0; i<items.size(); i++) {
		item = (String)items.get(i);
		if (getItemLesson(item) == lesson_) {
			tmpAL.add(item);
		}
	}
	return tmpAL;
}

ArrayList filterBySimulation(ArrayList items, int simulation_) {
	ArrayList tmpAL = new ArrayList();
	String item;
	for (int i = 0; i<items.size(); i++) {
		item = (String)items.get(i);
		if (getItemSimulation(item) == simulation_) {
			tmpAL.add(item);
		}
	}
	return tmpAL;
}

void setCurrentItem(String type, int choice) {
  String itemKey = type + str(choice);
  String itemId = (String)allItemsRanked.get(itemKey);
  String itemType = getItemType(itemId);
  int itemUnit = getItemUnit(itemId);
  int itemLesson = getItemLesson(itemId);
  int itemSimulation = getItemSimulation(itemId);
  setCurrentUnit(itemUnit);
  setCurrentLesson(itemLesson);
  setCurrentSimulation(itemSimulation);
}

String getCurrentItem(String type_) {
	String tmpA = new String();
	if (type_.equals("unit")) {
		for (int i = 0; i<allUnitsAL.size(); i++) {
			String tmpB = (String)allUnitsAL.get(i);
			if (getItemUnit(tmpB) == getCurrentUnit()) {
				tmpA = tmpB;
			}
		}
	} else if (type_.equals("lesson")) {
		for (int i = 0; i<allLessonsAL.size(); i++) {
			String tmpB = (String)allLessonsAL.get(i);
			if (getItemLesson(tmpB) == getCurrentLesson() && getItemUnit(tmpB) == getCurrentUnit()) {
				tmpA = tmpB;
			}
		}
	} else if (type_.equals("simulation")) {
		for (int i = 0; i<allSimulationsAL.size(); i++) {
			String tmpB = (String)allSimulationsAL.get(i);
			if (getItemSimulation(tmpB) == getCurrentSimulation() && getItemLesson(tmpB) == getCurrentLesson() && getItemUnit(tmpB) == getCurrentUnit()) {
				tmpA = tmpB;
			}
		}
	}
	return tmpA;
}

String getNextItem(String type_) {
	String tmpA = new String();
	if (type_.equals("unit")) {
		for (int i = 0; i<allUnitsAL.size(); i++) {
			String tmpB = (String)allUnitsAL.get(i);
			if (getItemUnit(tmpB) == getNextUnitNumber()) {
				tmpA = tmpB;
			}
		}
	} else if (type_.equals("lesson")) {
		for (int i = 0; i<allLessonsAL.size(); i++) {
			String tmpB = (String)allLessonsAL.get(i);
			if (getItemLesson(tmpB) == getNextLessonNumber() && getItemUnit(tmpB) == getNextUnitNumber()) {
				tmpA = tmpB;
			}
		}
	} else if (type_.equals("simulation")) {
		for (int i = 0; i<allSimulationsAL.size(); i++) {
			String tmpB = (String)allSimulationsAL.get(i);
			if (getItemSimulation(tmpB) == getNextSimulationNumber() && getItemLesson(tmpB) == getNextLessonNumber() && getItemUnit(tmpB) == getNextUnitNumber()) {
				tmpA = tmpB;
			}
		}
	}
	return tmpA;
}