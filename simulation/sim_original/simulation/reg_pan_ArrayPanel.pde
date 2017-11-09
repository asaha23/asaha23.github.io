public class ArrayPanel extends Panel {
  //String type = ""; // either "list" or "tabs"... redundant to Panel class
	String category;  // the secondary taxonomy of lists... allows different loading
  ArrayList contentArray;
  
  // variables for list or tabs
  float spacer = mod/8;
  
  // variables for list
  float listItemH = mod * 5/8;
  
  // variables for tabs
  int currentTab = 0;
  float tabH = mod/2;
  float tabW = mod * 15/16;
  
  ArrayPanel(String type_, ArrayList contentArray_ /*arraylist of widgets!*/) {
    type = type_;
		contentArray = new ArrayList();
    contentArray = contentArray_;
		initialize();
  }

	ArrayPanel(String label_, String type_, ArrayList contentArray_ /*arraylist of widgets!*/) {
    setLabel(label_);
    type = type_;
		contentArray = new ArrayList();
    contentArray = contentArray_;
		initialize();
  }
  
  ArrayPanel(String category_, String label_, String type_, ArrayList contentArray_ /*arraylist of widgets!*/) {
		category = category_;
    setLabel(label_);
    type = type_;
		contentArray = new ArrayList();
    contentArray = contentArray_;
		initialize();
  }

	void initialize() {
		//setLabel("ArrayPanel default");
		if (category != null && category.equals("selectPanel")) {
			Button button = new Button("Load Simulation", "loadSimulationButton", "loadSimulation");
			button.setW(contentW() - mod * 2);
			contentArray.add(button);
		}
	}
  
  void update() {
		setDimensions();
		updateTitlebar();
		if (category != null && category.equals("legendPanel")) { updateLegend(); }
    
		for (int i=0; i<contentArray.size(); i++) {
      Widget widget = (Widget)contentArray.get(i);
      widget.setParent(this);
    }

    if (type.equals("list")) {
      setContentH(contentArray.size() * (listItemH + spacer) - spacer);
      for (int i=0; i<contentArray.size(); i++) {
				Widget widget = (Widget)contentArray.get(i);
				float listItemY = contentY() + (i * (listItemH + spacer));
				widget.setDimensions(contentX(), listItemY, contentW(), listItemH);
      }
    }
    if (type.equals("tabs")) {}

		if (category != null && category.equals("selectPanel")) {
			float buttonW = mod * 2.25;
			Button button = (Button)contentArray.get(3);
			button.setCorners("rounded");
			button.setX(contentR() - buttonW);
			button.setW(buttonW);
		}
  }
  
  void display() {
    super.display();
		displayLabel();
    if (type.equals("list")) {
      for (int i=0; i<contentArray.size(); i++) {
				Widget widget = (Widget)contentArray.get(i);
				widget.display();
      }
    }
    if (type.equals("tabs")) {}
  }
  
  void setContent(ArrayList input) {
    contentArray = input;
  };
  
  ArrayList getContent() {
    return contentArray;
  };

	void setCategory(String category_) {
		category = category_;
	}

  void tab(int rank) {
    float tabH = mod/2;
    float tabW = contentW() / contentArray.size();
    float tabInterval = mod/16;
    
    boolean active = true;
  
    float hz1 = contentY();
    float hz2 = contentY() + tabH;
    float hz3 = contentB();
    float vt1 = contentX();
    float vt2 = contentX() + (tabW * rank) + tabInterval;
    float vt3 = vt2 + tabW - tabInterval * 2;
    float vt4 = contentR();
    
    pushStyle();
    if (active) {
      fill(color(127, 0, 127, 127));
      stroke(color(255, 0, 0, 127));
    }
    else        {
      fill(color(63, 0, 63, 127));
      stroke(color(127, 0, 0, 127));
    }
    
    beginShape();
      vertex(vt1, hz2); // 1
      vertex(vt2, hz2); // 2
      vertex(vt2, hz1); // 3
      vertex(vt3, hz1); // 4
      vertex(vt3, hz2); // 5
      vertex(vt4, hz2); // 6
      vertex(vt4, hz3); // 7
      vertex(vt1, hz3); // 8
    endShape();
    popStyle();
  }
	
	void beginLegend() {};
	
	void updateLegend() {
    
    int i = contentArray.size();
    while (i < species.size()) {
      Button button = new Button("Legend Button");
      PShape buttonShape = (PShape)speciesShapes.get(i);
      buttonShape = buttonShape.getChild("object");
      buttonShape.scale(fitWithin(buttonShape.width, buttonShape.height, listItemH, listItemH));
      button.setButtonIcon(buttonShape);
			button.setAction("setCurrentSpecies");
      contentArray.add(button);
      i++;
    }
    for (int j = 0; j < contentArray.size(); j++) {
      Button button = (Button)contentArray.get(j);
      String speciesName = (String)speciesNamesInOrder.get(j);
			button.setDimensions(mod, mod, mod, mod);
      button.setLabel(speciesName);
      button.update();
    }
  }
  void displaycontentArray() {
    Button button;
    for (int i = 0; i < contentArray.size(); i++) {
      button = (Button)contentArray.get(i);
      button.display();
    }
  }
  
  float bottomButtonB() {
    float result = 0;
    if (type.equals("legend")) {
      Button button = (Button)contentArray.get(contentArray.size()-1);
      result = button.b();
    } else if (type.equals("User Controls")) {}
    return result;
  }
  
  void setButtonQnty() {
    if (type.equals("legend")) {}
    else if (type.equals("User Controls")) {}
  }
}