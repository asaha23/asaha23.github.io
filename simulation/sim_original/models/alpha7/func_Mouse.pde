// Mouse
void mousePressed() {
  // if mouse is over canvas, and no molecules are under the mouse
  if (canvas.getBody(mouseX, mouseY) == null && canvasArea.mouseOver() == true && overHUDButton() != true) {
    unsetCurrentSpecies();
  }
  if (canvas.getBody(mouseX, mouseY) != null && canvasArea.mouseOver() == true && overHUDButton() != true) {
    //createMolecule("Water", mouseX, mouseY);
    Molecule m = (Molecule)canvas.getBody(mouseX, mouseY);
    setCurrentSpecies(m.speciesName);
    setCurrentMolecule(m);
  }
}

// mouse
void mouseReleased() {
  // eventually, I may convert all buttons to use this routine:
  if (getCurrentButton() != null) {
    getCurrentButton().performAction();
  }
  
  
  // legacy buttons -------------------------------------------//
  
  // user control buttons
  for (int i = 0; i < userControlPanel.userControlButtons.size(); i++) {
    Button currentButton = (Button)userControlPanel.userControlButtons.get(i);
    if (currentButton.getState().equals("over")) {
      //currentButton.performAction();
    }
  }
  
  // debug molecule buttons
  try {
    for (int i = 0; i < countSpecies(); i++) {
        Button addButton =  (Button)debugControls.addMoleculeButtonsAL.get(i);
        Button killButton = (Button)debugControls.killMoleculeButtonsAL.get(i);
      if (addButton.getState().equals("over")) {
        // this may need to be altered to account for when the random settings overlap existing molecules
        createMolecule((String)speciesNamesInOrder.get(i));
      }
      if (killButton.getState().equals("over")) {
        killMoleculeByType((String)speciesNamesInOrder.get(i));
      }
    }
  } catch (Exception e) {}
  
  for (int i = 0; i < legendPanel.legendButtons.size(); i++) {
    Button button = (Button)legendPanel.legendButtons.get(i);
    if (button.getState().equals("over")) {
      setCurrentSpecies(button.buttonName);
    }
  }
}

boolean overHUDButton() {
  boolean over = false;
  try {
    for (int i = 0; i < countSpecies(); i++) {
      Button addButton =  (Button)debugControls.addMoleculeButtonsAL.get(i);
      Button killButton = (Button)debugControls.killMoleculeButtonsAL.get(i);
      if (addButton.getState().equals("over") || addButton.getState().equals("active")) {
        // this may need to be altered to account for when the random settings overlap existing molecules
        over = true;
      } else if (killButton.getState().equals("over") || killButton.getState().equals("active")) {
        over = true;
      }
    }
  } catch (Exception e) {}
  return over;
}