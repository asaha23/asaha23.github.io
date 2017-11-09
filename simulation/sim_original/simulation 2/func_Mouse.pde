// Mouse
void mousePressed() {
  // if mouse is over canvas, and no molecules are under the mouse
  if (canvas.getBody(mouseX, mouseY) == null && canvasArea.mouseOver() == true /*&& overHUDButton() != true*/) {
    unsetCurrentSpecies();
  }
  if (canvas.getBody(mouseX, mouseY) != null && canvasArea.mouseOver() == true /*&& overHUDButton() != true*/) {
    //createMolecule("Water", mouseX, mouseY);
    Molecule m = (Molecule)canvas.getBody(mouseX, mouseY);
    setCurrentSpecies(m.speciesName);
    setCurrentMolecule(m);
  }
}

// mouse
void mouseReleased() {
  if (getCurrentButton() != null) {
		println(getCurrentButton().actionName);
    getCurrentButton().performAction();
  }
}