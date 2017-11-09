public class Menu extends Widget {
	
	Button mainButton;
	
	color menuFill = color(127, 0, 0);
	color menuStrk = color(200, 0, 0);
	color menuOverFill = color(200, 0, 0);
	color menuOverStrk = color(255, 0, 0);
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

	void initialize(ArrayList contentArray) {
		allMenus.add(this);
		mainButton 	= new Button("Menu Button", "toggleMenu");

		mainButton.setParent(this);
		buttonArray = new ArrayList();
		populate(contentArray);
	}
  
  void update() {
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
  
  void display() {
    //super.display();
	
		mainButton.display();
		
		if (menuExtended == true) {
			for (int i = 0; i<buttonArray.size(); i++) {
				Button menuButton = (Button)buttonArray.get(i);
				menuButton.display();
			}
		}
  }
	
	void toggleMenu() {
		if (menuExtended == false) {
			menuExtended = true;
			hideOtherSubmenus();
		} else {
			menuExtended = false;
			hideSubmenu();
		}
	}
	
	void menuSelect(String input) {
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
	
	void hideSubmenu() {
		for (int i = 0; i<buttonArray.size(); i++) {
			Button menuButton = (Button)buttonArray.get(i);
			menuButton.hide();
			//menuButton.showLabel(false);
		}
	}
	
	void hideOtherSubmenus() {
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
	
	void clear() {
		buttonArray.clear();
	};
	
	void remove(int offset) {
		if (buttonArray.size() > offset) {
			buttonArray.remove(offset);
		}
	}
	
	void addItem(String item) {
		Button button = new Button(item, "Menu Button", "menuSelect");
		button.setDimensions(width, height, w(), h());
		button.setParent(this);
		buttonArray.add(button);
	}
	
	String truncate(String input) {
		String tmpItem = new String(input);
		float tmpItemW = textWidth(tmpItem);
		int ii = 0;
		while (tmpItemW > mod * 3.75) {
			tmpItem = new String(input);
			tmpItem = tmpItem.substring(0, tmpItem.length() - ii);
			tmpItem = tmpItem.trim() + "...";
			tmpItemW = textWidth(tmpItem);
			ii++;
		}
		return tmpItem;
	}
	
	void populate(ArrayList items) {
	 clear();
	 for (int i = 0; i<items.size(); i++) {
	    String item = (String)items.get(i);
			item = truncate(item);
    	addItem(item);
	  }
	}
}
