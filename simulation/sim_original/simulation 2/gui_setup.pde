// legacy panels
/*ArrayPanel controlPanel;
ArrayPanel selectPanel;
ArrayPanel legendPanel;
SinglePanel molMonitorPanel;
SinglePanel phMonitorPanel;
SinglePanel timePanel;*/

// these functions will be overridden by units, lessons and simulations.  Interface for customization.
void loadPanels(int unit, int lesson, int simulation) {
  //startPanels();
  //loadCustomPanels(unit, lesson, simulation);
}

void loadGui() {
	loadArea("area_header");
	loadArea("area_sidebarLeft");
	loadArea("area_sidebarRight");
	loadArea("area_footer");
	loadArea("area_floater");
}

void loadArea(String name) {
	if (name.equals("area_header")) {}
	else if (name.equals("area_sidebarLeft")) {
		
		// simulation selector
		buildPanel("panel_selectorSimulation_default", leftPanels);
		
		// species panel
		buildPanel("panel_species_" + nf(unit, 2) + nf(lesson, 2) + nf(simulation, 2), leftPanels);
		
		// panel legend
		buildPanel("panel_legend_default", leftPanels);
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

void overrideAreas() {
	clearAreaPanels(leftPanels);
	
	buildPanel("panel_selectorSimulation_default", leftPanels);
	
	// Control panel

	buildPanel("panel_legend_default", leftPanels);
}

void clearAreaPanels(ArrayList panelAL) {
	for (int i = 0; i<panelAL.size(); i++) {
		Panel panel = (Panel)panelAL.get(i);
		panel.kill();
	}
	panelAL.clear();
};


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


void startPanels() {
  // control widgets
  
  // dashboard widgets
  /*ArrayList dashboard         = new ArrayList();
  Gauge timer                 = new Gauge("time");
	  dashboard.add(timer);
  Gauge molCount              = new Gauge("molecule count");
  	dashboard.add(molCount);
  ArrayPanel dashPanel         = new ArrayPanel("Dashboard", "list", dashboard); */
	

  

  
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