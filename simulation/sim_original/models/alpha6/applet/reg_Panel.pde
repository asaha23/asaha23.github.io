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
  void init() {
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
  void update() {
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
  void display() {
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

  void initTitleBar() {
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
  void updateTitleBar() {
    panelTitleBar.update();
    panelTitleBar.setDimensions(x(), y(), w(), mod/2);
    
    collapseButton.update();
  }
  void displayTitleBar() {
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

  void toggleCollapsed() {
    if (collapsed == false) {
      collapsed = true;
    } else {
      collapsed = false;
    }
  }


/* dimensions -------------------------------------- */
  float x() {
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
  float y() {
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

  float w() {
    float result = 0;
    if      (leftPanels.contains(this))     { result = leftSidebarArea.w(); }
    else if (rightPanels.contains(this))    { result = rightSidebarArea.w(); }
    else if (floaterPanels.contains(this))  { result = floaterArea.w(); }
    else                                    { result = mod * 6; }
    
    // overrides
    w = result;
    return result;
  }

  float h() {
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
  
  void initTest() {
    panelContents = new ArrayList();
    panelContents.add(new PanelContent(panelContentFormat, this));
    panelContents.add(new PanelContent(panelContentFormat, this));
    panelContents.add(new PanelContent(panelContentFormat, this));
    activetab = 0;
  }
  void updateTest() {
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
  void displayTest() {
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
  
  void setActiveTab(int i) {
    activetab = i;
  }

/* control panel -------------------- */

  ArrayList userControlButtons;

  void initUserControls() {
    userControlButtons = new ArrayList();
  }
  
  void updateUserControls() {
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
  
  void displayUserControls() {
    for (Iterator<Button> iter = userControlButtons.iterator(); iter.hasNext();) {
        iter.next().display();
    }
  }

/* monitor panels -------------------------- */
  Monitor monitor;

  void initMonitors() {    
    monitor  = new Monitor();
    if (type.equals("molecule")) {
      monitor.setType("molecule monitor");
    } else if (type.equals("ph")) {
      monitor.setType("ph monitor");
    }
    monitor.setFill(cFill_Monitor);
  }
  
  void updateMonitors() {
    monitor.setDimensions(x() + mod * 1/2, y() + panelTitleBar.h(), w() - mod * 9/8, h() - mod);
    monitor.update();
  }
  
  void displayMonitors() {
    monitor.display();
  }
  
/* monitor panel extender -------------------*/
  Region extender;
  
  void initExtender() {
    extender = new Region();
    extender.setFill(color(0, 190));
  }
  
  void updateExtender() {
  }
  
  void displayExtender() {
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

  void initTimeButtons() {
    playPauseButton = new Button("play");
    playPauseButton.setAction("toggleTimer");
    
    resetButton     = new Button("reset");
    resetButton.setAction("reset");
  }
  void updateTimeButtons() {
    playPauseButton.setDimensions(x() + panelMargin, y() + panelTitleBar.h() + panelMargin/3, mod, mod);
    resetButton.setDimensions(playPauseButton.r() + defaultInterval, y() + panelTitleBar.h() + panelMargin/3, mod, mod);
    
    playPauseButton.update();
    resetButton.update();  
  }
  void displayTimeButtons() {
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

  void initLegendButtons() {
    legendButtons = new ArrayList();
  }
  
  void updateLegendButtons() {
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
  void displayLegendButtons() {
    Button button;
    for (int i = 0; i < legendButtons.size(); i++) {
      button = (Button)legendButtons.get(i);
      button.display();
    }
  }
  
  float bottomButtonB() {
    float result = 0;
    if (type.equals("legend")) {
      Button button = (Button)legendButtons.get(legendButtons.size()-1);
      result = button.b();
    } else if (type.equals("User Controls")) {}
    return result;
  }
  
  void setButtonQnty() {
    if (type.equals("legend")) {}
    else if (type.equals("User Controls")) {}
  }
}

/* general ----------------------------- */

