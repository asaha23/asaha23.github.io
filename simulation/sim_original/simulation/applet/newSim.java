import processing.core.*; 
import processing.xml.*; 

import fisica.*; 
import geomerative.*; 
import prohtml.*; 

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

public class newSim extends PApplet {

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
int   	iMod  = 48;           // same as above, but as integer
float   globalFrameRate = 60;
int     countsPerSecond = 2; // the number of times molecule quantities are recorded per second

float   headerH       = 0;
float   footerH       = 0;
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

int     unit        		= 0;
int     lesson      		= 0;
int     simulation  		= 0;

int     nextUnit        = 0;
int     nextLesson      = 0;
int     nextSimulation  = 0;

int 		selectedUnit				= 0;
int 		selectedLesson			= 0;
int 		selectedSimulation 	= 0;

int 		currentUnit 			= -1;  // are all of these necessary?
int 		currentLesson 		= -1;
int 		currentSimulation = -1;

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
  initGui();
  setupSimulation();
  setupSpecies();
  populateCanvas();

  startTimer();
	//pauseTimer();
	
}

public void draw(){
  //updateData();
  updateTime();

  updateAreas();
  updateSimulation();
  updatePanels();
	updateWidgets();

  displayAreas();
  displaySimulation();
  displayPanels();
	displayWidgets();
	
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
  Region  parent;
	boolean hidden = false;

	boolean showLabel = false;
	String 	label;
	PFont labelFont;
	float labelX;
	float labelY;
	
	public void setLabelX(float input) {
		labelX = input;
	}
	public void setLabelY(float input) {
		labelY = input;
	}
	public float getLabelX() {
		return labelX;
	}
	public float getLabelY() {
		return labelY + mod/4;
	};
	
	public void setLabel(String input) {
		showLabel = true;
		label = input;
	}
	
	public void setLabel(boolean input) {
		showLabel = input;
	}
	
	public void setLabelFont(PFont input) {
		labelFont = input;
	};
	
	public String getLabel() {
		return label;
	}

	// occasionally, a region must be associated with a particular piece of content; this string is for storage.
	String content;

  boolean scrollBars;
  
  // absolute variables
  float x = 0;
  float y = 0;
  float w = 0;
  float h = 0;
  float r;    // right
  float b;    // bottom
  float mx;   // middle, x coord
  float my;   // middle, y coord
  float relX; // these variables are generated at runtime based on margin plus absolute
  float relY; // variables.
  float relW;
  float relH;
  float relR;
  float relB;
  
  boolean hasFill; // by default, regions have no background
  boolean hasStrk; // by default, regions have no outline
  int   cFill;
  int   cStrk = color(0);
  
  PImage  wallpaper;
  int     wallpaperDarkness;
  
  float   margin = 0;
  float   marginTop    = margin;
  float   marginRight  = margin;
  float   marginBottom = margin;
  float   marginLeft   = margin;
  
  float   padding = 0; 
  float   paddingTop    = padding;
  float   paddingRight  = padding;
  float   paddingBottom = padding;
  float   paddingLeft   = padding;
  
  String corners = "";
  float  cornerRadius = mod/8;
  
  public Region(Region parent_) {
		parent = parent_;
    x = parent.x();
    y = parent.y();
    w = parent.w();
    h = parent.h();
    setDimensions();
		setLabel("Region Default");
		labelFont = fontMyriadPro12;
  }
  
  // constructor
  public Region(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    setDimensions();
		labelFont = fontMyriadPro12;
		//setLabel("Region Default");
  }
  
  public Region() {
    setDimensions();
		labelFont = fontMyriadPro12;
		//setLabel("Region Default");
  }

  public void update() {
    setDimensions();
//println("update:  " + this + "   " + "   x:" + str(x()) + "   y:" + str(y()) + "   labelX:" + str(getLabelX()) + "   labelY:" + str(getLabelY()) + "  " + getLabel());

  }
  public void display() {
		displayBg();
		displayLabel();
		//println("display: " + this + "   " + "   x:" + str(x()) + "   y:" + str(y()) + "   labelX:" + str(getLabelX()) + "   labelY:" + str(getLabelY()) + "  " + getLabel());
  }
  
  public void setParent(Region region) {
    parent = region;
  }
  
  public void setDimensions(float x_, float y_, float w_, float h_) {
    setX(x_);
    setY(y_);
    setW(w_);
    setH(h_);
    setDimensions();
  }

	float storedX;
	float storedY;
	float storedW;
	float storedH;
	public void hide() {
		hidden = true;
		storedX = x();
		storedY = y();
		storedW = w();
		storedH = h();
		setDimensions(width, height, 0, 0);
	}
	public void unHide() {
		hidden = false;
		setX(storedX);
		setY(storedY);
		setW(storedW);
		setH(storedH);
		setDimensions();
	}
  
  public void setDimensions() {
    setR();
    setB();
    setMX();
    setMY();
    setRelX();
    setRelY();
    setRelW();
    setRelH();
    setRelR();
    setRelB();
  }
  
  public void setR()     {r  = x() + w();}
  public void setB()     {b  = y() + h();}
  public void setMX()    {mx = x() + w()/2;}
  public void setMY()    {my = y() + h()/2;}
  public void setRelX()  {relX = x() + marginLeft;} 
  public void setRelY()  {relY = y() + marginTop;}
  public void setRelW()  {relW = w() - (marginLeft + marginRight);}
  public void setRelH()  {relH = h() - (marginTop + marginBottom);}
  public void setRelR()  {relR = r() - marginRight;}
  public void setRelB()  {relB = b() - marginBottom;}

  public void setX(float xInput) { x = xInput; }
  public void setY(float yInput) { y = yInput; }
  public void setW(float wInput) { w = wInput; }
  public void setH(float hInput) { h = hInput; }
  public void setR(float rInput) {
    float prevR = r();
    setR(rInput);
    float diff = prevR - r();
    setW(w() - diff);
  }
  public void setB(float bInput) {
    float prevB = b();
    setB(bInput);
    float diff = prevB - b();
    setH(h() - diff);
  }

  public float x()     				{return x; }
  public float y()     				{return y; }
  public float w()     				{return w; }
  public float h()     				{return h; }
  public float r()     				{return r; }
  public float b()     				{return b; }
  public float mx()    				{return mx;}
  public float my()    				{return my;}
  public float relX()  				{return relX;}
  public float relY()  				{return relY;}
  public float relW()  				{return relW;}
  public float relH()  				{return relH;}
  public float relR()  				{return relR;}
  public float relB()  				{return relB;}
  public float cornerRadius() 	{return cornerRadius; }
	
  
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

	public void displayLabel() {
		if (showLabel == true) {
			pushStyle();
				fill(255);
				textFont(labelFont);
	    	text(label, x() + getLabelX(), y() + getLabelY());
	   	popStyle();
		} 
	}

  public void displayBg() {
    pushMatrix();
    translate(x(), y());
    pushStyle();
      if (cFill == 0) 				{ noFill(); }
      else                    { fill(cFill);}
      if (cStrk == 0)					{ noStroke(); }
      else                    { stroke(cStrk);}
			
      if (corners.equals("rounded"))  { roundRect(0,0,w(), h(), cornerRadius()); }
      else                            { rect(		  0,0,w(), h()); }
    popStyle();
    popMatrix();
    if (wallpaper != null) {
      displayWallpaper();
    }
  }

	public void setFill(int input) { cFill = input; }
	public void setStrk(int input) { cStrk = input; }
	public void removeFill() { cFill = 0; }
	public void removeStrk() { cStrk = 0; }
	

	public void wallpaper(String imagePath, int darkness) {
  	PImage img = loadImage(imagePath);
  	wallpaper = img;
  	wallpaperDarkness = darkness;
	}

	public void displayWallpaper() {
	  pushStyle();
	    noStroke();
	    float imageW = wallpaper.width; 
	    float imageH = wallpaper.height;
  
	    int imageQntyHoriz = ceil(w() / imageW);
	    int imageQntyVert = ceil(h() / imageH);
  
	    for (int i = 0; i < imageQntyHoriz; i++) {
	      for (int j = 0; j < imageQntyVert; j++) {
	        float imageX = x() + (i * imageW);
	        float imageY = y() + (j * imageH);
	        image(wallpaper, imageX, imageY);
	      }
	    }
	    fill(color(0, wallpaperDarkness));
	    rect(x(), y(), w(), h());
	  popStyle();
	}
  
  public void setMargin(float input) {
    margin = input;
    setMarginTop(input);
    setMarginRight(input);
    setMarginBottom(input);
    setMarginLeft(input);
  }
  
  public void setMarginTop(float input)     { marginTop = input;}
  public void setMarginRight(float input)   { marginRight = input;}
  public void setMarginBottom(float input)  { marginBottom = input;}
  public void setMarginLeft(float input)    { marginLeft = input;}
  
  public void setPadding(float input) {
    padding = input;
    setPaddingTop(input);
    setPaddingRight(input);
    setPaddingBottom(input);
    setPaddingLeft(input);
  }
  
  public void setPaddingTop(float input)     { paddingTop = input;}
  public void setPaddingRight(float input)   { paddingRight = input;}
  public void setPaddingBottom(float input)  { paddingBottom = input;}
  public void setPaddingLeft(float input)    { paddingLeft = input;}
  
  public void setCorners(String input) {
    corners = input;
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


float menu1W = mod * 5;
float menu2W = mod * 9;
float menu3W = mod * 9;
float menuH  = mod * 4;
float menuMargin = mod/2;

float hz1 = mod;
float hz2 = hz1 + menuH;

float vt1 = mod/2;
float vt2 = vt1 + menu1W;
float vt3 = vt2 + menuMargin;
float vt4 = vt3 + menu2W;
float vt5 = vt4 + menuMargin;
float vt6 = vt5 + menu3W;

HashMap allItemsRanked = new HashMap();

String[] allItems = new String[] {
  //"01:  Modeling and Matter",
  //"02:  Solutions",
  //"03:  Reactions",
  //"04:  Gas Laws and Pressure",
  //"05:  Thermodynamics",
  //"06:  Kinetics",
  //"07:  Equilibrium",
  "08:  Acids and Bases",
  "08-02:  Acid Base Theory",
  "08-02-01:  Hydrochloric Acid + Water = Hydronium, Chlorine Ion",
  "08-02-02:  Sodium Hydroxide + Water = Water, Hydroxide",
  "08-02-03:  Hydrochloric Acid + Sodium Hydroxide = Chlorine Ion, Water",
  "08-02-04:  Hydrochloric Acid + Ammonia = Chlorine Ion, Ammonium Ion",
  "08-02-05:  Cyanide Ion + Hydrogen Bromide = Hydrogen Cyanide, Bromine Ion",
  "08-02-06:  Boron Trichloride + Chlorine Ion = Boron Tetrachloride",
  "08-03:  Disassociation of Acids and Bases",
  "08-03-01:  Strong acid (Hydrochloric Acid) added to water",
  "08-03-02:  Weak acid (Hydrogen Fluoride) added to water",
  "08-03-03:  Strong base (Sodium Hydroxide) added to water",
  "08-03-04:  Weak base (Ammonia) added to water",
  "08-04:  Identifying Acids and Bases and Mathematical Relationships",
  "08-04-01:  Acetic Acid added to water",
  "08-04-02:  Lithium Hydroxide added to water",
  "08-04-03:  Methylamine added to water",
  "08-04-04:  Nitric Acid added to water",
  "08-06:  Titration Curves: Strong Base into Strong Acid",
  "08-06-01:  Hydrochloric Acid + Sodium Hydroxide = Sodium Chloride + Water",
  "08-07:  Titration Curves",
  "08-07-01:  Strong acid into weak base (HCl into NH3) = Ammonium Chloride",
  "08-07-02:  Weak acid (Acetic Acid) into strong base (Sodium Hydroxide) = Water + Sodium Acetate (Conjugate Base)",
  "08-07-03:  Weak acid (Acetic Acid) into weak base (Ammonia) = Ammonium Acetate",
  "08-08:  Buffers",
  "08-08-01:  BROKEN buffered solution: Water, Sodium Carbonate, Bicarbonate, Sodium Ions, Carbonate"//,
  //"09:  Nuclear Chemistry"
};
ArrayList allItemsAL = new ArrayList();
ArrayList allUnitsAL = new ArrayList();
ArrayList allLessonsAL = new ArrayList();
ArrayList allSimulationsAL = new ArrayList();

public String getItemId(String item) {
  String[] strings = split(item, ":");
  return strings[0];
}
public String getItemText(String item) {
  String[] strings = split(item, ":");
  return trim(strings[1]);
}

public Integer getItemUnit(String itemId) {
  int output;
  if (itemId.length() >= 2) {
    output = PApplet.parseInt(itemId.substring(0, 2));
    return output;
  } else {
    return -1;
  }
}
public Integer getItemLesson(String itemId) {
  int output;
  if (itemId.length() >= 5) {
    output = PApplet.parseInt(itemId.substring(3, 5));
    return output;
  } else {
    return -1;
  }
}
public Integer getItemSimulation(String itemId) {
  int output;
  if (itemId.length() >= 8) {
    output = PApplet.parseInt(itemId.substring(6, 8));
    return output;
  } else {
    return -1;
  }
}


public String getItem(String itemId) {
  String output = "";
  for (int i=0; i<allItems.length; i++) {
    String currentItemId = getItemId(allItems[i]);
    if (currentItemId.equals(itemId)) {
      output = allItems[i];
    }
  }
  return output;
}
public String getItemType(String itemId) {
  String type = null;
  String[] idParts = split(itemId, "-");
  if      (idParts.length == 1) {type = "unit";}
  else if (idParts.length == 2) {type = "lesson";}
  else if (idParts.length == 3) {type = "simulation";}
  else                          {type = null;}
  return type;
}

public String[] filterByType(String[] items, String type) {
  ArrayList itemsAL = convertStringArrayToArrayList(items);
  itemsAL = filterByType(itemsAL, type);
	return convertArrayListToStringArray(itemsAL);
}

public ArrayList filterByType(ArrayList items, String type) {
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

public ArrayList filterByUnit(ArrayList items, int unit_) {
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

public ArrayList filterByLesson(ArrayList items, int lesson_) {
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

public ArrayList filterBySimulation(ArrayList items, int simulation_) {
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

/*boolean hasChildren(String item) {
	String itemId = getItemId(item);
	String itemType = getItemType(itemId);
	ArrayList items = new ArrayList();
	for (int i = 0; i < allItemsAL.size(); i++) {
		String tmpItem = (String)allItemsAL.get(i);
		
	}
	if (items > 0) {
		return true;
	} else {
		return false;
	}
}*/

public void setCurrentItem(String type, int choice) {
  String itemKey = type + str(choice);

  String itemId = (String)allItemsRanked.get(itemKey);
  
  String itemType = getItemType(itemId);
  if (itemType.equals("unit")) {}
  if (itemType.equals("lesson")) {}
  if (itemType.equals("simulation")) {}
  
  int itemUnit = getItemUnit(itemId);
  int itemLesson = getItemLesson(itemId);
  int itemSimulation = getItemSimulation(itemId);
  
  setCurrentUnit(itemUnit);
  setCurrentLesson(itemLesson);
  setCurrentSimulation(itemSimulation);
}

public String getCurrentItem(String type_) {
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

public String getNextItem(String type_) {
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

public int getUnitNumber() 										{ return unit; }
public int getLessonNumber() 									{ return lesson; }
public int getSimulationNumber() 							{ return simulation; }
                                    		
public void setUnitNumber(int input) 					{ unit = input; }
public void setLessonNumber(int input) 				{ lesson = input; }
public void setSimulationNumber(int input) 		{ simulation = input; }

public int getNextUnitNumber() 								{ return nextUnit; }
public int getNextLessonNumber() 							{ return nextLesson; }
public int getNextSimulationNumber() 					{ return nextSimulation; }
                                    		
public void setNextUnitNumber(int input) 			{ nextUnit = input; }
public void setNextLessonNumber(int input) 		{ nextLesson = input; }
public void setNextSimulationNumber(int input) { nextSimulation = input; }

public int getSelectedUnit()                  {  return selectedUnit; }
public int getSelectedLesson()                {  return selectedLesson; }
public int getSelectedSimulation()            {  return selectedSimulation; }

public void setSelectedUnit(int input)        {  selectedUnit = input; }
public void setSelectedLesson(int input)      {  selectedLesson = input; }
public void setSelectedSimulation(int input)  {  selectedSimulation = input; }

public int getCurrentUnit()                  {  return unit; }
public int getCurrentLesson()                {  return lesson; }
public int getCurrentSimulation()            {  return simulation; }

public void setCurrentUnit(int input)        {  unit = input; }
public void setCurrentLesson(int input)      {  lesson = input; }
public void setCurrentSimulation(int input)  {  simulation = input; }


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

public String[] convertArrayListToStringArray(ArrayList arrayList)  {
  String[] output = new String[arrayList.size()];
  String outputItem;
  for (int i=0; i<output.length; i++) {
    outputItem = (String)arrayList.get(i);
    output[i] = outputItem;
  }
  return output;
}
public ArrayList convertStringArrayToArrayList(String[] stringArray) {
  ArrayList output = new ArrayList();
  for (int i=0; i<stringArray.length; i++) {
    output.add(stringArray[i]);
  }
  return output;
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

// Mouse
public void mousePressed() {
  // if mouse is over canvas, and no molecules are under the mouse
  if (canvas.getBody(mouseX, mouseY) == null && canvasArea.mouseOver() == true /*&& overHUDButton() != true*/) {
    unsetCurrentSpecies();
  }
  if (canvas.getBody(mouseX, mouseY) != null && canvasArea.mouseOver() == true /*&& overHUDButton() != true*/) {
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
		println(getCurrentButton().actionName);
    getCurrentButton().performAction();
  }
  
  
  // legacy buttons -------------------------------------------//
  /*
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
  } */
}
/*
boolean overHUDButton() {
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
} */
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
  
  getInitialSpecies(getUnitNumber(), getLessonNumber(), getSimulationNumber());
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
	currentMolecule = null;
  currentSpeciesName = s;
}

public void unsetCurrentSpecies() {
  currentSpeciesName = "";
}

public void setCurrentMolecule(Molecule m) {
  currentMolecule = m;
}

public void pickMoleculeOfSpecies(String species) {
	for (int i = 0; i<getMolecules().size(); i++) {
		Molecule molecule = (Molecule)getMolecules().get(i);
		if (molecule.speciesName().equals(species)) {
			setCurrentMolecule(molecule);
			break;
		}
	}
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
  //timePanel.playPauseButton.buttonType = "play"; // FIX
  for (int i = 0; i < getMolecules().size(); i++) {
    Molecule currMolecule = (Molecule)getMolecules().get(i);
    currMolecule.pauseMotion();
  }
}
public void startTimer() {
  addTime();
  paused = false;
  println("timer has STARTED");
  //timePanel.playPauseButton.buttonType = "pause"; // FIX
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
ArrayList		allRegions;
ArrayList 	allAreas;
ArrayList 	allPanels;
ArrayList 	allWidgets;
ArrayList 	allButtons;
ArrayList		allMenus;

public void initGui() {
	allRegions = new ArrayList();
	allAreas   = new ArrayList();
  allPanels  = new ArrayList();
	allWidgets = new ArrayList();
	allButtons = new ArrayList();
	allMenus	 = new ArrayList();
	
  initFonts();
  initColours();
	
  initAreas();
  initPanels();

  initButtonIcons();
  initContextMenu();
}



///////////
/* FONTS */
///////////

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

public void initFonts() {    
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

////////////
/* COLORS */
////////////

int[] cMonitor;  // lines on monitors
int   cFill_Area;
int   cStrk_Area;
int   cFill_Canvas;
int   cFill_Panel;
int   cStrk_Panel;
int		cFill_Titlebar;
int		cStrk_Titlebar;
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

public void initColours() {
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
  cFill_Area        = color(50);
  cStrk_Area        = color(50);
  cFill_Canvas      = color(127);
  cFill_Panel       = color(40);
  cStrk_Panel       = color(30);
	cFill_Titlebar    = color(25);
	cStrk_Titlebar    = color(12);
  cFill_TabActive   = color(127, 0, 0);
  cStrk_TabActive   = color(255, 0, 0);
  cFill_TabInactive = color(63, 0, 0);
  cStrk_TabInactive = color(100, 0, 0);
  cFill_Monitor     = color(100);
  cStrk_Monitor     = color(193);
  cStrk_Default     = color(0);
  cText             = color(255);
}

//////////////////
/* CONTEXT MENU */
//////////////////

public void initContextMenu() {}

/////////////
/* BUTTONS */
/////////////

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

public void initButtonIcons() {
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


/////////////
/* UTILITY */
/////////////
public Menu getMenu(String menuName) {
	Menu menu;
	for (int i = 0; i < allMenus.size(); i++) {
		menu = (Menu)allMenus.get(i);
		if (menu.type.equals(menuName)) {
			return menu;
		} 
	}
	return null;
}


public float fitWithin(float w1, float h1, float w2, float h2) {
  float n;
  if (w1 > h1) {
    n = w2/w1;
  } else {
    n = h2/h1;
  }
  return n;
}

/////////////////////
/* ROUNDED CORNERS */
/////////////////////

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
//Region  floaterArea;


int panelBg = color(127);

public void initAreas() {
  horiz1            = headerH;  // header and footer do not yet exist, although I want to make amends for them
  horiz2            = height - footerH;  // header and footer do not yet exist, although I want to make amends for them
  vert1             = sidebarLeftW;
  vert2             = width - sidebarRightW;
  
  headerArea        = new Region(0, 0, width, horiz1);  // header and footer do not yet exist
  footerArea        = new Region(0, horiz2, width, height - horiz2);  // header and footer do not yet exist
  leftSidebarArea   = new Region(0, horiz1, vert1, height - headerArea.h - footerArea.h);
  rightSidebarArea  = new Region(vert2, horiz1, width - vert2, height - headerArea.h - footerArea.h);
  canvasArea        = new Region(vert1, horiz1, width - leftSidebarArea.w - rightSidebarArea.w, height - headerArea.h - footerArea.h);
  //floaterArea       = new Region(0, 0, width, height);
  
  horiz1prev        = horiz1;
  horiz2prev        = horiz2;
  vert1prev         = vert1;
  vert2prev         = vert2;

	allAreas.add(canvasArea);
	allAreas.add(headerArea);
	allAreas.add(leftSidebarArea);
	allAreas.add(rightSidebarArea);
	allAreas.add(footerArea);
	//allAreas.add(floaterArea);
	

	canvasArea.wallpaper("data/wallpaper/water-050.png", 190);
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
  //floaterArea.setDimensions(0, 0, width, height);
  
  //if (leftPanels.size() == 0)   { leftSidebarArea.setW(0);}
  //if (rightPanels.size() == 0)  { rightSidebarArea.setW(0);}
  //if (headerPanels.size() == 0) { headerArea.setH(0);}
  //if (footerPanels.size() == 0) { footerArea.setH(0);}

	canvasArea.setFill(cFill_Canvas);
	headerArea.setFill(cFill_Area);
	footerArea.setFill(cFill_Area);
	leftSidebarArea.setFill(cFill_Area);
  rightSidebarArea.setFill(cFill_Area);

	for (int i = 0; i<allAreas.size(); i++) {
		Region area = (Region)allAreas.get(i);
		area.update();
	}
}
public void displayAreas() {
	for (int i = 0; i<allAreas.size(); i++) {
		Region area = (Region)allAreas.get(i);
		area.display();
	}
}
ArrayList leftPanels;
ArrayList rightPanels;
ArrayList headerPanels;
ArrayList footerPanels;
//ArrayList floaterPanels;

public void initPanels() {
  leftPanels        = new ArrayList();
  rightPanels       = new ArrayList();
  headerPanels      = new ArrayList();
  footerPanels      = new ArrayList();
  //floaterPanels     = new ArrayList();
  
	allItemsAL 				= convertStringArrayToArrayList(allItems);
	allUnitsAL 				= convertStringArrayToArrayList(filterByType(allItems, "unit"));
	allLessonsAL 			= convertStringArrayToArrayList(filterByType(allItems, "lesson"));
	allSimulationsAL 	= convertStringArrayToArrayList(filterByType(allItems, "simulation"));

  // this is where all the panels and widgets get loaded
  loadPanels(unit, lesson, simulation);
  
  Panel panel;
  float marginDefault = mod/16;
  // initial settings for panels based on Area
  for (int i = 0; i < leftPanels.size(); i++) {
    panel = (Panel)leftPanels.get(i);
    panel.setParent(leftSidebarArea);
  }
  for (int i = 0; i < rightPanels.size(); i++) {
    panel = (Panel)rightPanels.get(i);
    panel.setParent(rightSidebarArea);
  }
  for (int i = 0; i < headerPanels.size(); i++) {
    panel = (Panel)headerPanels.get(i);
    panel.setParent(headerArea);
  }
  for (int i = 0; i < footerPanels.size(); i++) {
    panel = (Panel)footerPanels.get(i);
    panel.setParent(footerArea);
  }
  /*for (int i = 0; i < floaterPanels.size(); i++) {
    panel = (Panel)floaterPanels.get(i);
    panel.setParent(floaterArea);
  }*/
  
  // initial settings for all panels
  for (int i = 0; i < allPanels.size(); i++) {
    panel = (Panel)allPanels.get(i);
    panel.setPadding(mod/8);
    panel.setMargin(mod/12);
    panel.setMarginTop(0);
    panel.setLabelX(panel.paddingLeft);
    panel.showTitlebar(true);
    panel.displayContent(true);
    panel.setCorners("rounded");
  }
}

public void updatePanels() {
  Panel panel;
  for (int i = 0; i < leftPanels.size(); i++) {
    panel = (Panel)leftPanels.get(i);
    panel.setRank(i);
  }
  for (int i = 0; i < rightPanels.size(); i++) {
    panel = (Panel)rightPanels.get(i);
    panel.setRank(i);
  }
  for (int i = 0; i < headerPanels.size(); i++) {
    panel = (Panel)headerPanels.get(i);
    panel.setRank(i);
  }
  for (int i = 0; i < footerPanels.size(); i++) {
    panel = (Panel)footerPanels.get(i);
    panel.setRank(i);
  }
  /*for (int i = 0; i < floaterPanels.size(); i++) {
    panel = (Panel)floaterPanels.get(i);
    panel.setRank(i);
  }*/
  for (int i = 0; i < allPanels.size(); i++) {
    panel = (Panel)allPanels.get(i);
    panel.update();
  }
}

public void displayPanels() {
  Panel panel;
  for (int i = 0; i < allPanels.size(); i++) {
    panel = (Panel)allPanels.get(i);
    panel.display();
  }
}

public void updateWidgets() {
  Widget widget;
  for (int i = 0; i < allWidgets.size(); i++) {
    widget = (Widget)allWidgets.get(i);
    widget.update();
  }
}

public void displayWidgets() {
  Widget widget;
  for (int i = 0; i < allWidgets.size(); i++) {
    widget = (Widget)allWidgets.get(i);
    widget.display();
  }
}
ArrayPanel controlPanel;
ArrayPanel selectPanel;
ArrayPanel legendPanel;
SinglePanel molMonitorPanel;
SinglePanel phMonitorPanel;
SinglePanel timePanel;

// these functions will be overridden by units, lessons and simulations.  Interface for customization.
public void loadPanels(int unit, int lesson, int simulation) {
  startPanels();
  loadCustomPanels(unit, lesson, simulation);
}

public void loadCustomPanels(int unit, int lesson, int simulation) {
	molMonitorPanel.setContentH(mod * 5);
	phMonitorPanel.setContentH(mod * 3);
  //headerPanels.add(testHeaderPanel1);
  //headerPanels.add(testHeaderPanel2);
  leftPanels.add(selectPanel);
  leftPanels.add(controlPanel);
  leftPanels.add(legendPanel);
	rightPanels.add(timePanel);
  rightPanels.add(molMonitorPanel);
  rightPanels.add(phMonitorPanel);
  //rightPanels.add(dashPanel); 
  //rightPanels.add(testTabPanel);
}

public void startPanels() {
  // control widgets

  ArrayList inputs            = new ArrayList();
  Button add5Water            = new Button("Control Button", "add 5 Water");
		add5Water.setLabel("Add 5 Water Molecules");
	  inputs.add(add5Water);
  Button add5HCl              = new Button("Control Button", "add 5 Hydrochloric-Acid");
		add5HCl.setLabel("Add 5 Hydrochloric Acid molecules");
  	inputs.add(add5HCl);
  controlPanel      = new ArrayPanel("controlPanel", "Control Panel", "list", inputs);
  
  // dashboard widgets
  /*ArrayList dashboard         = new ArrayList();
  Gauge timer                 = new Gauge("time");
	  dashboard.add(timer);
  Gauge molCount              = new Gauge("molecule count");
  	dashboard.add(molCount);
  ArrayPanel dashPanel         = new ArrayPanel("Dashboard", "list", dashboard); */
  

	
	// sim selection panels
	ArrayList menus = new ArrayList();
		Menu unitMenu = new Menu("unitSelect", allUnitsAL);
			menus.add(unitMenu);
		Menu lessonMenu = new Menu("lessonSelect", allLessonsAL);
			menus.add(lessonMenu);
		Menu simulationMenu = new Menu("simulationSelect", allSimulationsAL);
			menus.add(simulationMenu);
	selectPanel = new ArrayPanel("selectPanel", "Simulation Selector", "list", menus);
  
  // legend widgets
  ArrayList legendItems = new ArrayList();
  legendPanel = new ArrayPanel("legendPanel", "Legend", "list", legendItems);
  
  // monitors
  Monitor molMonitor = new Monitor("molecules");
  molMonitorPanel = new SinglePanel("Molecules", molMonitor);
  
  Monitor phMonitor = new Monitor("pH");
  phMonitorPanel = new SinglePanel("pH", phMonitor);

	// time buttons
	Frame timeFrame = new Frame("Time");
  timePanel = new SinglePanel("Time", timeFrame);
  
  // tests
  //Widget testWidget1 = new Widget();
  //SinglePanel  testHeaderPanel1 = new SinglePanel("Test 1", testWidget1);
  
  //Widget testWidget2 = new Widget();
  //SinglePanel  testHeaderPanel2 = new SinglePanel("Test 2", testWidget2);
  
  //ArrayList testTabItems = new ArrayList();
  //Region testRegion1 = new Region();
  //Region testRegion2 = new Region();
  //Region testRegion3 = new Region();
  //testTabItems.add(testRegion1);
  //testTabItems.add(testRegion2);
  //testTabItems.add(testRegion3);
  //ArrayPanel  testTabPanel = new ArrayPanel("Tabs test", "tabs", testTabItems);
}
public class Panel extends Region {
  String type = "";
  
  int rank = 0;
  
  Region    titlebar;
  boolean   showTitlebar = true;
  
  Button    collapseButton;
  boolean   collapsed = false;
  boolean   displayContent = true;
  
  float 		defaultPanelW = mod * 2;
  float 		defaultPanelH = mod * 2;
  
  float 		titlebarH = mod/3;
  float 		contentW = mod * 2;
  float 		contentH = mod * 2;
  
  Panel() {
		//if (!allPanels.contains(this)) {
    	allPanels.add(this);
		//}
		setLabel("Panel Default");
    titlebar = new Region();
    titlebar.setFill(cFill_Titlebar);
    titlebar.setStrk(cStrk_Titlebar);

		setFill(cFill_Panel);
		setStrk(cStrk_Panel);

		//showLabel(true);
  }

	public void display() {
		displayBg();
		displayTitlebar();
	};

  
  public void updateTitlebar() {
    if (showTitlebar() == true) {
			titlebar.setDimensions(x(), y(), w(), titlebarH);
    } else {
			titlebar.setDimensions(0, 0, 0, 0);
    }
    titlebar.update();
  }
  
  public void displayTitlebar() {
    //super.display();
		displayBg();
    if (showTitlebar() == true) {
			titlebar.display();
		}
		displayLabel();
  }
  
  public int getRank() {
    return rank;
  }

  
  public float x() {
    float tmpX = 0;
    if (parent == leftSidebarArea || parent == rightSidebarArea) {
      tmpX = parent.x();
    } else if (parent == headerArea || parent == footerArea) {
      if (rank == 0) {
        tmpX = parent.x();
      } else { tmpX = getYoungerSibling().r(); }
    }
    return tmpX;
  }
  public float y() {
    float tmpY = 0;
    if (parent == headerArea || parent == footerArea) {
      tmpY = parent.y();
    } else if (parent == leftSidebarArea || parent == rightSidebarArea) {
      if (rank == 0) {
        tmpY = parent.y();
      } else { tmpY = getYoungerSibling().b(); }
    }
    return tmpY;
  }
  public float w() {
    float tmpW = 0;
    if (parent == leftSidebarArea || parent == rightSidebarArea) {
      tmpW = parent.w();
    } else {
      tmpW = tmpW + contentW() + marginLeft + marginRight + paddingLeft + paddingRight;
    }
    return tmpW;
  }
  public float h() {
    float tmpH = 0;
    if (showTitlebar == true) {
      tmpH = titlebar.h();
    }
    if (displayContent == true) {
      if (parent == headerArea || parent == footerArea) {
        tmpH = parent.h();
      } else {
        tmpH = tmpH + contentH() + marginTop + marginBottom + paddingTop + paddingBottom;
      }
    } else {
      if (parent == leftSidebarArea || parent == rightSidebarArea) {
        tmpH = tmpH + marginTop + marginBottom;
      }
    }
    return tmpH;
  }
  
  public float contentX() {
    float tmpX = relX() + paddingLeft;
    return tmpX;
  }
  public float contentY() {
    float tmpY = relY() + paddingTop;
    if (showTitlebar == true) {
      tmpY = tmpY + titlebar.h();
    }
    return tmpY;
  }
  public float contentW() {
    float tmpW = 0;
    if (parent == leftSidebarArea || parent == rightSidebarArea) {
      tmpW = relW() - paddingLeft - paddingRight;
    }
    else { // parent == headerArea || parent == footerArea
      tmpW = contentW;
    }
    return tmpW;
  }
  public float contentH() {
    float tmpH = 0;
    if (parent == leftSidebarArea || parent == rightSidebarArea) {
      tmpH = contentH;
    }
    else { // parent == headerArea || parent == footerArea
      tmpH = relH() - titlebar.h() - paddingTop - paddingBottom;
    }
    return tmpH;
  }
  public float contentR() {
    float tmpR = 0;
    tmpR = contentX() + contentW();
    return tmpR;
  }
  public float contentB() {
    float tmpB = 0;
    tmpB = contentY() + contentH();
    return tmpB;
  }
  
  public void setContentW(float input) {
    contentW = input;
  }
  
  public void setContentH(float input) {
    contentH = input;
  }
  
  public Panel getOlderSibling()   {
    ArrayList siblings = getSiblings();
    if (siblings.size() > 1 && rank <= siblings.size()-2) {
      Panel sibling = (Panel)siblings.get(rank +1);
      return sibling;
    }
    else {return null;}
  }
  public Panel getYoungerSibling() {
    ArrayList siblings = getSiblings();
    if (siblings.size() > 1 && rank >= 1) {
      Panel sibling = (Panel)siblings.get(rank -1);
      return sibling;
    }
    else {return null;}
  }
  
  public ArrayList getSiblings() {
    if      (parent == headerArea)       { return headerPanels;}
    else if (parent == footerArea)       { return footerPanels;}
    else if (parent == leftSidebarArea)  { return leftPanels;  }
    else if (parent == rightSidebarArea) { return rightPanels; }
    else                                 { return allPanels;}
  }
  
  public void showTitlebar(boolean input) {
    if (input == true) { showTitlebar = true;
    } else             { showTitlebar = false; }
  }
  
  public boolean showTitlebar() {
    if (showTitlebar == true) { return true;
    } else                    { return false; }
  }
  
  public void displayContent(boolean input) {
    if (input == true) { displayContent = true;
    } else             { displayContent = false; }
  }
  
  public boolean displayContent() {
    if (displayContent == true) { return true;
    } else                    { return false; }
  }
  
  public void setRank(int input) {
    rank = input;
  }
  
  public void setType(String input) {
    type = input;
  }
  
  public String getType() {
    return type;
  }
}
public class Widget extends Region {
  String type = "";
  
  Widget() {
		//setLabel("Widget Default");
		//if (!allWidgets.contains(this)) {
			allWidgets.add(this);
		//}
		setStrk(color(0, 0, 255));
		setFill(color(0, 0, 127, 127));
  }
  
  Widget(String type_) {
    type = type_;
		//setLabel("Widget Default");
		//if (!allWidgets.contains(this)) {
			allWidgets.add(this);
		//}
		setStrk(color(0, 0, 255));
		setFill(color(0, 0, 127, 127));
  }
  
  public void update() {
    //super.update();
  }
  
  public void display() {
    //super.display();
  }
  
  public void setType(String input) {
    type = input;
  }
  
  public String getType(String input) {
    return type;
  }
}
public class ArrayPanel extends Panel {
  //String type = ""; // either "list" or "tabs"... redundant to Panel class
	String category;  // the secondary taxonomy of lists... allows different loading
  ArrayList contentArray;
  
  // variables for list or tabs
  float spacer = mod/8;
  
  // variables for list
  float listItemH = mod * 5/8;
  
  // variables for tabs
  int currentTab = 0;
  float tabH = mod/2;
  float tabW = mod * 15/16;
  
  ArrayPanel(String type_, ArrayList contentArray_ /*arraylist of widgets!*/) {
    type = type_;
		contentArray = new ArrayList();
    contentArray = contentArray_;
		initialize();
  }

	ArrayPanel(String label_, String type_, ArrayList contentArray_ /*arraylist of widgets!*/) {
    setLabel(label_);
    type = type_;
		contentArray = new ArrayList();
    contentArray = contentArray_;
		initialize();
  }
  
  ArrayPanel(String category_, String label_, String type_, ArrayList contentArray_ /*arraylist of widgets!*/) {
		category = category_;
    setLabel(label_);
    type = type_;
		contentArray = new ArrayList();
    contentArray = contentArray_;
		initialize();
  }

	public void initialize() {
		//setLabel("ArrayPanel default");
		if (category != null && category.equals("selectPanel")) {
			Button button = new Button("Load Simulation", "loadSimulationButton", "loadSimulation");
			button.setW(contentW() - mod * 2);
			contentArray.add(button);
		}
	}
  
  public void update() {
		setDimensions();
		updateTitlebar();
		if (category != null && category.equals("legendPanel")) { updateLegend(); }
    
		for (int i=0; i<contentArray.size(); i++) {
      Widget widget = (Widget)contentArray.get(i);
      widget.setParent(this);
    }

    if (type.equals("list")) {
      setContentH(contentArray.size() * (listItemH + spacer) - spacer);
      for (int i=0; i<contentArray.size(); i++) {
				Widget widget = (Widget)contentArray.get(i);
				float listItemY = contentY() + (i * (listItemH + spacer));
				widget.setDimensions(contentX(), listItemY, contentW(), listItemH);
      }
    }
    if (type.equals("tabs")) {}

		if (category != null && category.equals("selectPanel")) {
			float buttonW = mod * 2.25f;
			Button button = (Button)contentArray.get(3);
			button.setCorners("rounded");
			button.setX(contentR() - buttonW);
			button.setW(buttonW);
		}
  }
  
  public void display() {
    super.display();
		displayLabel();
    if (type.equals("list")) {
      for (int i=0; i<contentArray.size(); i++) {
				Widget widget = (Widget)contentArray.get(i);
				widget.display();
      }
    }
    if (type.equals("tabs")) {}
  }
  
  public void setContent(ArrayList input) {
    contentArray = input;
  };
  
  public ArrayList getContent() {
    return contentArray;
  };

	public void setCategory(String category_) {
		category = category_;
	}

  public void tab(int rank) {
    float tabH = mod/2;
    float tabW = contentW() / contentArray.size();
    float tabInterval = mod/16;
    
    boolean active = true;
  
    float hz1 = contentY();
    float hz2 = contentY() + tabH;
    float hz3 = contentB();
    float vt1 = contentX();
    float vt2 = contentX() + (tabW * rank) + tabInterval;
    float vt3 = vt2 + tabW - tabInterval * 2;
    float vt4 = contentR();
    
    pushStyle();
    if (active) {
      fill(color(127, 0, 127, 127));
      stroke(color(255, 0, 0, 127));
    }
    else        {
      fill(color(63, 0, 63, 127));
      stroke(color(127, 0, 0, 127));
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
  }
	
	public void beginLegend() {};
	
	public void updateLegend() {
    
    int i = contentArray.size();
    while (i < species.size()) {
      Button button = new Button("Legend Button");
      PShape buttonShape = (PShape)speciesShapes.get(i);
      buttonShape = buttonShape.getChild("object");
      buttonShape.scale(fitWithin(buttonShape.width, buttonShape.height, listItemH, listItemH));
      button.setButtonIcon(buttonShape);
			button.setAction("setCurrentSpecies");
      contentArray.add(button);
      i++;
    }
    for (int j = 0; j < contentArray.size(); j++) {
      Button button = (Button)contentArray.get(j);
      String speciesName = (String)speciesNamesInOrder.get(j);
			button.setDimensions(mod, mod, mod, mod);
      button.setLabel(speciesName);
      button.update();
    }
  }
  public void displaycontentArray() {
    Button button;
    for (int i = 0; i < contentArray.size(); i++) {
      button = (Button)contentArray.get(i);
      button.display();
    }
  }
  
  public float bottomButtonB() {
    float result = 0;
    if (type.equals("legend")) {
      Button button = (Button)contentArray.get(contentArray.size()-1);
      result = button.b();
    } else if (type.equals("User Controls")) {}
    return result;
  }
  
  public void setButtonQnty() {
    if (type.equals("legend")) {}
    else if (type.equals("User Controls")) {}
  }
}
public class SinglePanel extends Panel {
  String type = "";
  Widget content;
  
  SinglePanel() {
		setLabel("SinglePanel Default");
  }

  SinglePanel(String label_, Widget content_) {
    setLabel(label_);
    content = content_;
		//setLabel("SinglePanel Default");
  }
  
  public void update() {
		setDimensions();
		updateTitlebar();
		content.setDimensions(contentX(), contentY(), contentW(), contentH());
    content.update();
  }
  
  public void display() {
		super.display();
		content.display();
		displayLabel();
	}
	
	public Widget getContent() {
		return content;
	}
	
	public void setContent(Widget input) {
		content = input;
	}
	  
  public void setContentH(float input) {
		contentH = input;
	}
	
}
public class Button extends Widget {

  // action variables
  String actionName = "";

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

  int cFillDim          = color(127);
  int cStrkDim          = color(110);
  int cTextDim          = color(166);

  int cStrkShadow       = color(90, 127);
  int cStrkHilite       = color(255, 25);

  // constructors
  Button(String type_) {
		type = type_;
    actionName = "default";
  }

  Button(String type_, String actionName_) {
		type = type_;
    actionName = actionName_;
		initialize();
  }

	Button(String label_, String type_, String actionName_) {
		setLabel(label_);
		type = type_;
    actionName = actionName_;
		initialize();
  }

	public void initialize() {
		//setX(width); // this function and the next keep the buttons for generating, for some reason, at 0,0 and rendering there for the rest of the sim.  Bug... probably has something to do with inheritance, but I don't get it.
		//setY(height);
		//if (!allButtons.contains(this)) {
			allButtons.add(this);
		//}
		
		setLabelFont(fontMyriadPro14);
		
	};

  public void update() {
    //super.update();
    if (getState().equals("over") || getState().equals("active") || getState().equals("down")) {
      setCurrentButton(this);
    }
		if (type.equals("Legend Button")){
			setLabelX(mod * 5/4);
			setLabelY(mod * 1/8);
		} else {
			setLabelX(mod * 1/8);
			setLabelY(mod * 1/8);
			//showLabel(true);
		}
    setButtonColors();
    setOverrides();
    setButtonIcon();
  }

  public void display() {
		displayBg();
		displayLabel();
  
    pushStyle();
    shapeMode(CENTER);
    if (buttonIcon != null && !type.equals("Legend Button")) {
      shape(buttonIcon, x() + w()/2, y() + w()/2, mod, mod);
    }
    if (type.equals("Legend Button"))       { 
	    pushStyle();
			shapeMode(CORNER);
	      pushMatrix();
	      translate(x() + mod*1/4, y() + mod*1/16);
	        shape(buttonIcon, 0, 0, buttonIcon.width, buttonIcon.height);
	      popMatrix();
  	}
	  popStyle();

  }

  public void setButtonColors() {
    if (getState().equals("over")) {
      cFillMain   = cFillMainOver;
      cStrkMain   = cStrkMainOver;
    } else if (getState().equals("active")) {
      cFillMain   = cFillMainActive;
      cStrkMain   = cStrkMainActive;
    } else if (getState().equals("down")) {
      cFillMain   = cFillMainDown;
      cStrkMain   = cStrkMainDown;
    } else { /* up */
      cFillMain   = cFillMainUp;
      cStrkMain   = cStrkMainUp;
    }
		setFill(cFillMain);
		setStrk(cStrkMain);
  }

  public void setButtonIcon(PShape shape)                { buttonIcon = shape; }
  public void setButtonIcon() {
    if (type.equals("add molecule"))        { buttonIcon = button_plus_up; }
    if (type.equals("kill molecule"))       { buttonIcon = button_minus_up; }
    if (type.equals("play"))                { buttonIcon = button_play_up;  }
    if (type.equals("pause"))               { buttonIcon = button_pause_up; }
    if (type.equals("reset"))               { buttonIcon = button_reset_up; }
  }

  public void setOverrides() {
    if (type.equals("add molecule")) {
      if (getState().equals("over")) {
        cFillMain   = color(74, 186, 127);
        cStrkMain   = color(86, 222, 98);
      } else if (getState().equals("active")) {
        cFillMain   = color(43, 199, 0);
        cStrkMain   = color(0, 148, 13);
      } else { /* up */
        cFillMain   = color(51, 128, 88);
        cStrkMain   = color(67, 172, 76);
      }
    }
    if (type.equals("kill molecule")) {
      if (getState().equals("over")) {
        cFillMain   = color(201, 52, 68);
        cStrkMain   = color(255, 82, 98);
      } else if (getState().equals("active")) {
        cFillMain   = color(255, 0, 22);
        cStrkMain   = color(191, 0, 17);
      } else { /* up */
        cFillMain   = color(128, 51, 59);
        cStrkMain   = color(189, 31, 45);
      }
    }
    if (type.equals("Legend Button") && getLabel().equals(currentSpeciesName)) {
      if (getState().equals("over")) {
        cFillMain   = color(75);
        cStrkMain   = color(100);
      } else if (getState().equals("active")) {
        //cFillMain   = color(43, 199, 0);
        //cStrkMain   = color(0, 148, 13);
      } else { // up 
        cFillMain   = color(50);
        cStrkMain   = color(75);
      }
    }
		setFill(cFillMain);
		setStrk(cStrkMain);
  }

/* actions ---------------------------------------------*/
  public String getAction() { return actionName; }
  public void setAction(String action) { actionName = action; }
  public void performAction() {
    
    if        (actionName.equals("default"))                  { println(this); }
    // timer buttons
    else if   (actionName.equals("toggleTimer"))              { toggleTimer(); }
    else if   (actionName.equals("reset"))                    { reset(); }
		
		// legend buttons
		else if   (actionName.equals("setCurrentSpecies"))        {
			setCurrentSpecies(getLabel());
			pickMoleculeOfSpecies(getLabel());
			}
		
		
		// menu buttons
		else if   (actionName.equals("toggleMenu")) {
			Menu parentMenu = (Menu)parent;
			parentMenu.toggleMenu();
		} 
		else if 	(actionName.equals("menuSelect")) {
			Menu parentMenu = (Menu)parent;
			parentMenu.menuSelect(getLabel());
		}
		else if	(actionName.equals("loadSimulation")) {
			if (getNextUnitNumber() != 0 && getNextLessonNumber() != 0 && getNextSimulationNumber() != 0) {
				setUnitNumber(getNextUnitNumber());
				setLessonNumber(getNextLessonNumber());
				setSimulationNumber(getNextSimulationNumber());
 				reset();
			}
		}
		    // create molecule buttons
    else if   (actionName.equals("add 5 Water"))              { createMolecule("Water", 5); }
    else if   (actionName.equals("add 5 Hydrochloric-Acid"))  { createMolecule("Hydrochloric-Acid", 5); }
		else if   (actionName.equals("add 5 Nitric-Acid"))  			{ createMolecule("Nitric-Acid", 5); }
		else if   (actionName.equals("add 5 Sodium-Hydroxide"))  	{ createMolecule("Sodium-Hydroxide", 5); }
		else if   (actionName.equals("add 5 Hydrogen-Fluoride"))  { createMolecule("Hydrogen-Fluoride", 5); }
    // panel tabs
    //else if   (actionName.equals("activateTab"))              { activateTab(); }
  }
  
  /*void activateTab() {
    PanelContent  mom = (PanelContent)parent;
    Panel         grandma = (Panel)mom.parent;
    grandma.setActiveTab(mom.rank);
   
  } */
}
public class Frame extends Widget {
  
  Frame() {
		setLabel("Frame Default");
		if (type != null && type.equals("Time")) {
			beginTime();
		}
  }
  
  Frame(String type_) {
    type = type_;
		setLabel("Frame Default");
		if (type != null && type.equals("Time")) {
			beginTime();
		}
  }

  
  public void update() {
    //super.update();
		if (type != null && type.equals("Time")) {
			updateTime();
		}
  }
  
  public void display() {
    //super.display();
		displayBg();
		displayLabel();
		if (type != null && type.equals("Time")) {
			displayTime();
		}
  }

	Button playPauseButton;
  Button resetButton;

	public void beginTime() {
    playPauseButton = new Button("play");
    playPauseButton.setAction("toggleTimer");
    
    resetButton     = new Button("reset");
    resetButton.setAction("reset");
  }
	public void updateTime() {
		playPauseButton.setDimensions(x(), y(), mod, mod);
		resetButton.setDimensions(playPauseButton.r(), y(), mod, mod);
    
    playPauseButton.update();
    resetButton.update();  
  }
	public void displayTime() {
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
}
public class Gauge extends Widget {
  
  Gauge() {
		setLabel("Gauge Default");
  }
  
  Gauge(String type_) {
    type = type_;
		setLabel("Gauge Default");
  }
  public void update() {
    //super.update();
  }
  
  public void display() {
    //super.display();
		displayBg();
		displayLabel();
  }
}
public class Menu extends Widget {
	
	Button mainButton;
	
	int menuFill = color(127, 0, 0);
	int menuStrk = color(200, 0, 0);
	int menuOverFill = color(200, 0, 0);
	int menuOverStrk = color(255, 0, 0);
	//color labelColor = color(255);

	boolean menuExtended = false;
	String menuDirection = "right";

	//String menuLabel = "Default Menu Label";
	ArrayList buttonArray;
	ArrayList contentArray;  // array of Strings, already parsed
	
	float submenuX = width;
	float submenuY = height;
	float submenuW = w();
	float submenuH = h();
  
  Menu(ArrayList contentArray_) {
		contentArray = contentArray_;
		initialize(contentArray);
  }
  
  Menu(String type_, ArrayList contentArray_) {
		contentArray = contentArray_;
    type = type_;
		initialize(contentArray);
  }

	public void initialize(ArrayList contentArray) {
		allMenus.add(this);
		mainButton 	= new Button("Menu Button", "toggleMenu");

		mainButton.setParent(this);
		buttonArray = new ArrayList();
		populate(contentArray);
	}
  
  public void update() {
    //super.update();
		mainButton.update();
		mainButton.setDimensions(x(), y(), w(), h());
		if (type == "unitSelect")	{
			if (getNextUnitNumber() == 0) {
				mainButton.setLabel("Please Choose a Unit");
			} else {
				mainButton.setLabel(truncate(getNextItem("unit")));
			}
		}
		if (type == "lessonSelect") 		{
			if (getNextLessonNumber() == 0) {
				mainButton.setLabel("Please Choose a Lesson");
			} else {
				mainButton.setLabel(truncate(getNextItem("lesson")));
			}
		}
		if (type == "simulationSelect") {
			if (getNextSimulationNumber() == 0) {
				mainButton.setLabel("Please Choose a Simulation");
			} else {
				mainButton.setLabel(truncate(getNextItem("simulation")));
			}
		}
		submenuW = w();
		submenuH = h();
		if (menuExtended == true) {
			if (menuDirection.equals("right")) {
				submenuX = x() + w();
			} else {
				submenuX = x() + w() * -1;
			}
			for (int i = 0; i<buttonArray.size(); i++) {
					submenuY = y() + (submenuH * i);
					Button menuButton = (Button)buttonArray.get(i);
					menuButton.update();
					menuButton.setDimensions(submenuX, submenuY, submenuW, submenuH);
			}
		}
  }
  
  public void display() {
    //super.display();
	
		mainButton.display();
		
		if (menuExtended == true) {
			for (int i = 0; i<buttonArray.size(); i++) {
				Button menuButton = (Button)buttonArray.get(i);
				menuButton.display();
			}
		}
  }
	
	public void toggleMenu() {
		if (menuExtended == false) {
			menuExtended = true;
			hideOtherSubmenus();
		} else {
			menuExtended = false;
			hideSubmenu();
		}
	}
	
	public void menuSelect(String input) {
		setLabel(input);
		
		int tmpUnit = getItemUnit(input);
		int tmpLesson = getItemLesson(input);
		int tmpSimulation = getItemSimulation(input);

		toggleMenu();
		mainButton.setLabel(label);		
		
		// cascade
		Menu otherMenu;
		ArrayList otherMenuContent;
		
		if (type == "unitSelect") {
			tmpLesson = 0;
			tmpSimulation = 0;
			
			otherMenu = getMenu("lessonSelect");
			otherMenuContent = filterByUnit(allLessonsAL, tmpUnit);
			otherMenu.initialize(otherMenuContent);
			
			otherMenu = getMenu("simulationSelect");
			otherMenuContent = filterByUnit(filterByLesson(allSimulationsAL, tmpLesson), tmpUnit);
			otherMenu.initialize(otherMenuContent);
			
		}
		if (type == "lessonSelect") {
			tmpSimulation = 0;
			
			otherMenu = getMenu("simulationSelect");
			otherMenuContent = filterByUnit(filterByLesson(allSimulationsAL, tmpLesson), tmpUnit);
			otherMenu.initialize(otherMenuContent);
		}
		if (type == "activitySelect") {}
		
		setNextUnitNumber(tmpUnit);
		setNextLessonNumber(tmpLesson);
		setNextSimulationNumber(tmpSimulation);
	}
	
	public void hideSubmenu() {
		for (int i = 0; i<buttonArray.size(); i++) {
			Button menuButton = (Button)buttonArray.get(i);
			menuButton.hide();
			//menuButton.showLabel(false);
		}
	}
	
	public void hideOtherSubmenus() {
		ArrayPanel parentPanel = (ArrayPanel)parent;
		ArrayList  parentArray = (ArrayList)parentPanel.contentArray;
		for (int i = 0; i<parentArray.size(); i++) {
			try{
				Menu otherMenu = (Menu)parentArray.get(i);
				if (otherMenu != this) {
					otherMenu.menuExtended = false;
					otherMenu.hideSubmenu();
				}
			} catch (Exception e) {}
		}
	}
	
	public void clear() {
		buttonArray.clear();
	};
	
	public void remove(int offset) {
		if (buttonArray.size() > offset) {
			buttonArray.remove(offset);
		}
	}
	
	public void addItem(String item) {
		Button button = new Button(item, "Menu Button", "menuSelect");
		button.setDimensions(width, height, w(), h());
		button.setParent(this);
		buttonArray.add(button);
	}
	
	public String truncate(String input) {
		String tmpItem = new String(input);
		float tmpItemW = textWidth(tmpItem);
		int ii = 0;
		while (tmpItemW > mod * 3.75f) {
			tmpItem = new String(input);
			tmpItem = tmpItem.substring(0, tmpItem.length() - ii);
			tmpItem = tmpItem.trim() + "...";
			tmpItemW = textWidth(tmpItem);
			ii++;
		}
		return tmpItem;
	}
	
	public void populate(ArrayList items) {
	 clear();
	 for (int i = 0; i<items.size(); i++) {
	    String item = (String)items.get(i);
			item = truncate(item);
    	addItem(item);
	  }
	}
}
public class Monitor extends Widget {
	// variables
	int       monitorID;

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

	float monitorPad = mod * 3/8;
	
	public float x()     {return x + monitorPad; }
  public float y()     {return y + monitorPad; }
  public float w()     {return w - monitorPad*2; }
  public float h()     {return h - monitorPad*2; }

  Monitor() {
  }
  
  Monitor(String type_) {
    type = type_;
		//setLabel("Monitor Default");
		setLabels(); // rename or combine with Region label methods
    sectionDuration = 60;  // number of seconds it takes to cross from left to right of a monitor Section
    sectionDurationTUs = sectionDuration * countsPerSecond;
		
		setStrk(cStrk_Monitor);
		setFill(cFill_Monitor);
		
		if (type == "molecules") {
			initializeExtender();
		}
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
    //super.update();
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
    if (type == "molecules") {
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

			updateExtender();
    } else if (type == "pH") {
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
    //super.display();
		displayBg();
    drawGrid();
    drawMonitorLines();
    //drawHead();
    drawStroke(); // stroke and labels should be drawn after visualization
    drawLabels();
    drawCrosshairs();

		displayLabel();
		
		if (type == "molecules" && mouseOver() == true) {
			displayExtender();
		}
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
      if (type.equals("molecules")) {
        int i = 0;
        while (yIncrement * i < yTicks) {
          line(0, h() - (yIncrement * i * yTick), w(), h() - (yIncrement * i * yTick));
          i++;
        }
      }
      if (type.equals("pH")) {
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
    
    if (type.equals("molecules")) {
      float xValue = 0;
      float yValue = h();
      int speciesQnty = countSpecies();
      
      float[] prevX = new float[speciesQnty];
      float[] prevY = new float[speciesQnty];

      // begin previous location array
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
    } else if (type.equals("pH")) {
      
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
    
    translate(x(), y());
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
      stroke(cStrk_Monitor);
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

/* monitor extender -------------------*/
  Region extender;
  
  public void initializeExtender() {
    extender = new Region();
    extender.setFill(color(0, 100));
    extender.setStrk(color(0));
  }
  
  public void updateExtender() {
  }
  
  public void displayExtender() {
    extender.setDimensions(x() - mod*5, y(), mod*5, h());
    extender.display();
    for (int i = 0; i < species.size(); i++) {
      String name = (String)speciesNamesInOrder.get(i);
			int qty = countMolecules((String)speciesNamesInOrder.get(i));
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
        text(str(qty) + "  " + name, mod*3/4, 0);
      popMatrix();
      popStyle();
    }
  }



};
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "newSim" });
  }
}
