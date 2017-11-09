ArrayList   allRegions;
ArrayList 	allAreas;
ArrayList 	allPanels;
ArrayList 	allWidgets;
ArrayList 	allButtons;
ArrayList		allMenus;
float   headerH       = 0;
float   footerH       = 0;
float   sidebarLeftW  = mod * 6;
float   sidebarRightW = mod * 6;

void startGui() {
	allRegions = new ArrayList();
	allAreas   = new ArrayList();
  allPanels  = new ArrayList();
	allWidgets = new ArrayList();
	allButtons = new ArrayList();
	allMenus	 = new ArrayList();
	
  startFonts();
  startColours();
	
  startAreas();
  startPanels();

  startButtonIcons();
  startContextMenu();
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

void startFonts() {    
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

color[] cMonitor;  // lines on monitors
color   cFill_Area;
color   cStrk_Area;
color   cFill_Canvas;
color   cFill_Panel;
color   cStrk_Panel;
color		cFill_Titlebar;
color		cStrk_Titlebar;
color   cFill_Widget;
color   cStrk_Widget;
color   cFill_TabActive;
color   cStrk_TabActive;
color   cFill_TabInactive;
color   cStrk_TabInactive;
color   cFill_Label;
color   cFill_Monitor;
color   cStrk_Monitor;
color   cStrk_Default;
color   cFill_Atom;
color   cStrk_Atom;
color   cText;

void startColours() {
  cMonitor          = new color[12];
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
  cFill_Widget   		= color(35);
  cStrk_Widget	   	= color(50);
  cFill_TabActive   = cFill_Widget;
  cStrk_TabActive   = cStrk_Widget;
  cFill_TabInactive = color(30);
  cStrk_TabInactive = color(40);
  cFill_Monitor     = color(100);
  cStrk_Monitor     = color(193);
  cStrk_Default     = color(0);
  cText             = color(255);
}

//////////////////
/* CONTEXT MENU */
//////////////////

void startContextMenu() {}

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

void startButtonIcons() {
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

void unsetCurrentButton() {
  currentButton = null;
}

void setCurrentButton(Button button) {
  currentButton = button;
}

Button getCurrentButton() {
  if (currentButton != null && (
			currentButton.getState().equals("over") ||
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
Menu getMenu(String menuName) {
	Menu menu;
	for (int i = 0; i < allMenus.size(); i++) {
		menu = (Menu)allMenus.get(i);
		if (menu.type.equals(menuName)) {
			return menu;
		} 
	}
	return null;
}

float fitWithin(float w1, float h1, float w2, float h2) {
  float n;
  if (w1 > h1) {
    n = w2/w1;
  } else {
    n = h2/h1;
  }
  return n;
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


/////////////////////
/* ROUNDED CORNERS */
/////////////////////

// Adds support for a quadratic Bézier curve by converting it 
// to a cubic Bézier curve that is supported by Processing.
// prevX and prevY are used to get the previous x,y of the current path
void quadraticBezierVertex(float prevX, float prevY, float cpx, float cpy, float x_, float y_) {
  float cp1x = prevX + 2.0/3.0*(cpx - prevX);
  float cp1y = prevY + 2.0/3.0*(cpy - prevY);
  float cp2x = cp1x + (x_ - prevX)/3.0;
  float cp2y = cp1y + (y_ - prevY)/3.0;

  // finally call cubic Bezier curve function
  bezierVertex(cp1x, cp1y, cp2x, cp2y, x_, y_);
};

void roundRect(float x_, float y_, float w_, float h_, float r_) {
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


///////////
/* AREAS */
///////////

Region  headerArea;
Region  footerArea;
Region  leftSidebarArea;
Region  rightSidebarArea;
Region  canvasArea;
//Region  floaterArea;
float   horiz1;
float   horiz2;
float   vert1;
float   vert2;
float   horiz1prev;
float   horiz2prev;
float   vert1prev;
float   vert2prev;

void startAreas() {
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

void updateAreas() {
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

void displayAreas() {
	for (int i = 0; i<allAreas.size(); i++) {
		Region area = (Region)allAreas.get(i);
		area.display();
	}
}


////////////
/* PANELS */
////////////

ArrayList leftPanels;
ArrayList rightPanels;
ArrayList headerPanels;
ArrayList footerPanels;
//ArrayList floaterPanels;
color panelBg = color(127);

void startPanels() {
  leftPanels        = new ArrayList();
  rightPanels       = new ArrayList();
  headerPanels      = new ArrayList();
  footerPanels      = new ArrayList();
  //floaterPanels     = new ArrayList();
  
	allItemsAL 				= convertStringArrayToArrayList(allItems);
	allUnitsAL 				= convertStringArrayToArrayList(filterByType(allItems, "unit"));
	allLessonsAL 			= convertStringArrayToArrayList(filterByType(allItems, "lesson"));
	allSimulationsAL 	= convertStringArrayToArrayList(filterByType(allItems, "simulation"));

	buildPanels("area_header");
	buildPanels("area_sidebarLeft");
	buildPanels("area_sidebarRight");
	buildPanels("area_footer");
	buildPanels("area_floater");
  
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

void buildPanels(String name) {
	if (name.equals("area_header")) {}
	else if (name.equals("area_sidebarLeft")) {
		buildPanel("panel_selectorSimulation_default", leftPanels); // simulation selector
		buildPanel("panel_species_" + nf(unit, 2) + nf(lesson, 2) + nf(simulation, 2), leftPanels); // species panel
		buildPanel("panel_legend_default", leftPanels); // panel legend
	}
	else if (name.equals("area_sidebarRight")) {
		buildPanel("panel_controlSimulation_default", rightPanels);
		buildPanel("panel_graphMolecule_default", rightPanels);
		buildPanel("panel_dashboard_default", rightPanels);
		//buildPanel("panel_graphPH_default", rightPanels);
	}
	else if (name.equals("area_footer")) {}
	else if (name.equals("area_floater")) {}
}

void updatePanels() {
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

void displayPanels() {
  Panel panel;
  for (int i = 0; i < allPanels.size(); i++) {
    panel = (Panel)allPanels.get(i);
    panel.display();
  }
}

void updateWidgets() {
  Widget widget;
  for (int i = 0; i < allWidgets.size(); i++) {
    widget = (Widget)allWidgets.get(i);
    widget.update();
  }
}

void displayWidgets() {
  Widget widget;
  for (int i = 0; i < allWidgets.size(); i++) {
    widget = (Widget)allWidgets.get(i);
    widget.display();
  }
}

void clearAreaPanels(ArrayList panelAL) {
	for (int i = 0; i<panelAL.size(); i++) {
		Panel panel = (Panel)panelAL.get(i);
		panel.kill();
	}
	panelAL.clear();
}

Panel getPanelByName(String input) {
	Panel output = new Panel();
	for (int i = 0; i<allPanels.size(); i++) {
		Panel tmpPanel = (Panel)allPanels.get(i);
		String category = tmpPanel.getCategory();
		if (category.equals(input)) {
			output = tmpPanel;
		}
	}
	return output;
}

void buildPanel(String name, ArrayList panelAL) {
	Panel panel = new Panel();

	// select simulation
	if (name.equals("panel_controlSimulation_default")) {
		Frame frame = new Frame("SimControl");
		panel = new LayoutPanel("Simulation Control", frame);
		panel.setContentH(mod);
	}
	
	// dashboard
	if (name.equals("panel_dashboard_default")) {
		Frame frame = new Frame("Dashboard");
		panel = new LayoutPanel("Dashboard", frame);
		panel.setContentH(mod * 2.5);
	}
 
	// molecule graph
	if (name.equals("panel_graphMolecule_default")) {
		Monitor monitor = new Monitor("molecules");
  	panel = new LayoutPanel("Molecules", monitor);
		panel.setContentH(mod * 4);
	}
	
	// pH Graph
	if (name.equals("panel_graphPH_default")) {
		Monitor monitor = new Monitor("pH");
  	panel = new LayoutPanel("pH", monitor);
		panel.setContentH(mod * 2);
	}
	
	// panel_legend_default
	if (name.equals("panel_legend_default")) {
  	ArrayList al = new ArrayList();
  	panel = new ArrayPanel("legendPanel", "Legend", "list", al);
	}
	
	
	if (name.equals("panel_selectorSimulation_default")) {
		ArrayList menus = new ArrayList();
		Menu unitMenu = new Menu("unitSelect", allUnitsAL);
			menus.add(unitMenu);
		Menu lessonMenu = new Menu("lessonSelect", allLessonsAL);
			menus.add(lessonMenu);
		Menu simulationMenu = new Menu("simulationSelect", allSimulationsAL);
			menus.add(simulationMenu);
		panel = new ArrayPanel("selectPanel", "Simulation Selector", "list", menus);
	}
	

/* species selector --------------------------------------------------------------*/
	// Solutions
	if (name.contains("panel_species")) {
		ArrayList inputs	= new ArrayList();
		if (name.contains("020101")) {
		  Button button = new Button("Control Button", "add 5 Sodium-Chloride");
				button.setLabel("Add 5 Sodium-Chloride Molecules");
			  inputs.add(button);
		}
		else if (name.contains("020201")) {
		  Button button = new Button("Control Button", "add 5 Pentane");
				button.setLabel("Add 5 Pentane Molecules");
			  inputs.add(button);
		}
		else if (name.contains("020301")) {
		  Button button = new Button("Control Button", "add 5 Sodium-Chloride");
				button.setLabel("Add 5 Sodium-Chloride Molecules");
			  inputs.add(button);
		}
		else if (name.contains("020302")) {
		  Button button = new Button("Control Button", "add 5 Glycerol");
				button.setLabel("Add 5 Glycerol Molecules");
			  inputs.add(button);
		}
		else if (name.contains("020303")) {
		  Button button = new Button("Control Button", "add 5 Silicon-Dioxide");
				button.setLabel("Add 5 Silicon-Dioxide Molecules");
			  inputs.add(button);
		}
		else if (name.contains("020304")) {
		  Button button = new Button("Control Button", "add 5 Calcium-Chloride");
				button.setLabel("Add 5 Calcium-Chloride Molecules");
			  inputs.add(button);
		}
		else if (name.contains("020305")) {
		  Button button = new Button("Control Button", "add 5 Acetic-Acid");
				button.setLabel("Add 5 Acetic-Acid Molecules");
			  inputs.add(button);
		}
		else if (name.contains("020306")) {
		  Button button = new Button("Control Button", "add 5 Pentane");
				button.setLabel("Add 5 Pentane Molecules");
			  inputs.add(button);
		}
		else if (name.contains("020307")) {
		  Button button = new Button("Control Button", "add 5 Sodium-Bicarbonate");
				button.setLabel("Add 5 Sodium-Bicarbonate Molecules");
			  inputs.add(button);
		}
		else if (name.contains("020401")) {
		  Button button_1 = new Button("Control Button", "add 5 Acetic-Acid");
				button_1.setLabel("Add 5 Acetic-Acid Molecules");
			  inputs.add(button_1);
			Button button_2 = new Button("Control Button", "add 5 Calcium-Chloride");
				button_2.setLabel("Add 5 Calcium-Chloride Molecules");
			  inputs.add(button_2);
			Button button_3 = new Button("Control Button", "add 5 Glycerol");
				button_3.setLabel("Add 5 Glycerol Molecules");
			  inputs.add(button_3);
			Button button_4 = new Button("Control Button", "add 5 Pentane");
				button_4.setLabel("Add 5 Pentane Molecules");
			  inputs.add(button_4);
			Button button_5 = new Button("Control Button", "add 5 Silicon-Dioxide");
				button_5.setLabel("Add 5 Silicon-Dioxide Molecules");
			  inputs.add(button_5);
			Button button_6 = new Button("Control Button", "add 5 Sodium-Bicarbonate");
				button_6.setLabel("Add 5 Sodium-Bicarbonate Molecules");
			  inputs.add(button_6);
			Button button_7 = new Button("Control Button", "add 5 Sodium-Chloride");
				button_7.setLabel("Add 5 Sodium-Chloride Molecules");
			  inputs.add(button_7);
			Button button_8 = new Button("Control Button", "add 5 Water");
				button_8.setLabel("Add 5 Water Molecules");
			  inputs.add(button_8);
		}
		else if (name.contains("020601")) {
		  Button button = new Button("Control Button", "add 5 Potassium-Chloride");
				button.setLabel("Add 5 Potassium-Chloride Molecules");
			  inputs.add(button);
		}
		// Acids and Bases
		else if (name.contains("_0802") && !name.contains("05") && !name.contains("06")) {
		  Button button_1 = new Button("Control Button", "add 5 Hydrochloric-Acid");
				button_1.setLabel("Add 5 Hydrochloric-Acid Molecules");
			  inputs.add(button_1);
		  Button button_2 = new Button("Control Button", "add 5 Sodium-Hydroxide");
				button_2.setLabel("Add 5 Sodium-Hydroxide Molecules");
			  inputs.add(button_2);
		}
		else if (name.contains("080205")) {
		  Button button_1 = new Button("Control Button", "add 5 Cyanide");
				button_1.setLabel("Add 5 Cyanide Molecules");
			  inputs.add(button_1);
		  Button button_2 = new Button("Control Button", "add 5 Hydrogen-Bromide");
				button_2.setLabel("Add 5 Hydrogen-Bromide Molecules");
			  inputs.add(button_2);
		}
		else if (name.contains("080206")) {
		  Button button_1 = new Button("Control Button", "add 5 Boron-Trichloride");
				button_1.setLabel("Add 5 Boron-Trichloride Molecules");
			  inputs.add(button_1);
		  Button button_2 = new Button("Control Button", "add 5 Chlorine-Ion");
				button_2.setLabel("Add 5 Chlorine-Ion Molecules");
			  inputs.add(button_2);
		}
		else if (name.contains("080301")) {
		  Button button = new Button("Control Button", "add 5 Hydrochloric-Acid");
				button.setLabel("Add 5 Hydrochloric-Acid Molecules");
			  inputs.add(button);
		}
		else if (name.contains("080302")) {
		  Button button = new Button("Control Button", "add 5 Hydrogen-Fluoride");
				button.setLabel("Add 5 Hydrogen-Fluoride Molecules");
			  inputs.add(button);
		}
		else if (name.contains("080303")) {
		  Button button = new Button("Control Button", "add 5 Sodium-Hydroxide");
				button.setLabel("Add 5 Sodium-Hydroxide Molecules");
			  inputs.add(button);
		}
		else if (name.contains("080304")) {
		  Button button = new Button("Control Button", "add 5 Ammonia");
				button.setLabel("Add 5 Ammonia Molecules");
			  inputs.add(button);
		}
		else if (name.contains("080401")) {
		  Button button = new Button("Control Button", "add 5 Acetic-Acid");
				button.setLabel("Add 5 Acetic-Acid Molecules");
			  inputs.add(button);
		}
		else if (name.contains("080402")) {
		  Button button = new Button("Control Button", "add 5 Lithium-Hydroxide");
				button.setLabel("Add 5 Lithium-Hydroxide Molecules");
			  inputs.add(button);
		}
		else if (name.contains("080403")) {
		  Button button = new Button("Control Button", "add 5 Methylamine");
				button.setLabel("Add 5 Methylamine Molecules");
			  inputs.add(button);
		}
		else if (name.contains("080404")) {
		  Button button = new Button("Control Button", "add 5 Nitric-Acid");
				button.setLabel("Add 5 Nitric-Acid Molecules");
			  inputs.add(button);
		}
		else if (name.contains("080601")) {
		  Button button_1 = new Button("Control Button", "add 5 Hydrochloric-Acid");
				button_1.setLabel("Add 5 Hydrochloric-Acid Molecules");
			  inputs.add(button_1);
		  Button button_2 = new Button("Control Button", "add 5 Sodium-Hydroxide");
				button_2.setLabel("Add 5 Sodium-Hydroxide Molecules");
			  inputs.add(button_2);
		}
		else if (name.contains("080701")) {
		  Button button_1 = new Button("Control Button", "add 5 Hydrochloric-Acid");
				button_1.setLabel("Add 5 Hydrochloric-Acid Molecules");
			  inputs.add(button_1);
		  Button button_2 = new Button("Control Button", "add 5 Ammonia");
				button_2.setLabel("Add 5 Ammonia Molecules");
			  inputs.add(button_2);
		}
		else if (name.contains("080702")) {
		  Button button_1 = new Button("Control Button", "add 5 Acetic-Acid");
				button_1.setLabel("Add 5 Acetic-Acid Molecules");
			  inputs.add(button_1);
		  Button button_2 = new Button("Control Button", "add 5 Sodium-Hydroxide");
				button_2.setLabel("Add 5 Sodium-Hydroxide Molecules");
			  inputs.add(button_2);
		}
		else if (name.contains("080703")) {
		  Button button_1 = new Button("Control Button", "add 5 Acetic-Acid");
				button_1.setLabel("Add 5 Acetic-Acid Molecules");
			  inputs.add(button_1);
		  Button button_2 = new Button("Control Button", "add 5 Ammonia");
				button_2.setLabel("Add 5 Ammonia Molecules");
			  inputs.add(button_2);
		}
		else if (name.contains("080801")) {
		  Button button_1 = new Button("Control Button", "add 5 Sodium-Carbonate");
				button_1.setLabel("Add 5 Sodium-Carbonate Molecules");
			  inputs.add(button_1);
		  Button button_2 = new Button("Control Button", "add 5 Bicarbonate");
				button_2.setLabel("Add 5 Bicarbonate Molecules");
			  inputs.add(button_2);
		  Button button_3 = new Button("Control Button", "add 5 Sodium-Ion");
				button_3.setLabel("Add 5 Sodium-Ion Molecules");
			  inputs.add(button_3);
		  Button button_4 = new Button("Control Button", "add 5 Carbonate");
				button_4.setLabel("Add 5 Carbonate Molecules");
			  inputs.add(button_4);
		}
		// Default
		else {
		  Button button = new Button("Control Button", "add 5 Water");
				button.setLabel("Add 5 Water Molecules");
			  inputs.add(button);
		}
		panel = new ArrayPanel("controlPanel", "Control Panel", "list", inputs);
	}
	panelAL.add(panel);
}