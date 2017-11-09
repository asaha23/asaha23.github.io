public class Frame extends Widget {
  
  Frame() {
		setLabel("Frame Default");
		if (type != null && type.equals("Time")) {
			beginTime();
		}
  }
  
  Frame(String type_) {
    type = type_;
		setLabel("Frame Default");
		if (type != null && type.equals("Time")) {
			beginTime();
		}
  }

  
  void update() {
    //super.update();
		if (type != null && type.equals("Time")) {
			updateTime();
		}
  }
  
  void display() {
    //super.display();
		displayBg();
		displayLabel();
		if (type != null && type.equals("Time")) {
			displayTime();
		}
  }

	Button playPauseButton;
  Button resetButton;

	void beginTime() {
    playPauseButton = new Button("play");
    playPauseButton.setAction("toggleTimer");
    
    resetButton     = new Button("reset");
    resetButton.setAction("reset");
  }
	void updateTime() {
		playPauseButton.setDimensions(x(), y(), mod, mod);
		resetButton.setDimensions(playPauseButton.r(), y(), mod, mod);
    
    playPauseButton.update();
    resetButton.update();  
  }
	void displayTime() {
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
}