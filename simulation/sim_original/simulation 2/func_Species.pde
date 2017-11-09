// the sim apparently crashes above this many molecules.  
int moleculeQntyLimit = 200;

HashMap   species;
ArrayList speciesHistory;
ArrayList pHHistory;

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

String[] allSpecies = new String[] {
	"Acetate", "Acetic-Acid", "Acetone", "Actinium-Atom", "Actinium-Ion", "Aluminum-Atom", "Aluminum-Chloride", "Aluminum-Ion", "Aluminum-Oxide", "Americium-Atom", "Ammonia", "Ammonium", "Ammonium-Acetate", "Ammonium-Chloride", "Ammonium-Nitrate", "Ammonium-Sulfate", "Antimony-Atom", "Antimony-III", "Antimony-V", "Argon-Atom", "Argon-Ion", "Arsenic-Atom", "Astatine-Atom", "Azide", "Barium-Atom", "Barium-Ion", "Benzoate", "Berkelium-Atom", "Beryllium-Atom", "Beryllium-Ion", "Bicarbonate", "Bismuth-Atom", "Bismuth-III", "Bismuth-V", "Bohrium-Atom", "Boric-Acid", "Boron-Atom", "Boron-Ion", "Boron-Tetrachloride", "Boron-Trichloride", "Bromide", "Bromine-Atom", "Bromine-Ion", "Bromine-Molecule", "Butane", "Butene", "Cadmium-Atom", "Cadmium-Ion", "Calcium-Atom", "Calcium-Carbonate", "Calcium-Chloride", "Calcium-Hydroxide", "Calcium-Ion", "Calcium-Sulfate", "Californium-Atom", "Californium-Ion", "Carbide", "Carbon-Atom", "Carbon-Dioxide", "Carbon-Monoxide", "Carbonate", "Carbonic-Acid", "Cerium-Atom", "Cesium-Atom", "Cesium-Ion", "Chlorate", "Chloride", "Chlorine-Atom", "Chlorine-Ion", "Chlorine-Molecule", "Chlorite", "Chlorite", "Chromate", "Chromium-Atom", "Chromium-II", "Chromium-III", "Chromium-III-Oxide", "Cobalt-Atom", "Cobalt-II", "Cobalt-III", "Copper-Atom", "Copper-II", "Copper-II-Nitrate", "Copper-II-Sulfate", "Copper-III", "Curium-Atom", "Cyanide", "Deuterium", "Dextrose", "Dinitrogen-Tetroxide", "Dubnium-Atom", "Dysprosium-Atom", "Dysprosium-Ion", "Einsteinium-Atom", "Erbium-Atom", "Ethanol", "Ethene", "Europium-Atom", "Fermium-Atom", "Fluoride", "Fluorine-Atom", "Fluorine-Ion", "Fluorine-Molecule", "Francium-Atom", "Francium-I", "Francium-Ion", "Fructose", "Gadolinium-Atom", "Gallium-Atom", "Gallium-Ion", "Generic", "Germanium-Atom", "Germanium-Ion", "Glucose", "Glycerol", "Gold-Atom", "Gold-I", "Gold-III", "Hafnium-Atom", "Hafnium-Ion", "Hafnium-Ion", "Hassium-Atom", "Helium-Atom", "Helium-Ion", "Holmium-Atom", "Hydrochloric-Acid", "Hydrogen-Atom", "Hydrogen-Bromide", "Hydrogen-Carbonate", "Hydrogen-Cyanide", "Hydrogen-Fluoride", "Hydrogen-Iodide", "Hydrogen-Ion", "Hydrogen-Peroxide", "Hydrogen-Phosphate", "Hydrogen-Phosphate-Ion", "Hydrogen-Sulfate", "Hydrogen-Sulfide", "Hydrogen-Sulfite", "Hydronium", "Hydroxide", "Hypochlorite", "Phenylpthalein", "Indium-Atom", "Indium-Ion", "Inert", "Iodine-Atom", "Iodine-Ion", "Iron-Atom", "Iron-I", "Iron-II", "Iron-II-Sulfate", "Iron-III", "Iron-III-Chloride", "Iron-III-Thiocyanate", "Krypton-Atom", "Krypton-Ion", "Lanthanum-Atom", "Lanthanum-Ion", "Lawrencium-Atom", "Lead-Atom", "Lead-II", "Lead-IV", "Lithium-Atom", "Lithium-Chloride", "Lithium-Hydroxide", "Lithium-I", "Lithium-Ion", "Lithium-Nitrate", "Lithium-Sulfide", "Lutetium-Atom", "Lutetium-Ion", "Magnesium-Atom", "Magnesium-Ion", "Magnesium-Sulfate", "Manganese-Atom", "Manganese-Dioxide", "Manganese-II", "Manganese-II-Chloride", "Manganese-IV", "Meitnerium-Atom", "Mendelevium-Atom", "Mercury-Atom", "Mercury-I", "Mercury-II", "Methane", "Methanol", "Methylamine", "Methylammonium", "Molybdenum-Atom", "Molybdenum-Ion", "Neodymium-Atom", "Neon-Atom", "Neon-Ion", "Neptunium-Atom", "Nickel-Atom", "Nickel-II", "Nickel-III", "Niobium-Atom", "Niobium-III", "Niobium-V", "Nitrate", "Nitric-Acid", "Nitric-Oxide", "Nitrite", "Nitrogen-Atom", "Nitrogen-Dioxide", "Nitrogen-Ion", "Nitrogen-Molecule", "Nitrous-Oxide", "Nobelium-Atom", "Osmium-Atom", "Osmium-Ion", "Oxygen-Atom", "Oxygen-Ion", "Oxygen-Molecule", "Palladium-Atom", "Pentane", "Perchlorate", "Permanganate", "Peroxide", "Phosphate", "Phosphite", "Phosphoric-Acid", "Phosphorus-Atom", "Phosphorus-Ion", "Platinum-Atom", "Platinum-II", "Platinum-IV", "Plutonium-Atom", "Polonium-Atom", "Polonium-II", "Polonium-IV", "Potassium-Atom", "Potassium-Bromide", "Potassium-Chloride", "Potassium-Hydroxide", "Potassium-I", "Potassium-Nitrate", "Potassium-Thiocyanate", "Praseodymium-Atom", "Promethium-Atom", "Protactinium-Atom", "Radium-Atom", "Radium-Ion", "Radon-Atom", "Radon-Ion", "Rhenium-Atom", "Rhenium-Ion", "Rhodium-Atom", "Rubidium-Atom", "Rubidium-Ion", "Ruthenium-Atom", "Ruthenium-III", "Ruthenium-IV", "Rutherfordium-Atom", "Samarium-Atom", "Scandium-Atom", "Scandium-Ion", "Seaborgium-Atom", "Selenium-Atom", "Selenium-Ion", "Silicate", "Silicon-Atom", "Silicon-Dioxide", "Silicon-Ion", "Silicon-IV", "Silver-Atom", "Silver-Bromide", "Silver-Carbonate", "Silver-Chloride", "Silver-Hydroxide", "Silver-Ion", "Silver-Nitrate", "Sodium-Acetate", "Sodium-Atom", "Sodium-Bicarbonate", "Sodium-Carbonate", "Sodium-Chloride", "Sodium-Hydroxide", "Sodium-I", "Sodium-Ion", "Sodium-Nitrate", "Sodium-Nitrite", "Strontium-Atom", "Strontium-Ion", "Sucrose", "Sulfate", "Sulfide", "Sulfur-Atom", "Sulfur-Dioxide", "Sulfur-Ion", "Sulfur-Tetrafluoride", "Sulfuric-Acid", "Superoxide", "Tantalum-Atom", "Tantalum-Ion", "Technetium-Atom", "Technetium-Ion", "Tellurium-Atom", "Terbium-Atom", "Thallium-Atom", "Thallium-I", "Thallium-III", "Thiocyanate", "Thiocyanic-Acid", "Thorium-Atom", "Thulium-Atom", "Tin-Atom", "Tin-II", "Tin-IV", "Titanium-Atom", "Titanium-III", "Titanium-IV", "Tungsten-Atom", "Tungsten-Ion", "Ununbium-Atom", "Ununnilium-Atom", "Ununquadium-Atom", "Unununium-Atom", "Uranium-Atom", "Vanadium-Atom", "Vanadium-IV", "Vanadium-V", "Water", "Xenon-Atom", "Xenon-Ion", "Ytterbium-Atom", "Yttrium-Atom", "Yttrium-Ion", "Zinc-Atom", "Zinc-Ion", "Zirconium-Atom", "Zirconium-Ion"
};

//--------------------------------------------------------//

void startSpecies() {
  species 						= new HashMap();
  speciesHistory 			= new ArrayList();
  pHHistory 					= new ArrayList();
  reactedMoleculeIDs 	= new ArrayList();
  molecules 					= new ArrayList();
  speciesNamesInOrder = new ArrayList();
  speciesShapes 			= new ArrayList();
  currentSpeciesName 	= new String();
  getInitialSpecies(getUnitNumber(), getLessonNumber(), getSimulationNumber());
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
  // this adjusts the speciesHistory if new species are created during the simulation not available at startup
  for (int i = 0; i < speciesHistory.size(); i++) {
    HashMap tmpSpecies = (HashMap)speciesHistory.get(i);
    tmpSpecies.put(speciesName, 0);
    speciesHistory.set(i, tmpSpecies);
  }
  speciesNamesInOrder.add(species.size(), speciesName);
  speciesShapes = getSpeciesShapes();
  species.put(speciesName, speciesQnty);
}

void updateHistory() {
  speciesHistory.add(species.clone());
  pHHistory.add(getPH());
  while (reactedMoleculeIDs.size() > countMolecules()) {
    reactedMoleculeIDs.remove(0);
  }
}

void startCanvas() {
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
  if (speciesHistory.size() > 0) {
    HashMap speciesPast = new HashMap();
    speciesPast = (HashMap)speciesHistory.get(timeUnit);
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
	pH = map(pH, 4.5, 9.5, 0, 14);
  return pH;
}

float currentSolventWeight() {
	float weight = 0.0;
	return weight;
}

float currentSoluteWeight() {
	float weight = 0.0;
	return weight;
}

float currentTotalVolume() {
	float vol = 0.0;
	return vol;
}

float currentTotalTemperature() {
	float temperature = 0.0;
	return temperature;
}

float currentTotalPressure() {
	float pressure = 0.0;
	return pressure;
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

Table       elementTable; // main repository for element data
int         elementTableRowCount;
int[]       elementNumber;
String[]    elementName;
String[]    elementSymbol;
String[]    elementColorName;
int[]       elementColorRed;
int[]       elementColorGreen;
int[]       elementColorBlue;
//elementNameWaalsRadius;
float[]     elementAtomicRadius;
float[]     elementAtomicMass;

Table       initTable;
int         initTableRowCount;
int[]       initUnit;
int[]       initLesson;
int[]       initSim;
String[]    initSpecies;
String[]    initWidgets;

Table       reactTable;
int         reactTableRowCount;
String[]    reactants;
float[]     reactProbabilities;
String[]    reactResults;


//--------------------------------------------------------//

void startData() {
  startInitTable();
  startReactionTable();
}

//--------------------------------------------------------//

void startInitTable() {
  initTable           = new Table("data/init.tsv");
  initTableRowCount   = initTable.getRowCount();
  initUnit            = new int[initTableRowCount];
  initLesson          = new int[initTableRowCount];
  initSim             = new int[initTableRowCount];
  initSpecies         = new String[initTableRowCount];
  initWidgets         = new String[initTableRowCount];
  
  for (int row = 0; row < initTableRowCount; row++) {
    initUnit[row]     = initTable.getInt(row, 0);
    initLesson[row]   = initTable.getInt(row, 1);
    initSim[row]      = initTable.getInt(row, 2);
    initSpecies[row]  = initTable.getString(row, 3);
    initWidgets[row]  = initTable.getString(row, 4);
    
    
  }
}

void startReactionTable() {
  reactTable          = new Table("data/reactions.tsv");
  reactTableRowCount  = reactTable.getRowCount();
  reactants           = new String[reactTableRowCount];
  reactProbabilities  = new float[reactTableRowCount];
  reactResults        = new String[reactTableRowCount];
  
  for (int row = 0; row < reactTableRowCount; row++) {
    reactants[row]          = reactTable.getString(row, 0);
    reactProbabilities[row] = reactTable.getFloat(row, 1);
    reactResults[row]       = reactTable.getString(row, 2);
  }
}

int getUnitNumber() 										{ return unit; }
int getLessonNumber() 									{ return lesson; }
int getSimulationNumber() 							{ return simulation; }
                                    		
void setUnitNumber(int input) 					{ unit = input; }
void setLessonNumber(int input) 				{ lesson = input; }
void setSimulationNumber(int input) 		{ simulation = input; }

int getNextUnitNumber() 								{ return nextUnit; }
int getNextLessonNumber() 							{ return nextLesson; }
int getNextSimulationNumber() 					{ return nextSimulation; }
                                    		
void setNextUnitNumber(int input) 			{ nextUnit = input; }
void setNextLessonNumber(int input) 		{ nextLesson = input; }
void setNextSimulationNumber(int input) { nextSimulation = input; }

int getSelectedUnit()                  {  return selectedUnit; }
int getSelectedLesson()                {  return selectedLesson; }
int getSelectedSimulation()            {  return selectedSimulation; }

void setSelectedUnit(int input)        {  selectedUnit = input; }
void setSelectedLesson(int input)      {  selectedLesson = input; }
void setSelectedSimulation(int input)  {  selectedSimulation = input; }

int getCurrentUnit()                  {  return unit; }
int getCurrentLesson()                {  return lesson; }
int getCurrentSimulation()            {  return simulation; }

void setCurrentUnit(int input)        {  unit = input; }
void setCurrentLesson(int input)      {  lesson = input; }
void setCurrentSimulation(int input)  {  simulation = input; }


boolean arrayListMatch(ArrayList al1, ArrayList al2) {
  // brute force method.
  // for each item in the first array...
  for (int i = 0; i < al1.size(); i++) {
    // check if the second array contains that item...
    if (al2.contains(al1.get(i))) {
      // if the second array contains that item, remove it.
      al2.remove(al2.indexOf(al1.get(i)));
      // if the 2nd array runs out of items to remove, then all items in al1 are in al2
    } else {
      return false;
    }
  }
  // final check: make sure the truncated al2 doesn't have anything left to remove. If so, the two arrays are equal
  if (al2.size() < 1) {
    return true;
  } else {
    return false;
  }
}

String[] convertArrayListToStringArray(ArrayList arrayList)  {
  String[] output = new String[arrayList.size()];
  String outputItem;
  for (int i=0; i<output.length; i++) {
    outputItem = (String)arrayList.get(i);
    output[i] = outputItem;
  }
  return output;
}
ArrayList convertStringArrayToArrayList(String[] stringArray) {
  ArrayList output = new ArrayList();
  for (int i=0; i<stringArray.length; i++) {
    output.add(stringArray[i]);
  }
  return output;
}

float tempFtoC(float f) {
  float c = (5/9)*(f-32);
  return c;
}

float tempCtoF(float c) {
  float f = ((9/5)*c) + 32;
  return f;
}

float tempCtoK(float c) {
  float k = c + 273.15;
  return k;
}

float tempKtoC(float k) {
  float c = k - 273.15;
  return c;
}