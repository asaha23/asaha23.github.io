ArrayPanel controlPanel;
ArrayPanel selectPanel;
ArrayPanel legendPanel;
SinglePanel molMonitorPanel;
SinglePanel phMonitorPanel;
SinglePanel timePanel;

// these functions will be overridden by units, lessons and simulations.  Interface for customization.
void loadPanels(int unit, int lesson, int simulation) {
  startPanels();
  loadCustomPanels(unit, lesson, simulation);
}

void loadCustomPanels(int unit, int lesson, int simulation) {
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

void startPanels() {
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
