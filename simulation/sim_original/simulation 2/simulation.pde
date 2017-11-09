// Connected Chemistry Simulations
// part of the Connected Chemistry Curriculum

// Project Leader: Mike Stieff, PhD, University of Illinois at Chicago
// Modeled in Processing by: Allan Berry

// This software is Copyright © 2010, 2011 Allan Berry, and is released under
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


import  fisica.*;
import  geomerative.*;
import  prohtml.*;

boolean debug = false;

// general variables
float   mod   = 48.0;           // setup a standard module size for graphics
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

float   minMoleculeScale = .25;
float   defMoleculeScale = .75;
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

void setup(){
  size(1200, 600);
  smooth();
  noFill();
  noStroke();
  frameRate(globalFrameRate);
  
	// setup Fisica
  Fisica.init(this);
  //Fisica.setScale(25);
  
	// RG are classes from Geomerative: the SVG parser
  RG.init(this);
  RG.setPolygonizer(RG.ADAPTATIVE);
  
  setupData();
  setupTime();
  initGui();
  setupSimulation();
  setupSpecies();
  populateCanvas();

  startTimer();
	draw();
	pauseTimer();
	
}

void draw(){
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

void reset() {
  pauseTimer();
  setup();
}

void contactStarted(FContact contact) {
  // Draw in green an ellipse where the contact took place
  //fill(0, 170, 0);
  //ellipse(contact.getX(), contact.getY(), 20, 20);
	if (getMolecules().contains(contact.getBody1()) && getMolecules().contains(contact.getBody2())) {
    react((Molecule)contact.getBody1(), (Molecule)contact.getBody2(), contact.getX(), contact.getY());
	}
}
