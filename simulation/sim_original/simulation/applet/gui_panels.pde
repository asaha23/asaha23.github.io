ArrayList leftPanels;
ArrayList rightPanels;
ArrayList headerPanels;
ArrayList footerPanels;
//ArrayList floaterPanels;

void initPanels() {
  leftPanels        = new ArrayList();
  rightPanels       = new ArrayList();
  headerPanels      = new ArrayList();
  footerPanels      = new ArrayList();
  //floaterPanels     = new ArrayList();
  
	allItemsAL 				= convertStringArrayToArrayList(allItems);
	allUnitsAL 				= convertStringArrayToArrayList(filterByType(allItems, "unit"));
	allLessonsAL 			= convertStringArrayToArrayList(filterByType(allItems, "lesson"));
	allSimulationsAL 	= convertStringArrayToArrayList(filterByType(allItems, "simulation"));

  // this is where all the panels and widgets get loaded
  loadPanels(unit, lesson, simulation);
  
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
