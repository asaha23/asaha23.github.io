import      controlP5.*;
ControlP5   controlP5;
ControlFont cf1;
PFont       fontMyriadPro10;

float mod = 48;
int iMod = 48;

int currentUnit = -1;
int currentLesson = -1;
int currentSimulation = -1;

String[] currentListBoxUnit;
String[] currentListBoxLesson;
String[] currentListBoxSimulation;

float menu1W = mod * 4.5;
float menu2W = mod * 9.5;
float menu3W = mod * 9.5;
float menuH  = mod * 4;
float menuMargin = mod/2;

float hz1 = mod * 3/4;
float hz2 = hz1 + menuH;

float vt1 = mod/4;
float vt2 = vt1 + menu1W;
float vt3 = vt2 + menuMargin;
float vt4 = vt3 + menu2W;
float vt5 = vt4 + menuMargin;
float vt6 = vt5 + menu3W;

HashMap allItemsRanked = new HashMap();

String[] allItems = new String[] {
  "01:  Modeling and Matter",
  "02:  Solutions",
  "03:  Reactions",
  "04:  Gas Laws and Pressure",
  "05:  Thermodynamics",
  "06:  Kinetics",
  "07:  Equilibrium",
  "08:  Acids and Bases",
  "08-02:  Acid Base Theory",
  "08-02-01:  Hydrochloric Acid + Water = Hydronium, Chlorine Ion",
  "08-02-02:  Sodium Hydroxide + Water = Water, Hydroxide",
  "08-02-03:  Hydrochloric Acid + Sodium Hydroxide = Chlorine Ion, Water",
  "08-02-04:  Hydrochloric Acid + Ammonia = Chlorine Ion, Ammonium Ion",
  "08-02-05:  Cyanide Ion + Hydrogen Bromide = Hydrogen Cyanide, Bromine Ion",
  "08-02-06:  Boron Trichloride + Chlorine Ion = Boron Tetrachloride",
  "08-03:  Disassociation of Acids and Bases",
  "08-03-01:  Strong acid (Hydrochloric Acid) added to water",
  "08-03-02:  Weak acid (Hydrogen Fluoride) added to water",
  "08-03-03:  Strong base (Sodium Hydroxide) added to water",
  "08-03-04:  Weak base (Ammonia) added to water",
  "08-04:  Identifying Acids and Bases and Mathematical Relationships",
  "08-04-01:  Acetic Acid added to water",
  "08-04-02:  Lithium Hydroxide added to water",
  "08-04-03:  Methylamine added to water",
  "08-04-04:  Nitric Acid added to water",
  "08-06:  Titration Curves: Strong Base into Strong Acid",
  "08-06-01:  Hydrochloric Acid + Sodium Hydroxide = Sodium Chloride + Water",
  "08-07:  Titration Curves",
  "08-07-01:  Strong acid into weak base (HCl into NH3) = Ammonium Chloride",
  "08-07-02:  Weak acid (Acetic Acid) into strong base (Sodium Hydroxide) = Water + Sodium Acetate (Conjugate Base)",
  "08-07-03:  Weak acid (Acetic Acid) into weak base (Ammonia) = Ammonium Acetate",
  "08-08:  Buffers",
  "08-08-01:  -- BROKEN -- buffered solution: Water, Sodium Carbonate, Bicarbonate, Sodium Ions, Carbonate",
  "09:  Nuclear Chemistry"
};

ListBox listBoxUnit;
ListBox listBoxLesson;
ListBox listBoxSimulation;

void setup() {
  size(1200, 360);
  smooth();
  
  controlP5 = new ControlP5(this);
  controlP5.setControlFont(new ControlFont(createFont("Monaco",12), 12));
  
  fontMyriadPro10 = loadFont("MyriadPro-Regular-10.vlw");
  cf1 = new ControlFont(createFont("Verdana",12));
  
  initListBox("unit");
  initListBox("lesson");
  initListBox("simulation");
  
  populateListBoxen("all");
}
void draw() {
  background(25, 25, 30);
}
void controlEvent(ControlEvent theEvent) {
  // ListBox is if type ControlGroup.
  // 1 controlEvent will be executed, where the event
  // originates from a ControlGroup. therefore
  // you need to check the Event with
  // if (theEvent.isGroup())
  // to avoid an error message from controlP5.
  
  if (theEvent.isGroup()) {
    // an event from a group e.g. scrollList
    String type   = theEvent.group().name();
    int    choice = floor(theEvent.group().value());
    
    setCurrentItem(type, choice);
  }
}


void initListBox(String type) {
  if (type.equals("unit")) {
    listBoxUnit = controlP5.addListBox("unit",  floor(vt1),floor(hz1),floor(menu1W),floor(menuH));
    listBoxUnit.captionLabel().set("Please choose a Unit");
    listBoxUnit.captionLabel().toUpperCase(false);
    listBoxUnit.captionLabel().style().margin(6);
    listBoxUnit.captionLabel().setControlFont(cf1);
    listBoxUnit.setBarHeight(23);
    listBoxUnit.actAsPulldownMenu(true);
    listBoxUnit.setItemHeight(15);
    //listBoxUnit.setValue(2);
  }
  
  if (type.equals("lesson")) {
    listBoxLesson = controlP5.addListBox("lesson",  floor(vt3),floor(hz1),floor(menu2W),floor(menuH));
    listBoxLesson.captionLabel().set("Please choose a Lesson");
    listBoxLesson.captionLabel().toUpperCase(false);
    listBoxLesson.captionLabel().style().margin(6);
    listBoxLesson.captionLabel().setControlFont(cf1);
    listBoxLesson.setBarHeight(23);
    listBoxLesson.actAsPulldownMenu(true);
    listBoxLesson.setItemHeight(15);
    //listBoxUnit.setValue(lesson);
  }
  
  if (type.equals("simulation")) {
    listBoxSimulation = controlP5.addListBox("simulation",  floor(vt5),floor(hz1),floor(menu3W),floor(menuH));
    listBoxSimulation.captionLabel().set("Please choose a Simulation");
    listBoxSimulation.captionLabel().toUpperCase(false);
    listBoxSimulation.captionLabel().style().margin(6);
    listBoxSimulation.captionLabel().setControlFont(cf1);
    listBoxSimulation.setBarHeight(23);
    listBoxSimulation.actAsPulldownMenu(true);
    listBoxSimulation.enableCollapse();
    listBoxSimulation.setItemHeight(15);
    //listBoxUnit.setValue(simulation);
  }
}

void populateListBoxen(String which) {
  //populateListBox(listBoxUnit, filterByType(allItems, "unit"));
  //populateListBox(listBoxLesson, filterByType(allItems, "lesson"));
  //populateListBox(listBoxSimulation, filterByType(allItems, "simulation"));
  if (which.equals("all")) {
    listBoxUnit.clear();
    listBoxUnit.close();
    listBoxUnit.captionLabel().set("Please choose a Unit");
    populateListBox(listBoxUnit, filterByCascade(filterByType(allItems, "unit")));
  }
  
  if (which.equals("all") || which.equals("unit")) {
    listBoxLesson.clear();
    listBoxLesson.close();
    listBoxLesson.captionLabel().set("Please choose a Lesson");
    populateListBox(listBoxLesson, filterByCascade(filterByType(allItems, "lesson")));
  }
  
  if (which.equals("all") || which.equals("unit") || which.equals("lesson")) {
    listBoxSimulation.clear();
    listBoxSimulation.close();
    listBoxSimulation.captionLabel().set("Please choose a Simulation");
    populateListBox(listBoxSimulation, filterByCascade(filterByType(allItems, "simulation")));
  }
}

void populateListBox(ListBox listBox, String[] items) {
  listBox.clear();
  for (int i=0; i<items.length; i++) {
    int idLen   = getItemId(items[i]).length();
    int textLen = getItemText(items[i]).length();
    int listBoxWidth = listBox.getWidth();
    float charW = 7;
    int truncateAmnt = floor(listBoxWidth / charW)-8;
    String  ellipsis = "...";
    if (textLen <= truncateAmnt) {
      truncateAmnt = textLen;
      ellipsis = "";
    }
    
    String itemTruncated = getItemId(items[i]).substring(idLen-2, idLen) + ": " + getItemText(items[i]).substring(0, truncateAmnt) + ellipsis;
    String  itemId = getItemId(items[i]);
    String  itemType = getItemType(itemId);
    int     itemRank = i;
    
    String itemKey = itemType + str(i);
    String itemValue = itemId;
    
    allItemsRanked.put(itemKey, itemValue);
    listBox.addItem(itemTruncated, i);
  }
}

String getItemId(String item) {
  String[] strings = split(item, ":");
  return strings[0];
}
String getItemText(String item) {
  String[] strings = split(item, ":");
  return trim(strings[1]);
}

Integer getItemUnit(String itemId) {
  int output;
  if (itemId.length() >= 2) {
    output = int(itemId.substring(0, 2));
    return output;
  } else {
    return -1;
  }
}
Integer getItemLesson(String itemId) {
  int output;
  if (itemId.length() >= 5) {
    output = int(itemId.substring(3, 5));
    return output;
  } else {
    return -1;
  }
}
Integer getItemSimulation(String itemId) {
  int output;
  if (itemId.length() >= 8) {
    output = int(itemId.substring(6, 8));
    return output;
  } else {
    return -1;
  }
}

String getItem(String itemId) {
  String output = "";
  for (int i=0; i<allItems.length; i++) {
    String currentItemId = getItemId(allItems[i]);
    if (currentItemId.equals(itemId)) {
      output = allItems[i];
    }
  }
  return output;
}
String getItemType(String itemId) {
  String type = null;
  String[] idParts = split(itemId, "-");
  if      (idParts.length == 1) {type = "unit";}
  else if (idParts.length == 2) {type = "lesson";}
  else if (idParts.length == 3) {type = "simulation";}
  else                          {type = null;}
  return type;
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

String[] filterByType(String[] items, String type) {
  ArrayList itemsArray = convertStringArrayToArrayList(items);
  String item;
  String checkType;
  ArrayList itemsToRemove = new ArrayList();
  for (int i=0; i<itemsArray.size(); i++) {
    item = (String)itemsArray.get(i);
    checkType = getItemType(item);
    if (!type.equals(checkType)) {
      itemsToRemove.add(item);
    }
  }
  for (int i=0; i<itemsToRemove.size(); i++) {
    itemsArray.remove(itemsToRemove.get(i));
  }
  return convertArrayListToStringArray(itemsArray);
}

String[] filterByCascade(String[] items) {
  ArrayList itemsArray = convertStringArrayToArrayList(items);
  String item;
  String type;
  String itemId;
  ArrayList itemsToRemove = new ArrayList();
  for (int i=0; i<itemsArray.size(); i++) {
    item = (String)itemsArray.get(i);
    type = getItemType(item);
    itemId = getItemId(item);
    if      (type.equals("unit")) {
      // units should not be filtered.  Should never be limited by this function.
    }
    else if (type.equals("lesson")) {
      // get unit of item
      // if unit of item doesn't match current unit, remove
      if (getCurrentUnit() != getItemUnit(itemId)) {
        itemsToRemove.add(item);
      }
    }
    else if (type.equals("simulation")) {
      // get lesson of item
      // if lesson of item doesn't match current lesson, remove
      if (getCurrentLesson() != getItemLesson(itemId)) {
        itemsToRemove.add(item);
      }
    }
    else {
      // if the type isn't one of these, it doesn't belong anyways.
      itemsToRemove.add(item);
    }
  }
  for (int i=0; i<itemsToRemove.size(); i++) {
    itemsArray.remove(itemsToRemove.get(i));
  }
  return convertArrayListToStringArray(itemsArray);
}

int getCurrentUnit()                  {  return currentUnit; }
int getCurrentLesson()                {  return currentLesson; }
int getCurrentSimulation()            {  return currentSimulation; }
void setCurrentUnit(int input)        {  currentUnit = input; }
void setCurrentLesson(int input)      {  currentLesson = input; }
void setCurrentSimulation(int input)  {  currentSimulation = input; }

void setCurrentItem(String type, int choice) {
  String itemKey = type + str(choice);

  String itemId = (String)allItemsRanked.get(itemKey);
  
  String itemType = getItemType(itemId);
  if (itemType.equals("unit")) {}
  if (itemType.equals("lesson")) {}
  if (itemType.equals("simulation")) {}
  
  int itemUnit = getItemUnit(itemId);
  int itemLesson = getItemLesson(itemId);
  int itemSimulation = getItemSimulation(itemId);
  
  setCurrentUnit(itemUnit);
  setCurrentLesson(itemLesson);
  setCurrentSimulation(itemSimulation);
  
  populateListBoxen(itemType);
}