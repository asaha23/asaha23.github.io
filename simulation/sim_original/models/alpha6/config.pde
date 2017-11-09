void initPanels(int unit, int lesson, int sim) {
  // acids and bases
  if (unit == 4) {
    if (lesson == 0) {
      if (sim == 0) {
  
      }
    }
  }
  
  else {
    unit = 0;
    lesson = 0;
    sim = 0;
    configDefault();
  }
}

void configDefault() {
  leftPanels.add(userControlPanel);
  leftPanels.add(legendPanel);
  leftPanels.add(timePanel);
  rightPanels.add(molMonitorPanel);
  rightPanels.add(pHMonitorPanel);
  //rightPanels.add(testPanel);
  
  setCanvasWallpaper("data/wallpaper/water-065.png");
}