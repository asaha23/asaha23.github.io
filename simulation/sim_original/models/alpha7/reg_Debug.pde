public class Debug extends Region {
  String type;
  
  ArrayList addMoleculeButtonsAL;
  ArrayList killMoleculeButtonsAL;
  ArrayList moleculeButtonLabels;
  
  int speciesButtonQnty;
  
  float mGroupX;
  float mGroupY;
  float mButtonMargin;
  float mButtonW;
  float mButtonH;
  
  // constructor
  Debug(float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    speciesButtonQnty = 0;
    setButtons();
  }
  
  void setButtons() {
    mGroupX             = x();
    mGroupY             = y();
    mButtonMargin       = mod * 1/8;
    mButtonW            = mod * 3/8;
    mButtonH            = mod * 3/8;
    
    addMoleculeButtonsAL = new ArrayList();
    killMoleculeButtonsAL = new ArrayList();
    moleculeButtonLabels = new ArrayList();
    
    for (int i = 0; i < countSpecies(); i++) {
      addMoleculeButtonsAL.add(i, new Button(mGroupX, mGroupY + (mod * i/2), mButtonW, mButtonH));
      killMoleculeButtonsAL.add(i, new Button(mGroupX + mButtonW + mButtonMargin, mGroupY + (mod * i/2), mButtonW, mButtonH));
      
      Button addButton =  (Button)addMoleculeButtonsAL.get(i);
      Button killButton = (Button)killMoleculeButtonsAL.get(i);
      addButton.buttonType = "add molecule";
      killButton.buttonType = "kill molecule";
    }
  }
  
  void update() {
    super.update();
    if (speciesButtonQnty != countSpecies()) {
      setButtons();
      speciesButtonQnty = countSpecies();
    }
    for (int i = 0; i < countSpecies(); i++) {
      Button addButton =  (Button)addMoleculeButtonsAL.get(i);
      Button killButton = (Button)killMoleculeButtonsAL.get(i);
      addButton.update();
      killButton.update();
            String speciesName = (String)speciesNamesInOrder.get(i);
      moleculeButtonLabels.add(i, speciesName + " " + countMolecules(speciesName));
    }
  }
  
  void display() {
    super.display();
    for (int i = 0; i < addMoleculeButtonsAL.size(); i++) {
      Button addButton =  (Button)addMoleculeButtonsAL.get(i);
      Button killButton = (Button)killMoleculeButtonsAL.get(i);
      addButton.display();
      killButton.display();
      
      pushStyle();
        fill(255);
        textFont(fontMyriadPro10);
        text(moleculeButtonLabels.get(i).toString(), x() + mod, mGroupY + (mod * i/2) + mButtonH * 3/4);
      popStyle();
      
    }
  }
}