// the sim apparently crashes above this many molecules.  
int moleculeQntyLimit = 200;

HashMap   species;
ArrayList speciesRoll;
ArrayList pHRoll;

ArrayList speciesNamesInOrder;
ArrayList speciesShapes;
String    currentSpeciesName;
Molecule  currentMolecule;

//int prevMoleculeCount;
//int moleculeCount;

ArrayList reactedMoleculeIDs;
int totalMoleculesCreated;

ArrayList molecules;
boolean mFlag; // keeps getMolecules() from running every frame; true when a molecule has been created or deleted

//--------------------------------------------------------//

void setupSpecies() {
  species = new HashMap();
  speciesRoll = new ArrayList();
  pHRoll = new ArrayList();
  reactedMoleculeIDs = new ArrayList();
  molecules = new ArrayList();
  
  speciesNamesInOrder = new ArrayList();
  speciesShapes = new ArrayList();
  
  getInitialSpecies(getUnitNumber(), getLessonNumber(), getSimulationNumber());
  currentSpeciesName = new String();
}

void getInitialSpecies(int unit, int lesson, int sim) {
  int row = 0;
  while (unit != initUnit[row] || lesson != initLesson[row] || sim != initSim[row]) {
    row++;
    if (row == initTableRowCount) {
      row = 0;
      break;
    }
  }
  String[] tmp = initSpecies[row].split(", ");
  for (int i = 0; i < tmp.length; i++) {
    String[] a = tmp[i].split(" ");
    String s = a[0];
    int n = Integer.parseInt(a[1]);
    addSpecies(s, n);
  }
}

// returns all molecules on canvas, for manipulation.  When mFlag is set true, it is very expensive.
// hwever, MFlag is still broken... FIX damMIT
ArrayList getMolecules() {
  //if (mFlag == true) {
    molecules = new ArrayList();
    for (int i = 0; i < canvas.getBodies().size(); i++){
      String obj = canvas.getBodies().get(i).toString();
      if (obj.contains("Molecule") == true) {
        molecules.add(canvas.getBodies().get(i));
      }
    }
  //}
  mFlag = false;
  return molecules;
}

ArrayList getSpeciesShapes() {
  String s;
  ArrayList svgs = new ArrayList();
  for (int i = 0; i < speciesNamesInOrder.size(); i++) {
    s = getSpeciesFilename((String)speciesNamesInOrder.get(i));
    svgs.add(loadShape(s));
  }
  return svgs;
}

String getSpeciesFilename(String speciesName) {
    return "svg/" + speciesName + ".svg";
}

Molecule getLatestMolecule() {
  return (Molecule)getMolecules().get(getMolecules().size() -1);
}

//--------------------------------------------------------//

void addSpecies(String speciesName, int speciesQnty) {
  // this adjusts the speciesRoll if new species are created during the simulation not available at startup
  for (int i = 0; i < speciesRoll.size(); i++) {
    HashMap tmpSpecies = (HashMap)speciesRoll.get(i);
    tmpSpecies.put(speciesName, 0);
    speciesRoll.set(i, tmpSpecies);
  }
  speciesNamesInOrder.add(species.size(), speciesName);
  speciesShapes = getSpeciesShapes();
  species.put(speciesName, speciesQnty);
}

void updateRolls() {
  speciesRoll.add(species.clone());
  pHRoll.add(getPH());
  while (reactedMoleculeIDs.size() > countMolecules()) {
    reactedMoleculeIDs.remove(0);
  }
}

void populateCanvas() {
  for (int i = 0; i < speciesNamesInOrder.size(); i++) {
    String speciesName    = (String)speciesNamesInOrder.get(i);
    int initialPopulation = (Integer)species.get(speciesName);
    species.put(speciesName, 0);     // reset to 0 before increment
    for (int j = 0; j < initialPopulation; j++) {
      createMolecule(speciesName);
    }
  }
}

int countMolecules() {
  int count = 0;
  for (int i = 0; i < speciesNamesInOrder.size(); i++) {
    count = count + (Integer)species.get((String)speciesNamesInOrder.get(i));
  }
  return count;
}

int countMolecules(String speciesName) {
  if (species.containsKey(speciesName)) {
    return (Integer)species.get(speciesName);
  }
  return 0;
}

int countMoleculesPast(String speciesName, int timeUnit) {
  if (speciesRoll.size() > 0) {
    HashMap speciesPast = new HashMap();
    speciesPast = (HashMap)speciesRoll.get(timeUnit);
    int speciesCount = (Integer)speciesPast.get(speciesName);
    return speciesCount;
  } else {
    return 0;
  }
}

int countMostAbundantSpecies() {
  int count = 0;
  for (int i = 0; i < speciesNamesInOrder.size(); i++) {
    if ((Integer)species.get((String)speciesNamesInOrder.get(i)) > count) {
      count = (Integer)species.get((String)speciesNamesInOrder.get(i));
    }
  }
  return count;
}

int countSpecies() {
  if (species != null) {
    return species.size();
  } else {
    return 0;
  }
  //return 5;
}

void createMolecule(String speciesName) {
  createMolecule(speciesName, random(canvasArea.x, canvasArea.r), random(canvasArea.y, canvasArea.b));
}

void createMolecule(String speciesName, float x, float y) {
  if (!species.containsKey(speciesName)) {
    addSpecies(speciesName, 0);
  }
  if (countMolecules() < moleculeQntyLimit) {
    Molecule molecule = new Molecule(speciesName, x, y);
    if (species.containsKey(speciesName)) {
      int prevQnty = Integer.parseInt(species.get(speciesName).toString());
      species.put(speciesName, prevQnty + 1);
    } else {
      species.put(speciesName, 1);
    }
    canvas.add(molecule);
    
    totalMoleculesCreated++;
    molecule.moleculeID = totalMoleculesCreated;
  }
  mFlag = true;
}

void createMolecule(String speciesName, int quantity) {
  for (int i = 0; i < quantity; i++) {
    createMolecule(speciesName);
  }
}

void killMolecule(Molecule input) {  
  int prevQnty = (Integer)species.get(input.speciesName);
  for (int i = 0; i < countMolecules(); i++) {
    Molecule molecule = (Molecule)getMolecules().get(i);
    if (molecule == input) {
      prevQnty--;
      species.put(input.speciesName, prevQnty);
      canvas.remove((FBody)canvas.getBodies().get(i));
      break;
    }
  }
  mFlag = true;
}

void killMoleculeByType(String speciesName) {
  for (int i = 0; i < countMolecules(); i++) {
    Molecule molecule = (Molecule)getMolecules().get(i);
    
    if (molecule.speciesName().equals(speciesName)) {
      canvas.remove((FBody)canvas.getBodies().get(i));
      int prevQnty = Integer.parseInt(species.get(speciesName).toString());
      species.put(speciesName, prevQnty - 1);
      break;
    }
  }
  mFlag = true;
}

void react(Molecule m1, Molecule m2, float contactX, float contactY ) {
  int m1ID = m1.moleculeID;
  int m2ID = m2.moleculeID;
  PVector[] mVelocities = new PVector[2];
  mVelocities[0] = new PVector(m1.getVelocityX(), m1.getVelocityY());
  mVelocities[1] = new PVector(m2.getVelocityX(), m2.getVelocityY());
  
  
  ArrayList results = getReactResults(m1, m2);
  
  if ((!reactedMoleculeIDs.contains(m1ID)) && (!reactedMoleculeIDs.contains(m2ID)) && (results.size() > 0)) {
    float offset = defMoleculeScale * 40;
    killMolecule(m1);
    killMolecule(m2);
    reactedMoleculeIDs.add(m1ID);
    reactedMoleculeIDs.add(m2ID);
    for (int i = 0; i < results.size(); i++) {
      createMolecule((String)results.get(i), contactX + (i * offset), contactY + (i * offset));
      getLatestMolecule().setVelocity(mVelocities[i].y * -2, mVelocities[i].x * -2);
      offset = offset * -1;
    }
  }
}

ArrayList getReactResults(Molecule m1, Molecule m2) {
  //  Hydrochloric-Acid, Water	1	Hydronium, Chloride
  ArrayList emptyAL = new ArrayList();
  ArrayList mNames = new ArrayList();
  mNames.add(m1.speciesName);
  mNames.add(m2.speciesName);
  
  for (int i = 0; i < reactTableRowCount; i++) {
    ArrayList reactantsAL = new ArrayList(Arrays.asList(reactants[i].split(", ")));
    if (arrayListMatch(mNames, reactantsAL) && (random(0, 1) < reactProbabilities[i])) {
      ArrayList reactResultsAL = new ArrayList(Arrays.asList(reactResults[i].split(", ")));
      return reactResultsAL;
    }
  }
  return emptyAL;
}

String getCurrentSpecies() {
  return currentSpeciesName;
}

void setCurrentSpecies(String s) {
	currentMolecule = null;
  currentSpeciesName = s;
}

void unsetCurrentSpecies() {
  currentSpeciesName = "";
}

void setCurrentMolecule(Molecule m) {
  currentMolecule = m;
}

void pickMoleculeOfSpecies(String species) {
	for (int i = 0; i<getMolecules().size(); i++) {
		Molecule molecule = (Molecule)getMolecules().get(i);
		if (molecule.speciesName().equals(species)) {
			setCurrentMolecule(molecule);
			break;
		}
	}
}

float log10(float x) {
  return (log(x) / log(10));
}

float getPH() { 
  float pH;
  float pOH;
  int countH3O   = countMolecules("Hydronium");
  int countOH    = countMolecules("Hydroxide");
  int countOther = countMolecules() - countH3O - countOH;
  
  float volH3O   = float(countH3O) / 100000;
  float volOH    = float(countOH)  / 100000;
  //float volOther = float(countOther) * 1000;
  
  float volAll   = 50 + volH3O + volOH;

  if (volH3O != volOH) {
    pH  = log10(volH3O / volAll) * -1;
  } else {
    pH = 7;
  }
  
  return pH;
}

/*float getPOH() { 
  float pOH;
  int qntyH3O   = countMolecules("Hydronium");
  int qntyOH    = countMolecules("Hydroxide");
  float totalVolume = float(countMolecules()) / 1000;

  if (qntyH3O != qntyOH) {
    pOH = log10(qntyOH / totalVolume);
  } else {
    pOH = 7;
  }
  return pOH;
}*/
