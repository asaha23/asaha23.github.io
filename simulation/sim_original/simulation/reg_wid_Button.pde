public class Button extends Widget {

  // action variables
  String actionName = "";

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

  color cFillDim          = color(127);
  color cStrkDim          = color(110);
  color cTextDim          = color(166);

  color cStrkShadow       = color(90, 127);
  color cStrkHilite       = color(255, 25);

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

	void initialize() {
		//setX(width); // this function and the next keep the buttons for generating, for some reason, at 0,0 and rendering there for the rest of the sim.  Bug... probably has something to do with inheritance, but I don't get it.
		//setY(height);
		//if (!allButtons.contains(this)) {
			allButtons.add(this);
		//}
		
		setLabelFont(fontMyriadPro14);
		
	};

  void update() {
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

  void display() {
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

  void setButtonColors() {
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

  void setButtonIcon(PShape shape)                { buttonIcon = shape; }
  void setButtonIcon() {
    if (type.equals("add molecule"))        { buttonIcon = button_plus_up; }
    if (type.equals("kill molecule"))       { buttonIcon = button_minus_up; }
    if (type.equals("play"))                { buttonIcon = button_play_up;  }
    if (type.equals("pause"))               { buttonIcon = button_pause_up; }
    if (type.equals("reset"))               { buttonIcon = button_reset_up; }
  }

  void setOverrides() {
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
  String getAction() { return actionName; }
  void setAction(String action) { actionName = action; }
  void performAction() {
    
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