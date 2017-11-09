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

  color cFillMainUp       = color(127, 127, 127);
  color cFillMainOver     = color(157, 157, 157);
  color cFillMainActive   = color(234, 91, 12);
  color cFillMainDown     = color(176, 69, 23);
  color cFillMain         = cFillMainUp;

  color cStrkMainUp       = color(100, 100, 100);
  color cStrkMainOver     = color(178, 178, 178);
  color cStrkMainActive   = color(204, 69, 23);
  color cStrkMainDown     = color(154, 52, 21);
  color cStrkMain         = cStrkMainUp;

  color cFillHandleUp     = color(51, 94, 127);
  color cFillHandleOver   = color(51, 94, 190);
  color cFillHandleActive = color(81, 186, 230);
  color cFillHandleDown   = color(38, 169, 224);
  color cFillHandle       = cFillHandleUp;

  color cStrkHandleUp     = color(43, 56, 143);
  color cStrkHandleOver   = color(43, 56, 189);
  color cStrkHandleActive = color(73, 145, 201);
  color cStrkHandleDown   = color(27, 117, 187);
  color cStrkHandle       = cStrkHandleUp;

  color cFillDim          = color(127);
  color cStrkDim          = color(110);
  color cTextDim          = color(166);

  color cStrkShadow       = color(90, 127);
  color cStrkHilite       = color(255, 25);

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

  void init() {
    super.init();
    actionName = "default";
    buttonName = new String();
    if (buttonType.equals("Legend Button")) {}
    if (buttonType.equals("User Control Button")) {}
    setFill(true);
    setStrk(true);
  }

  void update() {
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

  void display() {
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

  void setButtonColors() {
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

  void setOverrides() {
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

  void setRoundCorners() {
    roundCorners = true;
  }

  void setLabel(String s) {
    labelText = s;
  }

  void setIcon(PShape shape) {
    buttonIcon = shape;
  }

  void setName(String s) {
    buttonName = s;
  }

/* actions ---------------------------------------------*/
  String getAction() {
    return actionName;
  }

  void setAction(String action) {
    actionName = action;
  }

  void performAction() {
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
  
  void activateTab() {
    PanelContent  mom = (PanelContent)parent;
    Panel         grandma = (Panel)mom.parent;
    grandma.setActiveTab(mom.rank);
  }

/* user control buttons ---------------------------------*/

  void setupUserControlButtons() {
  }
  void updateUserControlButtons() {
    labelX = x() + mod * 3/8;
    labelY = y() + mod * 3/8;
  }
  void displayUserControlButtons() {
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
  void setupLegendButtons() {
  }
  void updateLegendButtons() {
    labelX = x() + mod * 1;
    labelY = y() + mod * 1/2;
  }
  void displayLegendButtons() {
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
  void drawLabels() {
    pushStyle();
      fill(cText);
      if (labelText != null) {
        fill(cText);
        text(labelText, labelX, labelY);
      }
    popStyle();
  }
}