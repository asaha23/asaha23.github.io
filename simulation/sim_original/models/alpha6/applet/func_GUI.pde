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
        
color[] cMonitor;  // lines on monitors
color   cFill_Bg;
color   cFill_Canvas;
color   cFill_Panel;
color   cStrk_Panel;
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

void setupGUI() {
  createFonts();
  createColours();
  createButtonIcons();
  createContextMenu();
  
  setupAreas();
  setupPanels();
}

void updateGUI() {
  updateAreas();
  updatePanels();
}

void displayGUI() {
  displayAreas();
  displayPanels();
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

void setupAreas() {
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
void displayAreas() {
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

void setupPanels() {
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

void updatePanels() {
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

void displayPanels() {
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

void createFonts() {    
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
void createColours() {
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
void createButtonIcons() {
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
void createContextMenu() {}

/* utility ----------------------------------------- */

float fitWithin(float w1, float h1, float w2, float h2) {
  float n;
  if (w1 > h1) {
    n = w2/w1;
  } else {
    n = h2/h1;
  }
  return n;
}


/* rounded corners ----------------------------------------- */

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









