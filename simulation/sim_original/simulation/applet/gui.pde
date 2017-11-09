ArrayList		allRegions;
ArrayList 	allAreas;
ArrayList 	allPanels;
ArrayList 	allWidgets;
ArrayList 	allButtons;
ArrayList		allMenus;

void initGui() {
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

void initFonts() {    
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

void initColours() {
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

void initContextMenu() {}

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

void initButtonIcons() {
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
