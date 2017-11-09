float menu1W = mod * 5;
float menu2W = mod * 9;
float menu3W = mod * 9;
float menuH  = mod * 4;
float menuMargin = mod/2;

float hz1 = mod;
float hz2 = hz1 + menuH;

float vt1 = mod/2;
float vt2 = vt1 + menu1W;
float vt3 = vt2 + menuMargin;
float vt4 = vt3 + menu2W;
float vt5 = vt4 + menuMargin;
float vt6 = vt5 + menu3W;

HashMap allItemsRanked = new HashMap();

String[] allItems = new String[] {
  //"01:  Modeling and Matter",
  //"02:  Solutions",
  //"03:  Reactions",
  //"04:  Gas Laws and Pressure",
  //"05:  Thermodynamics",
  //"06:  Kinetics",
  //"07:  Equilibrium",
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
  "08-08-01:  BROKEN buffered solution: Water, Sodium Carbonate, Bicarbonate, Sodium Ions, Carbonate"//,
  //"09:  Nuclear Chemistry"
};
ArrayList allItemsAL = new ArrayList();
ArrayList allUnitsAL = new ArrayList();
ArrayList allLessonsAL = new ArrayList();
ArrayList allSimulationsAL = new ArrayList();

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

String[] filterByType(String[] items, String type) {
  ArrayList itemsAL = convertStringArrayToArrayList(items);
  itemsAL = filterByType(itemsAL, type);
	return convertArrayListToStringArray(itemsAL);
}

ArrayList filterByType(ArrayList items, String type) {
  String item;
  String checkType;
  ArrayList itemsToRemove = new ArrayList();
  for (int i=0; i<items.size(); i++) {
    item = (String)items.get(i);
    checkType = getItemType(item);
    if (!type.equals(checkType)) {
      itemsToRemove.add(item);
    }
  }
  for (int i=0; i<itemsToRemove.size(); i++) {
    items.remove(itemsToRemove.get(i));
  }
  return items;
}

ArrayList filterByUnit(ArrayList items, int unit_) {
	ArrayList tmpAL = new ArrayList();
	String item;
	for (int i = 0; i<items.size(); i++) {
		item = (String)items.get(i);
		if (getItemUnit(item) == unit_) {
			tmpAL.add(item);
		}
	}
	return tmpAL;
}

ArrayList filterByLesson(ArrayList items, int lesson_) {
	ArrayList tmpAL = new ArrayList();
	String item;
	for (int i = 0; i<items.size(); i++) {
		item = (String)items.get(i);
		if (getItemLesson(item) == lesson_) {
			tmpAL.add(item);
		}
	}
	return tmpAL;
}

ArrayList filterBySimulation(ArrayList items, int simulation_) {
	ArrayList tmpAL = new ArrayList();
	String item;
	for (int i = 0; i<items.size(); i++) {
		item = (String)items.get(i);
		if (getItemSimulation(item) == simulation_) {
			tmpAL.add(item);
		}
	}
	return tmpAL;
}

/*boolean hasChildren(String item) {
	String itemId = getItemId(item);
	String itemType = getItemType(itemId);
	ArrayList items = new ArrayList();
	for (int i = 0; i < allItemsAL.size(); i++) {
		String tmpItem = (String)allItemsAL.get(i);
		
	}
	if (items > 0) {
		return true;
	} else {
		return false;
	}
}*/

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
}

String getCurrentItem(String type_) {
	String tmpA = new String();
	if (type_.equals("unit")) {
		for (int i = 0; i<allUnitsAL.size(); i++) {
			String tmpB = (String)allUnitsAL.get(i);
			if (getItemUnit(tmpB) == getCurrentUnit()) {
				tmpA = tmpB;
			}
		}
	} else if (type_.equals("lesson")) {
		for (int i = 0; i<allLessonsAL.size(); i++) {
			String tmpB = (String)allLessonsAL.get(i);
			if (getItemLesson(tmpB) == getCurrentLesson() && getItemUnit(tmpB) == getCurrentUnit()) {
				tmpA = tmpB;
			}
		}
	} else if (type_.equals("simulation")) {
		for (int i = 0; i<allSimulationsAL.size(); i++) {
			String tmpB = (String)allSimulationsAL.get(i);
			if (getItemSimulation(tmpB) == getCurrentSimulation() && getItemLesson(tmpB) == getCurrentLesson() && getItemUnit(tmpB) == getCurrentUnit()) {
				tmpA = tmpB;
			}
		}
	}
	return tmpA;
}

String getNextItem(String type_) {
	String tmpA = new String();
	if (type_.equals("unit")) {
		for (int i = 0; i<allUnitsAL.size(); i++) {
			String tmpB = (String)allUnitsAL.get(i);
			if (getItemUnit(tmpB) == getNextUnitNumber()) {
				tmpA = tmpB;
			}
		}
	} else if (type_.equals("lesson")) {
		for (int i = 0; i<allLessonsAL.size(); i++) {
			String tmpB = (String)allLessonsAL.get(i);
			if (getItemLesson(tmpB) == getNextLessonNumber() && getItemUnit(tmpB) == getNextUnitNumber()) {
				tmpA = tmpB;
			}
		}
	} else if (type_.equals("simulation")) {
		for (int i = 0; i<allSimulationsAL.size(); i++) {
			String tmpB = (String)allSimulationsAL.get(i);
			if (getItemSimulation(tmpB) == getNextSimulationNumber() && getItemLesson(tmpB) == getNextLessonNumber() && getItemUnit(tmpB) == getNextUnitNumber()) {
				tmpA = tmpB;
			}
		}
	}
	return tmpA;
}