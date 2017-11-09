public class Frame extends Widget {
  
  Frame(String type_) {
    type = type_;
		setLabel("Frame Default");
		if (type != null && type.equals("SimControl")) { startSimControl(); }
  }

  void update() {
    //super.update();
		if (type != null && type.equals("SimControl")) { updateSimControl(); }
		if (type != null && type.equals("Dashboard"))  { updateDashboard(); }
  }
  
  void display() {
    //super.display();
		displayBg();
		//displayLabel();
		if (type != null && type.equals("SimControl")) {
			displaySimControl();
		}
		if (type != null && type.equals("Dashboard")) {
			displayDashboard();
		}
  }
	// dashboard
	void startDashboard() {}
	void updateDashboard() {}
	void displayDashboard() {
      // timer
      pushMatrix();
      pushStyle();
        translate(x() + mod * 1/4, y() + mod * 1/2);
        fill(255);
        textFont(fontMyriadPro14);
				float yOffset;
        yOffset = mod * 0; 	 textAlign(RIGHT); text("Time Elapsed: ", mod * 2.25, yOffset); 		textAlign(LEFT); text(currentTimeFormatted(), mod * 2.5, yOffset);
        yOffset = mod * 1/3; textAlign(RIGHT); text("Solvent (g): ", mod * 2.25, yOffset);			textAlign(LEFT); text(nf(currentSolventWeight(), 0, 1), mod * 2.5, yOffset);
        yOffset = mod * 2/3; textAlign(RIGHT); text("Solute (g): ", mod * 2.25, yOffset);				textAlign(LEFT); text(nf(currentSoluteWeight(), 0, 1), mod * 2.5, yOffset);
        yOffset = mod * 3/3; textAlign(RIGHT); text("Volume (ml): ", mod * 2.25, yOffset);			textAlign(LEFT); text(nf(currentTotalVolume(), 0, 1), mod * 2.5, yOffset);
        yOffset = mod * 4/3; textAlign(RIGHT); text("Temperature (C): ", mod * 2.25, yOffset);	textAlign(LEFT); text(nf(currentTotalTemperature(), 0, 1), mod * 2.5, yOffset);
        yOffset = mod * 5/3; textAlign(RIGHT); text("Pressure (atm): ", mod * 2.25, yOffset);		textAlign(LEFT); text(nf(currentTotalPressure(), 0, 1), mod * 2.5, yOffset);
      popStyle();
      popMatrix();
  }


	// Simulation Controls
	Button playPauseButton;
  Button resetButton;

	void startSimControl() {
    playPauseButton = new Button("play");
    playPauseButton.setAction("toggleTimer");
    
    resetButton     = new Button("reset");
    resetButton.setAction("reset");
  }
	void updateSimControl() {
		playPauseButton.setDimensions(x(), y(), mod, mod);
		resetButton.setDimensions(playPauseButton.r() + mod/4, y(), mod, mod);
    
    playPauseButton.update();
    resetButton.update();  
  }
	void displaySimControl() {
      playPauseButton.display();
      resetButton.display();
  }
}