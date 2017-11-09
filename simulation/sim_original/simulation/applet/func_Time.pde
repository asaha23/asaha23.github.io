// New time functions
int runTotal()   { return millis() - runStart; }
int netPlayed()  {
  if (paused == true) {
    return netPlayed;
  } else {
    return netPlayed + timeSinceLastEvent();
  }
}
int netPaused()  {
  if (paused == true) {
    return netPlayed + timeSinceLastEvent();
  } else {
    return netPlayed;
  }
}
int timeSinceLastEvent() {
  return runTotal() - lastEvent;
}

int prevRunNumber = 0;
int runStart = millis();
int runNumber = 0;

Boolean paused = true;
int lastEvent;
int netPaused;
int netPlayed;

int prevTU;
int prevSecond;
int prevMinute;
int prevHour;

void setupTime() {
  resetTime();
}

void resetTime()  {
  runStart      = millis();
  runNumber++;
  lastEvent     = runStart;
  
  netPaused     = 0;
  netPlayed     = 0;
  
  prevTU        = 0;
  prevSecond    = 0;
  prevMinute    = 0;
  prevHour      = 0;
  
  println("simulation has been RESET");
}

void toggleTimer() {
  if (paused == true) {
    startTimer();
  } else {
    pauseTimer();
  }
}

void pauseTimer() {
  addTime();
  paused = true;
  println("timer has PAUSED");
  //timePanel.playPauseButton.buttonType = "play"; // FIX
  for (int i = 0; i < getMolecules().size(); i++) {
    Molecule currMolecule = (Molecule)getMolecules().get(i);
    currMolecule.pauseMotion();
  }
}
void startTimer() {
  addTime();
  paused = false;
  println("timer has STARTED");
  //timePanel.playPauseButton.buttonType = "pause"; // FIX
  for (int i = 0; i < getMolecules().size(); i++) {
    Molecule currMolecule = (Molecule)getMolecules().get(i);
    currMolecule.unpauseMotion();
  }
}

void addTime() {
  if (paused == true) {
    netPaused = netPaused + timeSinceLastEvent();
  } else if (paused == false) {
    netPlayed = netPlayed + timeSinceLastEvent();
  } else {
    println("paused is NULL... FIX ME");
  }
  lastEvent = runTotal();
}

void updateTime() {
  // don't forget... these will only run if the sim is paused
  if (currentRun()     > prevRunNumber) { fireEveryRun(); }
  if (currentTU()      > prevTU)        { fireEveryTU(); }
  if (currentSecond()  > prevSecond)    { fireEverySecond(); }
  if (currentMinute()  > prevMinute)    { fireEveryMinute(); }
  if (currentHour()    > prevHour)      { fireEveryHour(); }
  updatePrevValues();
}

void fireEveryRun()     {}
void fireEveryTU()      {
  updateRolls();
}
void fireEverySecond()  {}
void fireEveryMinute()  {}
void fireEveryHour()  {}

void updatePrevValues() {
  prevRunNumber = currentRun();
  prevTU     = currentTU();
  prevSecond = currentSecond();
  prevMinute = currentMinute();
  prevHour   = currentHour();
}

int currentRun()    { return runNumber; }
int currentTU()     { return floor(netPlayed()/(1000/countsPerSecond)); }
int currentSecond() { return floor(netPlayed()/1000); }
int currentMinute() { return floor(netPlayed()/(1000*60)); }
int currentHour()   { return floor(netPlayed()/(1000*60*60)); }

String currentTimeFormatted() {
  String timeForm;
  int hourForm  = currentHour();
  int minForm   = floor(currentMinute()%60);
  int secForm   = floor(currentSecond()%60);
  if (hourForm > 0) {
    timeForm = hourForm + ":" + nf(minForm, 2) + ":" + nf(secForm, 2);
  } else {
    timeForm = nf(minForm, 2) + ":" + nf(secForm, 2);
  }
  return timeForm;
}
