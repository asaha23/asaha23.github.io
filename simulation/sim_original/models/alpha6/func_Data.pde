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

void setupData() {
  setupInitTable();
  setupReactionTable();
}

//void updateData() {}


//--------------------------------------------------------//

void setupInitTable() {
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


void setupReactionTable() {
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

int getUnitNumber() {
  int unit;
  try {
    unit = int(param("unitSelect"));
  } catch (Exception e) {
    unit = offlineUnit;
  }
  return unit;
}
int getLessonNumber() {
  int lesson;
  try {
    lesson = int(param("lessonSelect"));
  } catch (Exception e) {
    lesson = offlineLesson;
  }
  return lesson;
}
int getSimNumber() {
  int sim;
  try {
    sim = int(param("activitySelect"));
  } catch (Exception e) {
    sim = offlineSim;
  }
  return sim;
}





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

