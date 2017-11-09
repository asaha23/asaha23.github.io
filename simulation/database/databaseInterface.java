// For internal use: we pass around ID numbers
// For display use in simulation, we use names








//////////////
// Compounds
//////////////



//////////////
// Reactions
//////////////

//////////////
// ProductSets
//////////////

//////////////
// Elements //
//////////////

// useful for menus: provide text list of every molecule we use in the system
ArrayList() getAllElementNames() {}


//////////////
// Units
//////////////

// for menus
String getUnitName(int unitID) {}

// provides a list of all unit titles
ArrayList() getAllUnitIDs()

//////////////
// Lessons
//////////////

// for menus
String getLessonName(int lessonID) {}

// good for menus:  list of ids
ArrayList() getAllLessonIDsForUnit(int unitID) {}

//////////////
// Simulations
//////////////

// for menus
String getSimulationName(int simulationID) {}

// provide a list of all compounds, in order to populate Legend widget
ArrayList() getAllCompoundsOfSimulation(int simulationID) {
  // what are the sets of this simulation
  // parse each of the sets of this simulation for getAllCompoundsOfSet(int setID)
  // add them all together
}

//////////////
// Sets
//////////////

// for menus
String getSetName(int setName) {} // may not matter

// for menus
ArrayList getAllWidgetIDs(int setID) {} // may not matter

// provide a list of all compounds to populate Simulation Sets
ArrayList() getAllCompoundIDsForSet(int setID) {}

//////////////
// Widgets
//////////////

// for menus
String getWidgetName(int widgetID) {} // may not matter