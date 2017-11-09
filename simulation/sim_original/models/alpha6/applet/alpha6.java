import processing.core.*; 
import processing.xml.*; 

import fisica.*; 
import geomerative.*; 
import prohtml.*; 
import controlP5.*; 

import com.google.gson.reflect.*; 
import com.google.gson.stream.*; 
import com.google.gson.annotations.*; 
import com.google.gson.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class alpha6 extends PApplet {

// Connected Chemistry Simulations
// part of the Connected Chemistry Curriculum

// Project Leader: Mike Stieff, PhD, University of Illinois at Chicago
// Modeled in Processing by: Allan Berry

// This software is Copyright \u00a9 2010, 2011 Allan Berry, and is released under
// the GNU General Public License.  Please see "copying.txt" for more details.

/*--------------------------------------------------------------------------*/

// Processing is a programming language, development environment, and online
// community that since 2001 has promoted software literacy within the visual
// arts. Processing was founded by Ben Fry and Casey Reas while both were
// John Maeda's students at the MIT Media Lab. Please visit the Processing 
// website at <http://processing.org> for more information.

/*--------------------------------------------------------------------------*/

// This file is part of the Connected Chemistry Simulations (CCS) .

// CCS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// CCS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with CCS.  If not, see <http://www.gnu.org/licenses/>.

/*--------------------------------------------------------------------------*/






boolean debug = false;

// general variables
float   mod   = 48.0f;           // setup a standard module size for graphics
float   iMod  = 48;           // same as above, but as integer
float   globalFrameRate = 60;
int     countsPerSecond = 4; // the number of times molecule quantities are recorded per second

float   headerH           = 0;
float   footerH           = 0;
float   sidebarLeftW  = mod * 6;
float   sidebarRightW = mod * 6;

float   canvasGravityX = 0;
float   canvasGravityY = 0;

float   minMolVelocity = 1;
float   defMolVelocity = 150;
float   maxMolVelocity = 200;

float   defDamping = 0;
float   defRestitution = 1; // 1 = normal
float   defEdgeRestitution = 1;
float   defFriction = 1;

float   minMoleculeScale = .25f;
float   defMoleculeScale = .75f;
float   maxMoleculeScale = 2;

int     offlineUnit   = 4;
int     offlineLesson = 7;
int     offlineSim    = 1;

public void setup(){
  size(1200, 600);
  smooth();
  noFill();
  noStroke();
  frameRate(globalFrameRate);

  Fisica.init(this);
  //Fisica.setScale(25);
  
  RG.init(this);
  RG.setPolygonizer(RG.ADAPTATIVE);
  
  setupData();
  setupTime();
  setupGUI();
  setupSimulation();
  setupSpecies();
  populateCanvas();
  
  startTimer();
  //pauseTimer();
}

public void draw(){
  //updateData();
  updateTime();
  updateSimulation();
  updateGUI();
  
  displaySimulation();
  displayGUI();
}

public void reset() {
  pauseTimer();
  setup();
}



public void contactStarted(FContact contact) {
  // Draw in green an ellipse where the contact took place
  //fill(0, 170, 0);
  //ellipse(contact.getX(), contact.getY(), 20, 20);
	if (getMolecules().contains(contact.getBody1()) && getMolecules().contains(contact.getBody2())) {
    react((Molecule)contact.getBody1(), (Molecule)contact.getBody2(), contact.getX(), contact.getY());
	}
}
class Molecule extends FPoly {
	int moleculeID = 0;
	float mass;
	
  RShape shapeFullSVG;
  RShape shapeObject;
  RShape shapeOutline;
  
  RPoint centroid;
  
  String speciesName;
  float  speciesMass = 1;
  
  float x;
  float y;
  float w;
  float h;
  
  float maxVel = 200;
  float minVel = 100;
  float maxRotVel;
  float minRotVel;
  
  float angle = random(TWO_PI); // starting angle
  float magnitude = defMolVelocity;  // starting velocity
  
    // variables to store movement data while paused
  float storeVelX;
  float storeVelY;
  float storeRotation;
  float storeAngVel;
  
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
  
  public String speciesName() {
    return speciesName;
  }
  
  public float getVelocity() {
    float v = sqrt(pow(getVelocityX(), 2) + pow(getVelocityY(), 2));
    return v;
  }
  
  public void adjustVelocity() {
    // movement curtail
    if (getVelocity() < minVel) {
      setVelocity(getVelocityX() * 1.01f, getVelocityY() * 1.01f);
    }
    if (getVelocity() > maxVel) {
      setVelocity(getVelocityX() * .99f, getVelocityY() * .99f);
    }
    
    // extreme movement curtail
    if (getVelocity() > maxVel * 3) {
      setVelocity(getVelocityX() * .75f, getVelocityY() * .75f);
    }
  }
  
  public void relocateLostMolecule() {
    float distance = (h + w) * 2;
    if (getX() > canvasArea.r + distance || 
        getX() < canvasArea.x - distance || 
        getY() > canvasArea.b + distance || 
        getY() < canvasArea.y - distance) {
      setPosition(canvasArea.mx, canvasArea.my);
    }
  }
  
  public void pauseMotion() {
    // variables to store movement data while paused
    storeVelX      = getVelocityX();
    storeVelY      = getVelocityY();
    storeAngVel    = getAngularVelocity();
    
    setVelocity(0, 0);
    setAngularVelocity(0);
  }
  
  public void unpauseMotion() {
    setVelocity(storeVelX, storeVelY);
    setAngularVelocity(storeAngVel);
  }
  
  // draw is a FPoly class overloaded (I think)
  public void draw(PGraphics applet) {
    adjustVelocity();
    
    preDraw(applet);
    shapeObject.draw(applet);
    postDraw(applet);
    
    relocateLostMolecule();
  }
}
public class Region {
  
  int     id;
  int   cBg = color(255);
  Region  parent;

  boolean scrollBars;
  boolean hasFill = false;
  boolean hasStrk = false;
  
  // variables
  float x = 0;
  float y = 0;
  float w = 0;
  float h = 0;
  float mx; // middle, x coord
  float my; // middle, y coord
  float r; // right
  float b; // bottom
  
  int cFill;
  int cStrk;
  
  // constructor
  public Region(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    setDimensions();
  }
  
  public Region() {
    setDimensions();
  }
  
  public void setParent(Region r) {
    parent = r;
  }
  
  public void setDimensions() {
    mx = x + w/2;
    my = y + h/2;
    r = x + w;
    b = y + h;
  }
  
  public void setDimensions(float x_, float y_, float w_, float h_) {
    setX(x_);
    setY(y_);
    setW(w_);
    setH(h_);
  }
  
  public void setX(float xInput) { x = xInput; setDimensions(); }
  public void setY(float yInput) { y = yInput; setDimensions(); }
  public void setW(float wInput) { w = wInput; setDimensions(); }
  public void setH(float hInput) { h = hInput; setDimensions(); }
  public void setB(float bInput) {
    float prevB = b;
    b = bInput;
    float diff = prevB - b;
    h = h - diff;
    setDimensions();
  }
  public void setR(float rInput) {
    float prevR = r;
    r = rInput;
    float diff = prevR - r;
    w = w - diff;
    setDimensions();
  }
  
  public float getX() {return x; }
  public float getY() {return y; }
  public float getW() {return w; }
  public float getH() {return h; }
  public float getR() {return r; }
  public float getB() {return b; }
  
  public float x() {return getX();}
  public float y() {return getY();}
  public float w() {return getW();}
  public float h() {return getH();}
  public float r() {return getR();}
  public float b() {return getB();}
  
  
  public void init() {
      cFill = color(127);
      cStrk = color(63);
  }
  public void update() {}
  public void display() {
    pushStyle();
      noFill();
      noStroke();
      if (hasFill == true) {fill(cFill);}
      if (hasStrk == true) {stroke(cStrk);}
      rect(x(), y(), w(), h());
    popStyle();
  }
  
  public void setFill(boolean bool) {
    if (bool == true) { hasFill = true; }
    if (bool != true) { hasFill = false; }
  }
  public void setFill(int col) {
    setFill(true);
    cFill = col;
  }
  
  public void setStrk(boolean bool) {
    if (bool == true) { hasStrk = true; }
    if (bool != true) { hasStrk = false; }}
  public void setStrk(int col) {
    setFill(true);
    cStrk = col;
  }
  
  public void scrollBars() {}
  
  public boolean mouseOver() {
    if (mouseX > x() && mouseY > y() && mouseX < r() && mouseY < b()) {
      return true;
    }
    return false;
  }
  
  public float mouseXLocal() {
    return mouseX - x();
  };
  public float mouseYLocal() {
    return mouseY - y();
  };
  
  public float mouseXLocalNorm() {
    return norm(mouseX - x(), 0, w());
  }
  
  public float mouseYLocalNorm() {
    return norm(mouseY - y(), h(), 0);
  }
  
  public String getState() {
    String state;
    if (mouseOver() && mousePressed == true) {
        state = "active";
    } else if (mouseOver()) {
        state = "over";
    } else {
      state = "up";
    }
    return state;
  }
}
// This code from the Processing Table class.  Has not been altered.

class Table {
  int rowCount;
  String[][] data;


  Table(String filename) {
    String[] rows = loadStrings(filename);
    data = new String[rows.length][];

    for (int i = 0; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue; // skip empty rows
      }
      if (rows[i].startsWith("#")) {
        continue;  // skip comment lines
      }

      // split the row on the tabs
      String[] pieces = split(rows[i], TAB);
      // copy to the table array
      data[rowCount] = pieces;
      rowCount++;

      // this could be done in one fell swoop via:
      //data[rowCount++] = split(rows[i], TAB);
    }
    // resize the 'data' array as necessary
    data = (String[][]) subset(data, 0, rowCount);
  }


  public int getRowCount() {
    return rowCount;
  }


  // find a row by its name, returns -1 if no row found
  public int getRowIndex(String name) {
    for (int i = 0; i < rowCount; i++) {
      if (data[i][0].equals(name)) {
        return i;
      }
    }
    println("No row named '" + name + "' was found");
    return -1;
  }


  public String getRowName(int row) {
    return getString(row, 0);
  }


  public String getString(int rowIndex, int column) {
    return data[rowIndex][column];
  }


  public String getString(String rowName, int column) {
    return getString(getRowIndex(rowName), column);
  }


  public int getInt(String rowName, int column) {
    return parseInt(getString(rowName, column));
  }


  public int getInt(int rowIndex, int column) {
    return parseInt(getString(rowIndex, column));
  }


  public float getFloat(String rowName, int column) {
    return parseFloat(getString(rowName, column));
  }


  public float getFloat(int rowIndex, int column) {
    return parseFloat(getString(rowIndex, column));
  }


  public void setRowName(int row, String what) {
    data[row][0] = what;
  }


  public void setString(int rowIndex, int column, String what) {
    data[rowIndex][column] = what;
  }


  public void setString(String rowName, int column, String what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = what;
  }


  public void setInt(int rowIndex, int column, int what) {
    data[rowIndex][column] = str(what);
  }


  public void setInt(String rowName, int column, int what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = str(what);
  }


  public void setFloat(int rowIndex, int column, float what) {
    data[rowIndex][column] = str(what);
  }


  public void setFloat(String rowName, int column, float what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = str(what);
  }  
}


public void initPanels(int unit, int lesson, int sim) {
  // acids and bases
  if (unit == 4) {
    if (lesson == 0) {
      if (sim == 0) {
  
      }
    }
  }
  
  else {
    unit = 0;
    lesson = 0;
    sim = 0;
    configDefault();
  }
}

public void configDefault() {
  leftPanels.add(userControlPanel);
  leftPanels.add(legendPanel);
  leftPanels.add(timePanel);
  rightPanels.add(molMonitorPanel);
  rightPanels.add(pHMonitorPanel);
  //rightPanels.add(testPanel);
  
  setCanvasWallpaper("data/wallpaper/water-065.png");
}

Table       elementTable; // main repository for element data
int         elementTableRowCount;
int[]       elementNumber;
String[]    elementName;
String[]    elementSymbol;
String[]    elementColorName;
int[]       elementColorRed;
int[]       elementColorGreen;
int[]       elementColorBlue;
//elementNameWaalsRadius;
float[]     elementAtomicRadius;
float[]     elementAtomicMass;

Table       initTable;
int         initTableRowCount;
int[]       initUnit;
int[]       initLesson;
int[]       initSim;
String[]    initSpecies;
String[]    initWidgets;

Table       reactTable;
int         reactTableRowCount;
String[]    reactants;
float[]     reactProbabilities;
String[]    reactResults;


//--------------------------------------------------------//

public void setupData() {
  setupInitTable();
  setupReactionTable();
}

//void updateData() {}


//--------------------------------------------------------//

public void setupInitTable() {
  initTable           = new Table("data/init.tsv");
  initTableRowCount   = initTable.getRowCount();
  initUnit            = new int[initTableRowCount];
  initLesson          = new int[initTableRowCount];
  initSim             = new int[initTableRowCount];
  initSpecies         = new String[initTableRowCount];
  initWidgets         = new String[initTableRowCount];
  
  for (int row = 0; row < initTableRowCount; row++) {
    initUnit[row]     = initTable.getInt(row, 0);
    initLesson[row]   = initTable.getInt(row, 1);
    initSim[row]      = initTable.getInt(row, 2);
    initSpecies[row]  = initTable.getString(row, 3);
    initWidgets[row]  = initTable.getString(row, 4);
    
    
  }
}


public void setupReactionTable() {
  reactTable          = new Table("data/reactions.tsv");
  reactTableRowCount  = reactTable.getRowCount();
  reactants           = new String[reactTableRowCount];
  reactProbabilities  = new float[reactTableRowCount];
  reactResults        = new String[reactTableRowCount];
  
  for (int row = 0; row < reactTableRowCount; row++) {
    reactants[row]          = reactTable.getString(row, 0);
    reactProbabilities[row] = reactTable.getFloat(row, 1);
    reactResults[row]       = reactTable.getString(row, 2);
  }
}

public int getUnitNumber() {
  int unit;
  try {
    unit = PApplet.parseInt(param("unitSelect"));
  } catch (Exception e) {
    unit = offlineUnit;
  }
  return unit;
}
public int getLessonNumber() {
  int lesson;
  try {
    lesson = PApplet.parseInt(param("lessonSelect"));
  } catch (Exception e) {
    lesson = offlineLesson;
  }
  return lesson;
}
public int getSimNumber() {
  int sim;
  try {
    sim = PApplet.parseInt(param("activitySelect"));
  } catch (Exception e) {
    sim = offlineSim;
  }
  return sim;
}





public boolean arrayListMatch(ArrayList al1, ArrayList al2) {
  // brute force method.
  // for each item in the first array...
  for (int i = 0; i < al1.size(); i++) {
    // check if the second array contains that item...
    if (al2.contains(al1.get(i))) {
      // if the second array contains that item, remove it.
      al2.remove(al2.indexOf(al1.get(i)));
      // if the 2nd array runs out of items to remove, then all items in al1 are in al2
    } else {
      return false;
    }
  }
  // final check: make sure the truncated al2 doesn't have anything left to remove. If so, the two arrays are equal
  if (al2.size() < 1) {
    return true;
  } else {
    return false;
  }
}

public float tempFtoC(float f) {
  float c = (5/9)*(f-32);
  return c;
}

public float tempCtoF(float c) {
  float f = ((9/5)*c) + 32;
  return f;
}

public float tempCtoK(float c) {
  float k = c + 273.15f;
  return k;
}

public float tempKtoC(float k) {
  float c = k - 273.15f;
  return c;
}

PFont   fontMyriadPro10;
PFont   fontMyriadPro12;
PFont   fontMyriadPro14;
PFont   fontMyriadPro16;
PFont   fontMyriadPro18;
PFont   fontMyriadPro22;
PFont   fontMyriadProBold12;
PFont   fontMyriadProBold14;
PFont   fontMyriadProBold16;
PFont   fontMyriadProBold22;
PFont   fontMyriadProCond12;
PFont   fontMyriadProCond14;
PFont   fontMyriadProCond16;
        
int[] cMonitor;  // lines on monitors
int   cFill_Bg;
int   cFill_Canvas;
int   cFill_Panel;
int   cStrk_Panel;
int   cFill_TabActive;
int   cStrk_TabActive;
int   cFill_TabInactive;
int   cStrk_TabInactive;
int   cFill_Label;
int   cFill_Monitor;
int   cStrk_Monitor;
int   cStrk_Default;
int   cFill_Atom;
int   cStrk_Atom;
int   cText;

Button currentButton;
        
PShape  button_arrow_small_down_down;
PShape  button_arrow_small_down_up;
PShape  button_arrow_small_left_down;
PShape  button_arrow_small_left_up;
PShape  button_arrow_small_right_down;
PShape  button_arrow_small_right_up;
PShape  button_arrow_small_up_down;
PShape  button_arrow_small_up_up;
PShape  button_minus_up;
PShape  button_pause_down;
PShape  button_pause_up;
PShape  button_play_down;
PShape  button_play_up;
PShape  button_plus_up;
PShape  button_reset_down;
PShape  button_reset_up;

//--------------------------------------------------------//

public void setupGUI() {
  createFonts();
  createColours();
  createButtonIcons();
  createContextMenu();
  
  setupAreas();
  setupPanels();
}

public void updateGUI() {
  updateAreas();
  updatePanels();
}

public void displayGUI() {
  displayAreas();
  displayPanels();
}

public void unsetCurrentButton() {
  currentButton = null;
}

public void setCurrentButton(Button button) {
  currentButton = button;
}

public Button getCurrentButton() {
  if (currentButton != null && (currentButton.getState().equals("over") ||
                                currentButton.getState().equals("active") ||
                                currentButton.getState().equals("down"))) {
    return currentButton;
  } else {
    return null;
  }
}

// areas ------------------------------------------------- //

float   horiz1;
float   horiz2;
float   vert1;
float   vert2;

float   horiz1prev;
float   horiz2prev;
float   vert1prev;
float   vert2prev;

Region  headerArea;
Region  footerArea;
Region  leftSidebarArea;
Region  rightSidebarArea;
Region  canvasArea;
Region  floaterArea;

public void setupAreas() {
  horiz1            = headerH;  // header and footer do not yet exist, although I want to make amends for them
  horiz2            = height - footerH;  // header and footer do not yet exist, although I want to make amends for them
  vert1             = sidebarLeftW;
  vert2             = width - sidebarRightW;
  
  headerArea        = new Region(0, 0, width, horiz1);  // header and footer do not yet exist
  footerArea        = new Region(0, horiz2, width, height - horiz2);  // header and footer do not yet exist
  leftSidebarArea   = new Region(0, horiz1, vert1, height - headerArea.h - footerArea.h);
  rightSidebarArea  = new Region(vert2, horiz1, width - vert2, height - headerArea.h - footerArea.h);
  canvasArea        = new Region(vert1, horiz1, width - leftSidebarArea.w - rightSidebarArea.w, height - headerArea.h - footerArea.h);
  floaterArea       = new Region(0, 0, width, height);
  
  horiz1prev        = horiz1;
  horiz2prev        = horiz2;
  vert1prev         = vert1;
  vert2prev         = vert2;

// debug
  headerArea.setFill(cFill_Panel);
  footerArea.setFill(cFill_Panel);      
  leftSidebarArea.setFill(cFill_Panel);
  rightSidebarArea.setFill(cFill_Panel);
}
public void updateAreas() {
  horiz1            = headerArea.h();  // header and footer do not yet exist, although I want to make amends for them
  horiz2            = height - footerArea.h();  // header and footer do not yet exist, although I want to make amends for them
  vert1             = leftSidebarArea.w();
  vert2             = width - rightSidebarArea.w();
  
  headerArea.setDimensions(0, 0, width, horiz1);  // header and footer do not yet exist
  footerArea.setDimensions(0, horiz2, width, height - horiz2);  // header and footer do not yet exist
  leftSidebarArea.setDimensions(0, horiz1, vert1, height - headerArea.h - footerArea.h);
  rightSidebarArea.setDimensions(vert2, horiz1, width - vert2, height - headerArea.h - footerArea.h);
  canvasArea.setDimensions(vert1, horiz1, width - leftSidebarArea.w - rightSidebarArea.w, height - headerArea.h - footerArea.h);
  floaterArea.setDimensions(0, 0, width, height);
  
  if (leftPanels.size() == 0)   { leftSidebarArea.setW(0);}
  if (rightPanels.size() == 0)  { rightSidebarArea.setW(0);}
  if (headerPanels.size() == 0) { headerArea.setH(0);}
  if (footerPanels.size() == 0) { footerArea.setH(0);}
  
  canvasArea.update();
  headerArea.update();
  leftSidebarArea.update(); 
  rightSidebarArea.update();
  footerArea.update();
  floaterArea.update();
}
public void displayAreas() {
  canvasArea.display();
  headerArea.display();
  leftSidebarArea.display(); 
  rightSidebarArea.display();
  footerArea.display();
  floaterArea.display();
}
/* panels ----------------------------------------- */

// panel collections
ArrayList leftPanels;
ArrayList rightPanels;
ArrayList headerPanels;
ArrayList footerPanels;
ArrayList floaterPanels;
ArrayList allPanels;
// predefined panel types
Panel timePanel;
Panel userControlPanel;
Panel pHMonitorPanel;
Panel molMonitorPanel;
Panel legendPanel;
Panel testPanel;

Debug debugControls;

public void setupPanels() {
  leftPanels        = new ArrayList();
  rightPanels       = new ArrayList();
  headerPanels      = new ArrayList();
  footerPanels      = new ArrayList();
  floaterPanels     = new ArrayList();
  allPanels         = new ArrayList();
  legendPanel       = new Panel("legend");
  userControlPanel  = new Panel("control");
  timePanel         = new Panel("time");
  pHMonitorPanel    = new Panel("ph");
  molMonitorPanel   = new Panel("molecule");
  testPanel         = new Panel("test");
  
  if (debug == true) {
    debugControls   = new Debug(canvasArea.x + mod/4, canvasArea.y + mod/4, 0, 0);
  }
  
  initPanels(0, 0, 0);
  Panel panel;
  for (int i = 0; i < leftPanels.size(); i++) {
    panel = (Panel)leftPanels.get(i);
    allPanels.add(panel);
  }
  for (int i = 0; i < rightPanels.size(); i++) {
    panel = (Panel)rightPanels.get(i);
    allPanels.add(panel);
  }
  for (int i = 0; i < headerPanels.size(); i++) {
    panel = (Panel)headerPanels.get(i);
    allPanels.add(panel);
  }
  for (int i = 0; i < footerPanels.size(); i++) {
    panel = (Panel)footerPanels.get(i);
    allPanels.add(panel);
  }
}

public void updatePanels() {
  Panel panel;
  for (int i = 0; i < allPanels.size(); i++) {
    panel = (Panel)allPanels.get(i);
    panel.setDimensions();
    panel.update();
  }
  
  if (debug == true) {
    debugControls.update();
  }
}

public void displayPanels() {
  Panel panel;
  for (int i = 0; i < allPanels.size(); i++) {
    panel = (Panel)allPanels.get(i);
    panel.display();
  }
  
  if (debug == true) {
    debugControls.display();
  }
}

/* Fonts ----------------------------------------- */

public void createFonts() {    
  fontMyriadPro10       = loadFont("fonts/MyriadPro-Regular-10.vlw");
  fontMyriadPro12       = loadFont("fonts/MyriadPro-Regular-12.vlw");
  fontMyriadPro14       = loadFont("fonts/MyriadPro-Regular-14.vlw");
  fontMyriadPro16       = loadFont("fonts/MyriadPro-Regular-16.vlw");
  fontMyriadPro18       = loadFont("fonts/MyriadPro-Regular-18.vlw");
  fontMyriadPro22       = loadFont("fonts/MyriadPro-Regular-22.vlw");
  fontMyriadProBold12   = loadFont("fonts/MyriadPro-Bold-12.vlw");
  fontMyriadProBold14   = loadFont("fonts/MyriadPro-Bold-14.vlw");
  fontMyriadProBold16   = loadFont("fonts/MyriadPro-Bold-16.vlw");
  fontMyriadProBold22   = loadFont("fonts/MyriadPro-Bold-22.vlw");
  fontMyriadProCond12   = loadFont("fonts/MyriadPro-Cond-12.vlw");
  fontMyriadProCond14   = loadFont("fonts/MyriadPro-Cond-14.vlw");
  fontMyriadProCond16   = loadFont("fonts/MyriadPro-Cond-16.vlw");

}
public void createColours() {
  cMonitor          = new int[12];
  cMonitor[0]       = color(255, 204, 51, 200);
  cMonitor[1]       = color(255, 126, 0, 200);
  cMonitor[2]       = color(255, 0, 0, 200);
  cMonitor[3]       = color(0, 153, 102, 200);
  cMonitor[4]       = color(0, 102, 204, 200);
  cMonitor[5]       = color(0, 0, 255, 200);
  cMonitor[6]       = color(97, 0, 98, 200);
  cMonitor[7]       = color(153, 51, 0, 200);
  cMonitor[8]       = color(255, 108, 182, 200);
  cMonitor[9]       = color(148, 61, 255, 200);
  cMonitor[10]      = color(0, 204, 255, 200);
  cMonitor[11]      = color(51, 255, 51, 200);
  cFill_Bg          = color(150);
  cFill_Canvas      = color(127);
  cFill_Panel       = color(75);
  cStrk_Panel       = color(0);
  cFill_TabActive   = color(127, 0, 0);
  cStrk_TabActive   = color(255, 0, 0);
  cFill_TabInactive = color(63, 0, 0);
  cStrk_TabInactive = color(100, 0, 0);
  cFill_Monitor     = color(100);
  cStrk_Monitor     = color(193);
  cStrk_Default     = color(0);
  cText             = color(255);
}
public void createButtonIcons() {
  button_arrow_small_down_down  = loadShape("gui/button-arrow-small-down-down.svg");
  button_arrow_small_down_up    = loadShape("gui/button-arrow-small-down-up.svg");
  button_arrow_small_left_down  = loadShape("gui/button-arrow-small-left-down.svg");
  button_arrow_small_left_up    = loadShape("gui/button-arrow-small-left-up.svg");
  button_arrow_small_right_down = loadShape("gui/button-arrow-small-right-down.svg");
  button_arrow_small_right_up   = loadShape("gui/button-arrow-small-right-up.svg");
  button_arrow_small_up_down    = loadShape("gui/button-arrow-small-up-down.svg");
  button_arrow_small_up_up      = loadShape("gui/button-arrow-small-up-up.svg");
  button_minus_up               = loadShape("gui/button-minus-up.svg");
  button_pause_down             = loadShape("gui/button-pause-down.svg");
  button_pause_up               = loadShape("gui/button-pause-up.svg");
  button_play_down              = loadShape("gui/button-play-down.svg");
  button_play_up                = loadShape("gui/button-play-up.svg");
  button_plus_up                = loadShape("gui/button-plus-up.svg");
  button_reset_down             = loadShape("gui/button-reset-down.svg");
  button_reset_up               = loadShape("gui/button-reset-up.svg");
}
public void createContextMenu() {}

/* utility ----------------------------------------- */

public float fitWithin(float w1, float h1, float w2, float h2) {
  float n;
  if (w1 > h1) {
    n = w2/w1;
  } else {
    n = h2/h1;
  }
  return n;
}


/* rounded corners ----------------------------------------- */

// Adds support for a quadratic B\u00e9zier curve by converting it 
// to a cubic B\u00e9zier curve that is supported by Processing.
// prevX and prevY are used to get the previous x,y of the current path
public void quadraticBezierVertex(float prevX, float prevY, float cpx, float cpy, float x_, float y_) {
  float cp1x = prevX + 2.0f/3.0f*(cpx - prevX);
  float cp1y = prevY + 2.0f/3.0f*(cpy - prevY);
  float cp2x = cp1x + (x_ - prevX)/3.0f;
  float cp2y = cp1y + (y_ - prevY)/3.0f;

  // finally call cubic Bezier curve function
  bezierVertex(cp1x, cp1y, cp2x, cp2y, x_, y_);
};

public void roundRect(float x_, float y_, float w_, float h_, float r_) {
  float p1x = x_ + r_;
  float p1y = y_;
  
  float p2x = x_ + w_ - r_;
  float p2y = y_;
  
  float p3x = x_ + w_;
  float p3y = y_ + r_;
  
  float p4x = x_ + w_;
  float p4y = y_ + h_ - r_;
  
  float p5x = x_ + w_ - r_;
  float p5y = y_ + h_;
  
  float p6x = x_ + r_;
  float p6y = y_ + h_;
  
  float p7x = x_;
  float p7y = y_ + h_ - r_;
  
  float p8x = x_;
  float p8y = y_ + r_;
  
  
  beginShape();
    vertex(p1x, p1y);
    vertex(p2x, p2y);
    quadraticBezierVertex(p2x, p2y, p3x, p2y, p3x, p3y);
    vertex(p4x, p4y);
    quadraticBezierVertex(p4x, p4y, p4x, p5y, p5x, p5y);
    vertex(p6x, p6y);
    quadraticBezierVertex(p6x, p6y, p7x, p6y, p7x, p7y);
    vertex(p8x, p8y);
    quadraticBezierVertex(p8x, p8y, p8x, p1y, p1x, p1y);
  endShape(CLOSE);
}









// Mouse
public void mousePressed() {
  // if mouse is over canvas, and no molecules are under the mouse
  if (canvas.getBody(mouseX, mouseY) == null && canvasArea.mouseOver() == true && overHUDButton() != true) {
    unsetCurrentSpecies();
  }
  if (canvas.getBody(mouseX, mouseY) != null && canvasArea.mouseOver() == true && overHUDButton() != true) {
    //createMolecule("Water", mouseX, mouseY);
    Molecule m = (Molecule)canvas.getBody(mouseX, mouseY);
    setCurrentSpecies(m.speciesName);
    setCurrentMolecule(m);
  }
}

// mouse
public void mouseReleased() {
  // eventually, I may convert all buttons to use this routine:
  if (getCurrentButton() != null) {
    getCurrentButton().performAction();
  }
  
  
  // legacy buttons -------------------------------------------//
  
  // user control buttons
  for (int i = 0; i < userControlPanel.userControlButtons.size(); i++) {
    Button currentButton = (Button)userControlPanel.userControlButtons.get(i);
    if (currentButton.getState().equals("over")) {
      //currentButton.performAction();
    }
  }
  
  // debug molecule buttons
  try {
    for (int i = 0; i < countSpecies(); i++) {
        Button addButton =  (Button)debugControls.addMoleculeButtonsAL.get(i);
        Button killButton = (Button)debugControls.killMoleculeButtonsAL.get(i);
      if (addButton.getState().equals("over")) {
        // this may need to be altered to account for when the random settings overlap existing molecules
        createMolecule((String)speciesNamesInOrder.get(i));
      }
      if (killButton.getState().equals("over")) {
        killMoleculeByType((String)speciesNamesInOrder.get(i));
      }
    }
  } catch (Exception e) {}
  
  for (int i = 0; i < legendPanel.legendButtons.size(); i++) {
    Button button = (Button)legendPanel.legendButtons.get(i);
    if (button.getState().equals("over")) {
      setCurrentSpecies(button.buttonName);
    }
  }
}

public boolean overHUDButton() {
  boolean over = false;
  try {
    for (int i = 0; i < countSpecies(); i++) {
      Button addButton =  (Button)debugControls.addMoleculeButtonsAL.get(i);
      Button killButton = (Button)debugControls.killMoleculeButtonsAL.get(i);
      if (addButton.getState().equals("over") || addButton.getState().equals("active")) {
        // this may need to be altered to account for when the random settings overlap existing molecules
        over = true;
      } else if (killButton.getState().equals("over") || killButton.getState().equals("active")) {
        over = true;
      }
    }
  } catch (Exception e) {}
  return over;
}
FWorld  canvas; // this is where the action happens
PImage  canvasWallpaper;

float canvasPrevX;
float canvasPrevY;
float canvasPrevW;
float canvasPrevH;
float canvasPrevR;
float canvasPrevB;

//--------------------------------------------------------//

public void setupSimulation() {
  canvas            = new FWorld();  // setup fisica world 
  setCanvasDimensions();
}

public void setCanvasDimensions() {
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

public void updateSimulation() {
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

public void displaySimulation() {
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

public void setCanvasWallpaper(String wallpaperFile) {
  canvasWallpaper = loadImage(wallpaperFile);
}

public void drawCanvasWallpaper(int overlayAlpha) {
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

public void drawCurrentMolBox() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(color(255, 127, 0, 127));
  rectMode(CENTER);
  rect(currentMolecule.getX(), currentMolecule.getY(), 100, 80);
  popStyle();
}

public FBody[] getCanvasEdges() {
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
// the sim apparently crashes above this many molecules.  
int moleculeQntyLimit = 200;

HashMap   species;
ArrayList speciesRoll;
ArrayList pHRoll;

ArrayList speciesNamesInOrder;
ArrayList speciesShapes;
String    currentSpeciesName;
Molecule  currentMolecule;

//int prevMoleculeCount;
//int moleculeCount;

ArrayList reactedMoleculeIDs;
int totalMoleculesCreated;

ArrayList molecules;
boolean mFlag; // keeps getMolecules() from running every frame; true when a molecule has been created or deleted

//--------------------------------------------------------//

public void setupSpecies() {
  species = new HashMap();
  speciesRoll = new ArrayList();
  pHRoll = new ArrayList();
  reactedMoleculeIDs = new ArrayList();
  molecules = new ArrayList();
  
  speciesNamesInOrder = new ArrayList();
  speciesShapes = new ArrayList();
  
  getInitialSpecies(getUnitNumber(), getLessonNumber(), getSimNumber());
  currentSpeciesName = new String();
}

public void getInitialSpecies(int unit, int lesson, int sim) {
  int row = 0;
  while (unit != initUnit[row] || lesson != initLesson[row] || sim != initSim[row]) {
    row++;
    if (row == initTableRowCount) {
      row = 0;
      break;
    }
  }
  String[] tmp = initSpecies[row].split(", ");
  for (int i = 0; i < tmp.length; i++) {
    String[] a = tmp[i].split(" ");
    String s = a[0];
    int n = Integer.parseInt(a[1]);
    addSpecies(s, n);
  }
}

// returns all molecules on canvas, for manipulation.  When mFlag is set true, it is very expensive.
// hwever, MFlag is still broken... FIX damMIT
public ArrayList getMolecules() {
  //if (mFlag == true) {
    molecules = new ArrayList();
    for (int i = 0; i < canvas.getBodies().size(); i++){
      String obj = canvas.getBodies().get(i).toString();
      if (obj.contains("Molecule") == true) {
        molecules.add(canvas.getBodies().get(i));
      }
    }
  //}
  mFlag = false;
  return molecules;
}

public ArrayList getSpeciesShapes() {
  String s;
  ArrayList svgs = new ArrayList();
  for (int i = 0; i < speciesNamesInOrder.size(); i++) {
    s = getSpeciesFilename((String)speciesNamesInOrder.get(i));
    svgs.add(loadShape(s));
  }
  return svgs;
}

public String getSpeciesFilename(String speciesName) {
    return "svg/" + speciesName + ".svg";
}

public Molecule getLatestMolecule() {
  return (Molecule)getMolecules().get(getMolecules().size() -1);
}

//--------------------------------------------------------//

public void addSpecies(String speciesName, int speciesQnty) {
  // this adjusts the speciesRoll if new species are created during the simulation not available at startup
  for (int i = 0; i < speciesRoll.size(); i++) {
    HashMap tmpSpecies = (HashMap)speciesRoll.get(i);
    tmpSpecies.put(speciesName, 0);
    speciesRoll.set(i, tmpSpecies);
  }
  speciesNamesInOrder.add(species.size(), speciesName);
  speciesShapes = getSpeciesShapes();
  species.put(speciesName, speciesQnty);
}

public void updateRolls() {
  speciesRoll.add(species.clone());
  pHRoll.add(getPH());
  while (reactedMoleculeIDs.size() > countMolecules()) {
    reactedMoleculeIDs.remove(0);
  }
}

public void populateCanvas() {
  for (int i = 0; i < speciesNamesInOrder.size(); i++) {
    String speciesName    = (String)speciesNamesInOrder.get(i);
    int initialPopulation = (Integer)species.get(speciesName);
    species.put(speciesName, 0);     // reset to 0 before increment
    for (int j = 0; j < initialPopulation; j++) {
      createMolecule(speciesName);
    }
  }
}

public int countMolecules() {
  int count = 0;
  for (int i = 0; i < speciesNamesInOrder.size(); i++) {
    count = count + (Integer)species.get((String)speciesNamesInOrder.get(i));
  }
  return count;
}

public int countMolecules(String speciesName) {
  if (species.containsKey(speciesName)) {
    return (Integer)species.get(speciesName);
  }
  return 0;
}

public int countMoleculesPast(String speciesName, int timeUnit) {
  if (speciesRoll.size() > 0) {
    HashMap speciesPast = new HashMap();
    speciesPast = (HashMap)speciesRoll.get(timeUnit);
    int speciesCount = (Integer)speciesPast.get(speciesName);
    return speciesCount;
  } else {
    return 0;
  }
}

public int countMostAbundantSpecies() {
  int count = 0;
  for (int i = 0; i < speciesNamesInOrder.size(); i++) {
    if ((Integer)species.get((String)speciesNamesInOrder.get(i)) > count) {
      count = (Integer)species.get((String)speciesNamesInOrder.get(i));
    }
  }
  return count;
}

public int countSpecies() {
  if (species != null) {
    return species.size();
  } else {
    return 0;
  }
  //return 5;
}

public void createMolecule(String speciesName) {
  createMolecule(speciesName, random(canvasArea.x, canvasArea.r), random(canvasArea.y, canvasArea.b));
}

public void createMolecule(String speciesName, float x, float y) {
  if (!species.containsKey(speciesName)) {
    addSpecies(speciesName, 0);
  }
  if (countMolecules() < moleculeQntyLimit) {
    Molecule molecule = new Molecule(speciesName, x, y);
    if (species.containsKey(speciesName)) {
      int prevQnty = Integer.parseInt(species.get(speciesName).toString());
      species.put(speciesName, prevQnty + 1);
    } else {
      species.put(speciesName, 1);
    }
    canvas.add(molecule);
    
    totalMoleculesCreated++;
    molecule.moleculeID = totalMoleculesCreated;
  }
  mFlag = true;
}

public void createMolecule(String speciesName, int quantity) {
  for (int i = 0; i < quantity; i++) {
    createMolecule(speciesName);
  }
}

public void killMolecule(Molecule input) {  
  int prevQnty = (Integer)species.get(input.speciesName);
  for (int i = 0; i < countMolecules(); i++) {
    Molecule molecule = (Molecule)getMolecules().get(i);
    if (molecule == input) {
      prevQnty--;
      species.put(input.speciesName, prevQnty);
      canvas.remove((FBody)canvas.getBodies().get(i));
      break;
    }
  }
  mFlag = true;
}

public void killMoleculeByType(String speciesName) {
  for (int i = 0; i < countMolecules(); i++) {
    Molecule molecule = (Molecule)getMolecules().get(i);
    
    if (molecule.speciesName().equals(speciesName)) {
      canvas.remove((FBody)canvas.getBodies().get(i));
      int prevQnty = Integer.parseInt(species.get(speciesName).toString());
      species.put(speciesName, prevQnty - 1);
      break;
    }
  }
  mFlag = true;
}

public void react(Molecule m1, Molecule m2, float contactX, float contactY ) {
  int m1ID = m1.moleculeID;
  int m2ID = m2.moleculeID;
  PVector[] mVelocities = new PVector[2];
  mVelocities[0] = new PVector(m1.getVelocityX(), m1.getVelocityY());
  mVelocities[1] = new PVector(m2.getVelocityX(), m2.getVelocityY());
  
  
  ArrayList results = getReactResults(m1, m2);
  
  if ((!reactedMoleculeIDs.contains(m1ID)) && (!reactedMoleculeIDs.contains(m2ID)) && (results.size() > 0)) {
    float offset = defMoleculeScale * 40;
    killMolecule(m1);
    killMolecule(m2);
    reactedMoleculeIDs.add(m1ID);
    reactedMoleculeIDs.add(m2ID);
    for (int i = 0; i < results.size(); i++) {
      createMolecule((String)results.get(i), contactX + (i * offset), contactY + (i * offset));
      getLatestMolecule().setVelocity(mVelocities[i].y * -2, mVelocities[i].x * -2);
      offset = offset * -1;
    }
  }
}

public ArrayList getReactResults(Molecule m1, Molecule m2) {
  //  Hydrochloric-Acid, Water	1	Hydronium, Chloride
  ArrayList emptyAL = new ArrayList();
  ArrayList mNames = new ArrayList();
  mNames.add(m1.speciesName);
  mNames.add(m2.speciesName);
  
  for (int i = 0; i < reactTableRowCount; i++) {
    ArrayList reactantsAL = new ArrayList(Arrays.asList(reactants[i].split(", ")));
    if (arrayListMatch(mNames, reactantsAL) && (random(0, 1) < reactProbabilities[i])) {
      ArrayList reactResultsAL = new ArrayList(Arrays.asList(reactResults[i].split(", ")));
      return reactResultsAL;
    }
  }
  return emptyAL;
}

public String getCurrentSpecies() {
  return currentSpeciesName;
}

public void setCurrentSpecies(String s) {
  currentSpeciesName = s;
}

public void unsetCurrentSpecies() {
  currentSpeciesName = "";
}

public void setCurrentMolecule(Molecule m) {
  currentMolecule = m;
}

public float log10(float x) {
  return (log(x) / log(10));
}

public float getPH() { 
  float pH;
  float pOH;
  int countH3O   = countMolecules("Hydronium");
  int countOH    = countMolecules("Hydroxide");
  int countOther = countMolecules() - countH3O - countOH;
  
  float volH3O   = PApplet.parseFloat(countH3O) / 100000;
  float volOH    = PApplet.parseFloat(countOH)  / 100000;
  //float volOther = float(countOther) * 1000;
  
  float volAll   = 50 + volH3O + volOH;

  if (volH3O != volOH) {
    pH  = log10(volH3O / volAll) * -1;
  } else {
    pH = 7;
  }
  
  return pH;
}

/*float getPOH() { 
  float pOH;
  int qntyH3O   = countMolecules("Hydronium");
  int qntyOH    = countMolecules("Hydroxide");
  float totalVolume = float(countMolecules()) / 1000;

  if (qntyH3O != qntyOH) {
    pOH = log10(qntyOH / totalVolume);
  } else {
    pOH = 7;
  }
  return pOH;
}*/
// New time functions
public int runTotal()   { return millis() - runStart; }
public int netPlayed()  {
  if (paused == true) {
    return netPlayed;
  } else {
    return netPlayed + timeSinceLastEvent();
  }
}
public int netPaused()  {
  if (paused == true) {
    return netPlayed + timeSinceLastEvent();
  } else {
    return netPlayed;
  }
}
public int timeSinceLastEvent() {
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

public void setupTime() {
  resetTime();
}

public void resetTime()  {
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

public void toggleTimer() {
  if (paused == true) {
    startTimer();
  } else {
    pauseTimer();
  }
}

public void pauseTimer() {
  addTime();
  paused = true;
  println("timer has PAUSED");
  timePanel.playPauseButton.buttonType = "play";
  for (int i = 0; i < getMolecules().size(); i++) {
    Molecule currMolecule = (Molecule)getMolecules().get(i);
    currMolecule.pauseMotion();
  }
}
public void startTimer() {
  addTime();
  paused = false;
  println("timer has STARTED");
  timePanel.playPauseButton.buttonType = "pause";
  for (int i = 0; i < getMolecules().size(); i++) {
    Molecule currMolecule = (Molecule)getMolecules().get(i);
    currMolecule.unpauseMotion();
  }
}

public void addTime() {
  if (paused == true) {
    netPaused = netPaused + timeSinceLastEvent();
  } else if (paused == false) {
    netPlayed = netPlayed + timeSinceLastEvent();
  } else {
    println("paused is NULL... FIX ME");
  }
  lastEvent = runTotal();
}

public void updateTime() {
  // don't forget... these will only run if the sim is paused
  if (currentRun()     > prevRunNumber) { fireEveryRun(); }
  if (currentTU()      > prevTU)        { fireEveryTU(); }
  if (currentSecond()  > prevSecond)    { fireEverySecond(); }
  if (currentMinute()  > prevMinute)    { fireEveryMinute(); }
  if (currentHour()    > prevHour)      { fireEveryHour(); }
  updatePrevValues();
}

public void fireEveryRun()     {}
public void fireEveryTU()      {
  updateRolls();
}
public void fireEverySecond()  {}
public void fireEveryMinute()  {}
public void fireEveryHour()  {}

public void updatePrevValues() {
  prevRunNumber = currentRun();
  prevTU     = currentTU();
  prevSecond = currentSecond();
  prevMinute = currentMinute();
  prevHour   = currentHour();
}

public int currentRun()    { return runNumber; }
public int currentTU()     { return floor(netPlayed()/(1000/countsPerSecond)); }
public int currentSecond() { return floor(netPlayed()/1000); }
public int currentMinute() { return floor(netPlayed()/(1000*60)); }
public int currentHour()   { return floor(netPlayed()/(1000*60*60)); }

public String currentTimeFormatted() {
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

public class Button extends Region {
  String  buttonType;
  String  buttonName;

  // action variables
  String actionName;

  // display variables
  boolean roundCorners = false;

  // label variables
  String  labelText;
  float   labelX;
  float   labelY;

  PShape buttonIcon;

  int cFillMainUp       = color(127, 127, 127);
  int cFillMainOver     = color(157, 157, 157);
  int cFillMainActive   = color(234, 91, 12);
  int cFillMainDown     = color(176, 69, 23);
  int cFillMain         = cFillMainUp;

  int cStrkMainUp       = color(100, 100, 100);
  int cStrkMainOver     = color(178, 178, 178);
  int cStrkMainActive   = color(204, 69, 23);
  int cStrkMainDown     = color(154, 52, 21);
  int cStrkMain         = cStrkMainUp;

  int cFillHandleUp     = color(51, 94, 127);
  int cFillHandleOver   = color(51, 94, 190);
  int cFillHandleActive = color(81, 186, 230);
  int cFillHandleDown   = color(38, 169, 224);
  int cFillHandle       = cFillHandleUp;

  int cStrkHandleUp     = color(43, 56, 143);
  int cStrkHandleOver   = color(43, 56, 189);
  int cStrkHandleActive = color(73, 145, 201);
  int cStrkHandleDown   = color(27, 117, 187);
  int cStrkHandle       = cStrkHandleUp;

  int cFillDim          = color(127);
  int cStrkDim          = color(110);
  int cTextDim          = color(166);

  int cStrkShadow       = color(90, 127);
  int cStrkHilite       = color(255, 25);

  // constructors
  Button() {
    buttonType = "default";
    init();
  }

  Button(String buttonType_) {
    buttonType = buttonType_;
    init();
  }

  Button(float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    buttonType = "default";
    init();
  }

    // constructor
  Button(String type_, float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    buttonType = type_;
    init();
  }

  public void init() {
    super.init();
    actionName = "default";
    buttonName = new String();
    if (buttonType.equals("Legend Button")) {}
    if (buttonType.equals("User Control Button")) {}
    setFill(true);
    setStrk(true);
  }

  public void update() {
    super.update();

    if (getState().equals("over") || getState().equals("active") || getState().equals("down")) {
      setCurrentButton(this);
    }

    setButtonColors();
    setOverrides();
    if (buttonType.equals("add molecule") || buttonType.equals("kill molecule")) {
      labelX = x() + mod/4;
      labelY = y() + mod/3;
    }

    if (buttonType.equals("add molecule")) {
      buttonIcon = button_plus_up;
    }
    if (buttonType.equals("kill molecule")) {
      buttonIcon = button_minus_up;
    }
    if (buttonType.equals("play")) {
      buttonIcon = button_play_up;
    }
    if (buttonType.equals("pause")) {
      buttonIcon = button_pause_up;
    }
    if (buttonType.equals("reset")) {
      buttonIcon = button_reset_up;
    }
    if (buttonType.equals("Legend Button")) {
      updateLegendButtons();
    }
    if (buttonType.equals("User Control Button")) {
      updateUserControlButtons();
    }
    
  }

  public void display() {
    super.display();
    
    //fill(cFillMain);
    //stroke(cStrkMain);
    
    pushStyle();
      if (hasFill == true) {fill(cFillMain);  } else {noFill();}
      if (hasStrk == true) {stroke(cStrkMain);} else {noStroke();}
    
      if (roundCorners == true) {
        roundRect(x(), y(), w(), h(), mod/8);
      }
      else {
        rect(x(), y(), w(), h());
      }
      shapeMode(CENTER);
      if (buttonIcon != null && !buttonType.equals("Legend Button")) {
        shape(buttonIcon, x() + w()/2, y() + w()/2, mod, mod);
      }
    popStyle();
    if (buttonType.equals("Legend Button")) {
      displayLegendButtons();
    }
    if (buttonType.equals("User Control Button")) {
      displayUserControlButtons();
    }
  }

  public void setButtonColors() {
    if (getState() == "over") {
      cFillMain   = cFillMainOver;
      cStrkMain   = cStrkMainOver;
      cFillHandle = cFillHandleOver;
      cStrkHandle = cStrkHandleOver;
    } else if (getState() == "active") {
      cFillMain   = cFillMainActive;
      cStrkMain   = cStrkMainActive;
      cFillHandle = cFillHandleActive;
      cStrkHandle = cStrkHandleActive;
    } else if (getState() == "down") {
      cFillMain   = cFillMainDown;
      cStrkMain   = cStrkMainDown;
      cFillHandle = cFillHandleDown;
      cStrkHandle = cStrkHandleDown;
    } else { /* up */
      cFillMain   = cFillMainUp;
      cStrkMain   = cStrkMainUp;
      cFillHandle = cFillHandleUp;
      cStrkHandle = cStrkHandleUp;
    }
  }

  public void setOverrides() {
    if (buttonType == "add molecule") {
      if (getState() == "over") {
        cFillMain   = color(74, 186, 127);
        cStrkMain   = color(86, 222, 98);
      } else if (getState() == "active") {
        cFillMain   = color(43, 199, 0);
        cStrkMain   = color(0, 148, 13);
      } else { /* up */
        cFillMain   = color(51, 128, 88);
        cStrkMain   = color(67, 172, 76);
      }
    }
    if (buttonType == "kill molecule") {
      if (getState() == "over") {
        cFillMain   = color(201, 52, 68);
        cStrkMain   = color(255, 82, 98);
      } else if (getState() == "active") {
        cFillMain   = color(255, 0, 22);
        cStrkMain   = color(191, 0, 17);
      } else { /* up */
        cFillMain   = color(128, 51, 59);
        cStrkMain   = color(189, 31, 45);
      }
    }
    if (buttonType == "Legend Button" && buttonName.equals(currentSpeciesName)) {
      if (getState() == "over") {
        cFillMain   = color(75);
        cStrkMain   = color(100);
      } else if (getState() == "active") {
        //cFillMain   = color(43, 199, 0);
        //cStrkMain   = color(0, 148, 13);
      } else { /* up */
        cFillMain   = color(50);
        cStrkMain   = color(75);
      }
    }
  }

  public void setRoundCorners() {
    roundCorners = true;
  }

  public void setLabel(String s) {
    labelText = s;
  }

  public void setIcon(PShape shape) {
    buttonIcon = shape;
  }

  public void setName(String s) {
    buttonName = s;
  }

/* actions ---------------------------------------------*/
  public String getAction() {
    return actionName;
  }

  public void setAction(String action) {
    actionName = action;
  }

  public void performAction() {
    if        (actionName.equals("default"))                  { println(this); }
    // create molecule buttons
    else if   (actionName.equals("add 5 Water"))              { createMolecule("Water", 5); }
    else if   (actionName.equals("add 5 Hydrochloric-Acid"))  { createMolecule("Hydrochloric-Acid", 5); }
    // timer buttons
    else if   (actionName.equals("toggleTimer"))              { toggleTimer(); }
    else if   (actionName.equals("reset"))                    { reset(); }
    // panel tabs
    else if   (actionName.equals("activateTab"))              { activateTab(); }
  }
  
  public void activateTab() {
    PanelContent  mom = (PanelContent)parent;
    Panel         grandma = (Panel)mom.parent;
    grandma.setActiveTab(mom.rank);
  }

/* user control buttons ---------------------------------*/

  public void setupUserControlButtons() {
  }
  public void updateUserControlButtons() {
    labelX = x() + mod * 3/8;
    labelY = y() + mod * 3/8;
  }
  public void displayUserControlButtons() {
    pushStyle();
    pushMatrix();
    translate(x(), y());
      textFont(fontMyriadPro14);
    popMatrix();
    if (labelText != null) {
      fill(cText);
      text(labelText, labelX, labelY);
    }
    popStyle();
  }

/*----------------------------------------------------------*/
// legend buttons
  public void setupLegendButtons() {
  }
  public void updateLegendButtons() {
    labelX = x() + mod * 1;
    labelY = y() + mod * 1/2;
  }
  public void displayLegendButtons() {
    pushStyle();
      pushMatrix();
      translate(x(), y());
        textFont(fontMyriadPro14);
        shape(buttonIcon, mod/4, mod/8, buttonIcon.width, buttonIcon.height);
      popMatrix();
      fill(cText);
      text(labelText, labelX, labelY);
    popStyle();
  }

/*----------------------------------------------------------------------------*/
// labels
  public void drawLabels() {
    pushStyle();
      fill(cText);
      if (labelText != null) {
        fill(cText);
        text(labelText, labelX, labelY);
      }
    popStyle();
  }
}
public class Debug extends Region {
  String type;
  
  ArrayList addMoleculeButtonsAL;
  ArrayList killMoleculeButtonsAL;
  ArrayList moleculeButtonLabels;
  
  int speciesButtonQnty;
  
  float mGroupX;
  float mGroupY;
  float mButtonMargin;
  float mButtonW;
  float mButtonH;
  
  // constructor
  Debug(float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    speciesButtonQnty = 0;
    setButtons();
  }
  
  public void setButtons() {
    mGroupX             = x();
    mGroupY             = y();
    mButtonMargin       = mod * 1/8;
    mButtonW            = mod * 3/8;
    mButtonH            = mod * 3/8;
    
    addMoleculeButtonsAL = new ArrayList();
    killMoleculeButtonsAL = new ArrayList();
    moleculeButtonLabels = new ArrayList();
    
    for (int i = 0; i < countSpecies(); i++) {
      addMoleculeButtonsAL.add(i, new Button(mGroupX, mGroupY + (mod * i/2), mButtonW, mButtonH));
      killMoleculeButtonsAL.add(i, new Button(mGroupX + mButtonW + mButtonMargin, mGroupY + (mod * i/2), mButtonW, mButtonH));
      
      Button addButton =  (Button)addMoleculeButtonsAL.get(i);
      Button killButton = (Button)killMoleculeButtonsAL.get(i);
      addButton.buttonType = "add molecule";
      killButton.buttonType = "kill molecule";
    }
  }
  
  public void update() {
    super.update();
    if (speciesButtonQnty != countSpecies()) {
      setButtons();
      speciesButtonQnty = countSpecies();
    }
    for (int i = 0; i < countSpecies(); i++) {
      Button addButton =  (Button)addMoleculeButtonsAL.get(i);
      Button killButton = (Button)killMoleculeButtonsAL.get(i);
      addButton.update();
      killButton.update();
            String speciesName = (String)speciesNamesInOrder.get(i);
      moleculeButtonLabels.add(i, speciesName + " " + countMolecules(speciesName));
    }
  }
  
  public void display() {
    super.display();
    for (int i = 0; i < addMoleculeButtonsAL.size(); i++) {
      Button addButton =  (Button)addMoleculeButtonsAL.get(i);
      Button killButton = (Button)killMoleculeButtonsAL.get(i);
      addButton.display();
      killButton.display();
      
      pushStyle();
        fill(255);
        textFont(fontMyriadPro10);
        text(moleculeButtonLabels.get(i).toString(), x() + mod, mGroupY + (mod * i/2) + mButtonH * 3/4);
      popStyle();
      
    }
  }
}
public class Monitor extends Region{
  // variables
    int       monitorID;
    String    monitorType;   // e.g. "molecule", "pH"
    
    // display variables
    int   fillColor = cFill_Monitor;
    int   strokeColor = cStrk_Monitor;
    
    // label variables
    int   labelColor;
    float   labelX1;
    float   labelY1;
    float   labelX2;
    float   labelY2;
    
    String  timeElapsedMMSS;
    
    // monitor variables
    
    float sectionQnty;    // 
    float sectionDuration;  // number of seconds it takes to cross from left to right of a monitor Section
    float sectionDurationTUs;
    float monitorDuration;
    float monitorDurationTUs;
    
    int yTicks = 50; // starting number of ticks along Y axis
    int yIncrement = 10; // increments for Molecules monitor

    float sectionW;  // LENGTH measure; defaults to distance covered in a minute
    float xTicksPerSection;
    float xTicksTotal;  // number of ticks along X axis

    float xTick; 
    float yTick;

    float currentX;
      // also need to check whether any species count exceeds yTicksTotal; if so, increase yTicksTotal
      // yTicksTotal = whatever is greater: 50 or the largest molecule species count
    
    float labelOffset;
    float textLocTY;
    float textLocRX;
    float textLocBY;
    float textLocLX;
    
    String textCrosshairR;
    String textCrosshairB;
    
    String textTL; 
    String textTC; 
    String textTR; 
    String textRT; 
    String textRC; 
    String textRB; 
    String textBL; 
    String textBC; 
    String textBR; 
    String textLT; 
    String textLC; 
    String textLB;
    
    float rightBoxX;
    float rightBoxW;
    float rightBoxH;
    float rightBoxY;

    float bottomBoxY;
    float bottomBoxW;
    float bottomBoxH;
    float bottomBoxX;

    float yMolQnty;
    float xSeconds;

    String yMolQntyFormatted;
    String xMinutesFormatted;
    String xSecondsFormatted;
    String xFormatted;
    
  // constructor
  public Monitor() {
    init();
  }
  
  public Monitor(String monitorType_) {
    monitorType = monitorType_;
    init();
  }

  // constructor
  public Monitor(String monitorType_, float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    monitorType = monitorType_;
    init();
  };
  
  public void setType(String monitorType_) {
    monitorType = monitorType_;
  }
  
  public void init() {
    super.init();
    
    cFill = fillColor;
    setLabels();
    sectionDuration = 60;  // number of seconds it takes to cross from left to right of a monitor Section
    sectionDurationTUs = sectionDuration * countsPerSecond;
  }
  
  public void setLabels() {
    labelOffset = mod/6;
    textFont(fontMyriadPro10, 10);
    labelColor = cFill_Label;
    textLocTY = y() - mod/2;
    textLocRX = y() + w() + mod/2;
    textLocBY = y() + h() + mod/2;
    textLocLX = x() - mod/2;
    
    textCrosshairR = "";
    textCrosshairB = "";
    textTL = ""; 
    textTC = ""; 
    textTR = ""; 
    textRT = ""; 
    textRC = ""; 
    textRB = ""; 
    textBL = ""; 
    textBC = ""; 
    textBR = ""; 
    textLT = ""; 
    textLC = ""; 
    textLB = "";
  }

  public void update() {
    super.update();
    sectionQnty         = currentMinute() + 1;
    monitorDuration     = sectionQnty * sectionDuration;
    monitorDurationTUs  = monitorDuration * countsPerSecond;
    sectionW            = w() / sectionQnty;  // LENGTH measure; defaults to distance covered in a minute
    xTicksPerSection    = sectionDurationTUs;
    xTicksTotal         = sectionQnty * xTicksPerSection;
    xTick               = w() / getXTicks(); 
    yTick               = h() / getYTicks();
    currentX            = xTick * currentTU();
    
    // WHEN REIMPLEMENTING THESE, USE VARIABLES SET EACH SECOND
    
    // override default labelling
    if (monitorType == "molecule monitor") {
      textCrosshairR = yMolQntyFormatted;
      textCrosshairB = xFormatted;
      
      textTL = "Molecule Count: " + str(countMolecules());
      textTC = "";
      textTR = "";
      textRT = "";
      textRC = "";
      textRB = "";
      textBL = "Start";
      textBC = "Time";
      textBR = floor(sectionQnty) + " mins";
      textLT = str(floor(getYTicks()));
      textLC = "# of molecules";
      textLB = str(0);
    } else if (monitorType == "ph monitor") {
      textCrosshairR = nf(14 * mouseYLocalNorm(), 0, 1);
      textCrosshairB = xFormatted;
      
      textTL = "pH: " + nf(getPH(), 0, 2);
      textTC = "";
      textTR = "";
      textRT = "";
      textRC = "";
      textRB = "";
      textBL = "Start";
      textBC = "Time";
      textBR = floor(sectionQnty) + " mins";
      textLT = str(14);
      textLC = "pH Level";
      textLB = str(0);

    }
  }
  
  public void display() {
    super.display();
    drawGrid();
    drawMonitorLines();
    //drawHead();
    drawStroke(); // stroke and labels should be drawn after visualization
    drawLabels();
    drawCrosshairs();
  }
  
  
  public float getXTicks() {
    return xTicksTotal;
  }
  
  public float getYTicks() {
    int ticks = countMostAbundantSpecies();
    if (yTicks > ticks) {
      return yTicks;
    } else {
      yTicks = ticks;
      return ticks;
    }
  }


/*----------------------------------------------------------------------------*/
// box

  
  public void drawGrid() {
    pushStyle();
    stroke(85);
    pushMatrix();
      translate(x(), y());
      for (int i = 0; i < sectionQnty; i++) {
        line(xTicksPerSection * xTick * i, 0, xTicksPerSection * xTick * i, h());
      }
      if (monitorType.equals("molecule monitor")) {
        int i = 0;
        while (yIncrement * i < yTicks) {
          line(0, h() - (yIncrement * i * yTick), w(), h() - (yIncrement * i * yTick));
          i++;
        }
      }
      if (monitorType.equals("ph monitor")) {
        line(0, h()/2, w(), h()/2);
      }
    popMatrix();
    popStyle();
  }
  
  public void drawMonitorLines() {
    // the following variable allows a monitor with decreased resolution to only render certain modulo of available data
    int skip = floor(sectionQnty);
    
    pushMatrix();
    translate(x(), y());
    pushStyle();
    
    if (monitorType.equals("molecule monitor")) {
      float xValue = 0;
      float yValue = h();
      int speciesQnty = countSpecies();
      
      float[] prevX = new float[speciesQnty];
      float[] prevY = new float[speciesQnty];

      // init previous location array
      for (int i = 0; i < prevX.length; i++) {
        prevX[i] = 0;
        prevY[i] = h();
      }

      int[] countAtTimeX = new int[species.size()];
      for (int i = 1; i < speciesRoll.size(); i=i+skip) {
        
        for (int j = 0; j < species.size(); j++) {
          String specName = (String)speciesNamesInOrder.get(j);
          countAtTimeX[j] = countMoleculesPast(specName, (i-1));
        }

        for (int ii = 0; ii < speciesQnty; ii++) {
          stroke(cMonitor[ii]);
          strokeWeight(1.5f);

          xValue = i * xTick;
          yValue = h() - (countAtTimeX[ii] * yTick);

          line(xValue, yValue, prevX[ii], prevY[ii]);

          prevX[ii] = xValue;
          prevY[ii] = yValue;
        }
      }
    } else if (monitorType.equals("ph monitor")) {
      
      // pH Monitor
      float xValue = 0;
      float yValue = h();
      float prevX = 0;
      float prevY = h();

      float   pHval;

      for (int i = 1; i < pHRoll.size(); i=i+skip) {
        pHval = (Float)pHRoll.get(i-1);
        stroke(255);
        strokeWeight(1.5f);

        xValue = i * xTick;
        yValue = h() - map(pHval, 0, 14, 0, h());

        line(xValue, yValue, prevX, prevY);

        prevX = xValue;
        prevY = yValue;
      }
    }
    popStyle();
    popMatrix();
  }
  
  public void drawCrosshairs() {
    
    pushStyle();
    stroke(127);
    pushMatrix();
    
    translate(x, y);
      if (getState() == "over" || getState() == "active" ) {
        // horizontal line
        line(0, mouseYLocal(), w(), mouseYLocal());
        // vertical line
        line(mouseXLocal(), 0, mouseXLocal(), h());
        
        // labels
        fill(0, 150);
        rightBoxX = 0;
        rightBoxW = mod * 5/8;
        rightBoxH = mod/2;
        rightBoxY = mouseYLocal() - rightBoxH/2;
        
        bottomBoxY = 0;
        bottomBoxW = mod*5/8;
        bottomBoxH = mod/2;
        bottomBoxX = mouseXLocal() - rightBoxW/2;
        
        yMolQnty = getYTicks() * mouseYLocalNorm();
        
        xSeconds = sectionDuration * sectionQnty * mouseXLocalNorm();
        
        yMolQntyFormatted = str(round(yMolQnty));
        xMinutesFormatted = nf(round(xSeconds) / 60, 2);
        xSecondsFormatted = nf(round(xSeconds) % 60, 2);
        xFormatted = xMinutesFormatted + ":" + xSecondsFormatted;
        
        pushMatrix();
        translate(w(), 0);
          rect(rightBoxX, rightBoxY, rightBoxW, rightBoxH);
          textAlign(CENTER);
          pushStyle();
            try {
              fill(cText);
              text(textCrosshairR, rightBoxX + rightBoxW/2, rightBoxY + rightBoxH/2 + mod/12);
            } catch (Exception e) {}
          popStyle();
        popMatrix();
        
        pushMatrix();
        translate(0, h());
          rect(bottomBoxX, bottomBoxY, bottomBoxW, bottomBoxH);
          textAlign(CENTER);
          pushStyle();
            try {
              fill(cText);
              text(textCrosshairB, bottomBoxX + bottomBoxW/2, bottomBoxY + bottomBoxH/2 + mod/12);
            } catch (Exception e) {}
          popStyle();
        popMatrix();
      }
    popMatrix();
    popStyle();
  }
  
  public void drawStroke() {
    pushStyle();
      noFill();
      /*// frame, to mask a little of line overlap
      stroke(cFill_Bg);
      strokeWeight(3);
      rect(x - 2, y - 2, w + 4, h + 4);*/
      stroke(strokeColor);
      strokeWeight(1);
      rect(x(), y(), w(), h());
    popStyle();
  }

/*----------------------------------------------------------------------------*/
// labels
  public void drawLabels() {
    
    pushStyle();
    fill(cText);
    // top text
    pushStyle();
      textFont(fontMyriadProBold12, 12);
      textAlign(LEFT);
      text(textTL, x(), y() - labelOffset);
    popStyle();
    textAlign(CENTER);
    text(textTC, x() + w()/2, y() - labelOffset);
    textAlign(RIGHT);
    text(textTR, x() + w(), y() - labelOffset);
    
    // right text
    textAlign(LEFT);
    text(textRT, x() + w() + labelOffset, y() + labelOffset);
    pushMatrix();
      textAlign(CENTER);
      translate(x() + w() + labelOffset, y() + h()/2);
      rotate(PI/2);
      text(textRC, 0, 0);
    popMatrix();
    textAlign(LEFT);
    text(textRB, x() + w() + labelOffset, y() + h());
    
    // bottom text
    textAlign(LEFT);
    text(textBL, x(), y() + h() + labelOffset + labelOffset);
    textAlign(CENTER);
    text(textBC, x() + w()/2, y() + h() + labelOffset + labelOffset);
    textAlign(RIGHT);
    text(textBR, x() + w(), y() + h() + labelOffset + labelOffset);
    
    // left text
    textAlign(RIGHT);
    text(textLT, x() - labelOffset, y() + labelOffset);
    pushMatrix();
      textAlign(CENTER);
      translate(x() - labelOffset, y() + h()/2);
      rotate(PI/2*-1);
      text(textLC, 0, 0);
    popMatrix();
    textAlign(RIGHT);
    text(textLB, x() - labelOffset, y() + h());
    
    popStyle();
  };
};
public class Panel extends Region {
  
  String type;
  
  String    panelTitle;
  Region    panelTitleBar;
  boolean   collapsed = false;
  Button    collapseButton;
  

  float     panelMargin = mod/2;
  float     defaultButtonH = mod * 3/4;
  float     defaultInterval = mod * 1/8;
  
  // constructors
  Panel(String type_) {
    type = type_;
    init();
  }
  
  Panel(String type_, float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    type = type_;
    init();
  }
  
  // methods
  public void init() {
    super.init();
    panelTitle = "";
    initTitleBar();
    if (type.equals("ph")) {
      initMonitors();
    } else if (type.equals("molecule")) {
      initMonitors();
      initExtender();
    } else if (type.equals("time")) {
      initTimeButtons();
      panelTitle = "Time Controls";
    } else if (type.equals("legend")) {
      initLegendButtons();
      panelTitle = "Species Legend";
    } else if (type.equals("control")) {
      initUserControls();
      panelTitle = "User Controls";
    } else if (type.equals("test")) {
      initTest();
      panelTitle = "Tabs (test)";
    }
  }
  public void update() {
    super.update();
    updateTitleBar();
    if (type.equals("ph")) {
      updateMonitors();
    } else if (type.equals("molecule")) {
      updateMonitors();
      updateExtender();
    } else if (type.equals("time")) {
      updateTimeButtons();
    } else if (type.equals("legend")) {
      updateLegendButtons();
      setB(bottomButtonB() + panelMargin);
    } else if (type.equals("control")) {
      updateUserControls();
    } else if (type.equals("test")) {
      updateTest();
    }
  }
  public void display() {
    super.display();
    displayTitleBar();
    if (type.equals("ph")) {
      displayMonitors();
    } else if (type.equals("molecule")) {
      displayMonitors();
      println(x());
      if (mouseOver() == true) {
        displayExtender();
      }
    } else if (type.equals("time")) {
      displayTimeButtons();
    } else if (type.equals("legend")) {
      displayLegendButtons();
    } else if (type.equals("control")) {
      displayUserControls();
    } else if (type.equals("test")) {
      displayTest();
    }
    // border
    pushStyle();
      noFill();
      strokeWeight(1);
      stroke(100);
      rect(x(), y(), w(), h());
    popStyle();
  }
/* titlebar ----------------------------------------- */

  public void initTitleBar() {
    panelTitleBar = new Region();
    panelTitleBar.setDimensions(x(), y(), w(), mod/2);
    panelTitleBar.setFill(color(63));
    
    float collapseButtonW = mod * 3/8;
    float collapseButtonH = mod * 3/8;
    float collapseButtonX = r() - collapseButtonW - mod * 1/16;
    float collapseButtonY = y() + mod * 1/16;
    collapseButton = new Button(collapseButtonX, collapseButtonY, collapseButtonW, collapseButtonH);
    collapseButton.buttonType = "collapse";
  }
  public void updateTitleBar() {
    panelTitleBar.update();
    panelTitleBar.setDimensions(x(), y(), w(), mod/2);
    
    collapseButton.update();
  }
  public void displayTitleBar() {
    panelTitleBar.display();
    
    pushMatrix();
    translate(x() + mod * 1/4, y() + mod * 1/3);
      pushStyle();
        fill(190);
        textFont(fontMyriadPro14);
        textAlign(LEFT);
        text(panelTitle, 0, 0);
      popStyle();
    popMatrix();
    
    collapseButton.display();
  }

  public void toggleCollapsed() {
    if (collapsed == false) {
      collapsed = true;
    } else {
      collapsed = false;
    }
  }


/* dimensions -------------------------------------- */
  public float x() {
    int inputPanelRank;
    float result = 0;
    if      (leftPanels.contains(this))     {result =  leftSidebarArea.x(); }
    else if (rightPanels.contains(this))    {result =  rightSidebarArea.x(); }
    else if (floaterPanels.contains(this))  {result =  floaterArea.x();}
    else if (headerPanels.contains(this)) {
      inputPanelRank = headerPanels.indexOf(this);
      result = headerArea.x();
      for (int i = 0; i < inputPanelRank; i++) {
        Panel panel = (Panel)headerPanels.get(i);
        result = result + panel.w();
      }
    }
    else if (footerPanels.contains(this)) {
      inputPanelRank = footerPanels.indexOf(this);
      result = footerArea.x();
      for (int i = 0; i < inputPanelRank; i++) {
        Panel panel = (Panel)footerPanels.get(i);
        result = result + panel.w();
      }
    }
    x = result;
    return result;
  }
  public float y() {
    int inputPanelRank;
    float result = 0;
    if      (headerPanels.contains(this))  {result =  headerArea.y(); }
    else if (footerPanels.contains(this))  {result =  footerArea.y(); }
    else if (floaterPanels.contains(this)) {result =  floaterArea.y();}
    else if (leftPanels.contains(this)) {
      inputPanelRank = leftPanels.indexOf(this);
      result = leftSidebarArea.y();
      for (int i = 0; i < inputPanelRank; i++) {
        Panel panel = (Panel)leftPanels.get(i);
        result = result + panel.h();
      }
    }
    else if (rightPanels.contains(this)) {
      inputPanelRank = rightPanels.indexOf(this);
      result = rightSidebarArea.y();
      for (int i = 0; i < inputPanelRank; i++) {
        Panel panel = (Panel)rightPanels.get(i);
        result = result + panel.h();
      }
    }
    y = result;
    return result;
  }

  public float w() {
    float result = 0;
    if      (leftPanels.contains(this))     { result = leftSidebarArea.w(); }
    else if (rightPanels.contains(this))    { result = rightSidebarArea.w(); }
    else if (floaterPanels.contains(this))  { result = floaterArea.w(); }
    else                                    { result = mod * 6; }
    
    // overrides
    w = result;
    return result;
  }

  public float h() {
    float result = 0;
    
    if      (headerPanels.contains(this))  { result = headerArea.h(); }
    else if (footerPanels.contains(this))  { result = footerArea.h(); }
    else if (floaterPanels.contains(this)) { result = floaterArea.h(); }
    else                                   { result = mod * 3; }
    
    // overrides
    if (type.equals("control"))             { result = (defaultButtonH + defaultInterval) * userControlButtons.size(); }
    if (type.equals("legend"))              { result = (defaultButtonH + defaultInterval) * countSpecies(); }
    if (type.equals("time"))                { result = mod*3/2; }
    if (type.equals("ph"))                  { result = mod*2; }
    if (type.equals("molecule"))            { result = mod*6; }
    if (type.equals("test"))                {
      if (panelContentFormat.equals("list")) {
        result = 0;
        for (int i = 0; i < panelContents.size(); i++) {
          Region region = (Region)panelContents.get(i);
          result = result + region.h();
        }
      } else { // tabs
        result = 0;
        for (int i = 0; i < panelContents.size(); i++) {
          Region region = (Region)panelContents.get(i);
          if (region.h() > result) {
            result = region.h();
          }
        }
      }
    }
    result = result + panelTitleBar.h() + panelMargin/2;
    h = result;
    return result;
  }

/* test ---------------------------- */
  ArrayList panelContents;
  String    panelContentFormat = "tab";  // "list" or "tabs"
  int       activetab;
  
  public void initTest() {
    panelContents = new ArrayList();
    panelContents.add(new PanelContent(panelContentFormat, this));
    panelContents.add(new PanelContent(panelContentFormat, this));
    panelContents.add(new PanelContent(panelContentFormat, this));
    activetab = 0;
  }
  public void updateTest() {
    float contentY = panelTitleBar.b();
    if (panelContentFormat.equals("tab")) {
      int rank = 0;
      for (int i = 0; i < panelContents.size(); i++) {
        PanelContent content = (PanelContent)panelContents.get(i);
        content.setDimensions(x(), contentY, w(), mod);
        content.setRank(rank);
        content.setTabW(w()/panelContents.size());
        content.update();
        if (activetab == i) {
          content.activate();
        }
        rank++;
      }
    }
    else if (panelContentFormat.equals("list")) {
      for (int i = 0; i < panelContents.size(); i++) {
        PanelContent content = (PanelContent)panelContents.get(i);
        content.setDimensions(x(), contentY, w(), mod);
        content.update();
        contentY = contentY + content.h();
      }
    }
  }
  public void displayTest() {
    PanelContent content;
    for (int i = 0; i < panelContents.size(); i++) {
      if (i != activetab) {
        content = (PanelContent)panelContents.get(i);
        content.deactivate();
        content.display();
      }
    }    
    content = (PanelContent)panelContents.get(activetab);
    content.display();
  }
  
  public void setActiveTab(int i) {
    activetab = i;
  }

/* control panel -------------------- */

  ArrayList userControlButtons;

  public void initUserControls() {
    userControlButtons = new ArrayList();
  }
  
  public void updateUserControls() {
    for (Iterator<Button> iter = userControlButtons.iterator(); iter.hasNext();) {
        iter.next().update();
    }
    int i = userControlButtons.size();
    while (i < 2) {
      float buttonX = x() + mod/2;
      float buttonY = y() + ((defaultButtonH + defaultInterval) * i) + panelTitleBar.h() + panelMargin/3;
      float buttonW = w() - mod;
      float buttonH = defaultButtonH;
      
      Button button = new Button("User Control Button");
      button.setDimensions(buttonX, buttonY, buttonW, buttonH);
      userControlButtons.add(button);
      if (i == 0) {
        button.setLabel("Add 5 Water Molecules");
        button.setAction("add 5 Water");
      }
      if (i == 1) {
        button.setLabel("Add 5 Hydrochloric Acid Molecules");
        button.setAction("add 5 Hydrochloric-Acid");
      }
      button.setRoundCorners();
      i++;
    }
  }
  
  public void displayUserControls() {
    for (Iterator<Button> iter = userControlButtons.iterator(); iter.hasNext();) {
        iter.next().display();
    }
  }

/* monitor panels -------------------------- */
  Monitor monitor;

  public void initMonitors() {    
    monitor  = new Monitor();
    if (type.equals("molecule")) {
      monitor.setType("molecule monitor");
    } else if (type.equals("ph")) {
      monitor.setType("ph monitor");
    }
    monitor.setFill(cFill_Monitor);
  }
  
  public void updateMonitors() {
    monitor.setDimensions(x() + mod * 1/2, y() + panelTitleBar.h(), w() - mod * 9/8, h() - mod);
    monitor.update();
  }
  
  public void displayMonitors() {
    monitor.display();
  }
  
/* monitor panel extender -------------------*/
  Region extender;
  
  public void initExtender() {
    extender = new Region();
    extender.setFill(color(0, 190));
  }
  
  public void updateExtender() {
  }
  
  public void displayExtender() {
    extender.setDimensions(x() - mod*4, y(), mod*4, h());
    extender.display();
    for (int i = 0; i < species.size(); i++) {
      String name = (String)speciesNamesInOrder.get(i);
      pushStyle();
      pushMatrix();
      translate(extender.x() + mod/2, extender.y() + (mod*3/4) + (mod/3 * i));
        fill(cMonitor[i]);
        stroke(100);
        rect(0, (mod/4) * -1, (mod/2), (mod/4));
        fill(255);
        noStroke();
        textFont(fontMyriadPro12);
        textAlign(LEFT);
        text(name, mod*3/4, 0);
      popMatrix();
      popStyle();
    }
  }
  
/* time control panel -------------------------- */
  Button playPauseButton;
  Button resetButton;

  public void initTimeButtons() {
    playPauseButton = new Button("play");
    playPauseButton.setAction("toggleTimer");
    
    resetButton     = new Button("reset");
    resetButton.setAction("reset");
  }
  public void updateTimeButtons() {
    playPauseButton.setDimensions(x() + panelMargin, y() + panelTitleBar.h() + panelMargin/3, mod, mod);
    resetButton.setDimensions(playPauseButton.r() + defaultInterval, y() + panelTitleBar.h() + panelMargin/3, mod, mod);
    
    playPauseButton.update();
    resetButton.update();  
  }
  public void displayTimeButtons() {
      playPauseButton.display();
      resetButton.display();
      // timer
      pushMatrix();
      pushStyle();
        translate(x() + mod * 4, y() + mod);
        fill(255);
        textFont(fontMyriadPro18);
        textAlign(RIGHT);
        text(currentTimeFormatted(), 0, 0);
      popStyle();
      popMatrix();
  }
  
/* legend panel -------------------------- */
  ArrayList legendButtons;

  public void initLegendButtons() {
    legendButtons = new ArrayList();
  }
  
  public void updateLegendButtons() {
    float buttonX = x() + panelMargin;
    float buttonY = y() + (mod/2) + panelMargin/3;
    float buttonW = w() - panelMargin * 2;
    float buttonH = defaultButtonH;
    
    int i = legendButtons.size();
    while (i < species.size()) {
      Button button = new Button("Legend Button");
      PShape buttonShape = (PShape)speciesShapes.get(i);
      buttonShape = buttonShape.getChild("object");
      buttonShape.scale(fitWithin(buttonShape.width, buttonShape.height, buttonH * 3/4, buttonH * 3/4));
      button.setIcon(buttonShape);
      legendButtons.add(button);
      i++;
    }
    for (int j = 0; j < legendButtons.size(); j++) {
      Button button = (Button)legendButtons.get(j);
      String speciesName = (String)speciesNamesInOrder.get(j);
      button.setDimensions(buttonX, buttonY + ((defaultButtonH + defaultInterval) * j), buttonW, buttonH);
      button.setName(speciesName);
      button.setLabel(speciesName);
      button.setRoundCorners();
      button.update();
    }
  }
  public void displayLegendButtons() {
    Button button;
    for (int i = 0; i < legendButtons.size(); i++) {
      button = (Button)legendButtons.get(i);
      button.display();
    }
  }
  
  public float bottomButtonB() {
    float result = 0;
    if (type.equals("legend")) {
      Button button = (Button)legendButtons.get(legendButtons.size()-1);
      result = button.b();
    } else if (type.equals("User Controls")) {}
    return result;
  }
  
  public void setButtonQnty() {
    if (type.equals("legend")) {}
    else if (type.equals("User Controls")) {}
  }
}

/* general ----------------------------- */

public class PanelContent extends Region {
  
  String    type  = "tab";  // "list" or "tabs";
  String    title;
  Button    tabButton;
  int       rank;
  boolean   active;
  
  float hz1;
  float hz2;
  float hz3;
  float vt1;
  float vt2;
  float vt3;
  float vt4;
  
  float tabH = mod/2;
  float tabW = mod * 15/16;
  float tabInterval = mod/16;
  
  // constructors
  PanelContent(String type_, Region parent_) {
    type = type_;
    parent = parent_;
    init();
  }
  
  // methods
  public void init() {
    super.init();
    tabButton = new Button();
    tabButton.setParent(this);
    tabButton.setAction("activateTab");
  }
  public void update() {
    super.update();
    hz1 = y();
    hz2 = y() + tabH;
    hz3 = b();
    vt1 = x();
    vt2 = x() + (tabW * rank) + tabInterval;
    vt3 = vt2 + tabW - tabInterval * 2;
    vt4 = r();
    tabButton.update();
    tabButton.setFill(false);
    tabButton.setStrk(false);
    tabButton.setDimensions(vt2, hz1, tabW - tabInterval * 2, tabH);
  }
  
  
  public void setTabW(float tabW_) {
    tabW = tabW_;
  }
  
  public void setRank(int rank_) {
    rank = rank_;
  }
  
  public void activate() {
    active = true;
  }
  
  public void deactivate() {
    active = false;
  }
  
  public void display() {
    super.display();
    
    float vertex1;
    
    if (type.equals("tab")) {
      pushStyle();
        if (active) {
          fill(cFill_TabActive);
          stroke(cStrk_TabActive);
        }
        else        {
          fill(cFill_TabInactive);
          stroke(cStrk_TabInactive);
        }
        beginShape();
          vertex(vt1, hz2); // 1
          vertex(vt2, hz2); // 2
          vertex(vt2, hz1); // 3
          vertex(vt3, hz1); // 4
          vertex(vt3, hz2); // 5
          vertex(vt4, hz2); // 6
          vertex(vt4, hz3); // 7
          vertex(vt1, hz3); // 8
        endShape();
      popStyle();
      tabButton.display();
    } else if (type.equals("list")) {
      pushStyle();
        fill(color(127, 0, 0));
        rect(vt1, hz1, w(), h());
      popStyle();
    }
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "alpha6" });
  }
}
