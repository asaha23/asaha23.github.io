public class Monitor extends Region{
  // variables
    int       monitorID;
    String    monitorType;   // e.g. "molecule", "pH"
    
    // display variables
    color   fillColor = cFill_Monitor;
    color   strokeColor = cStrk_Monitor;
    
    // label variables
    color   labelColor;
    float   labelX1;
    float   labelY1;
    float   labelX2;
    float   labelY2;
    
    String  timeElapsedMMSS;
    
    // monitor variables
    
    float sectionQnty;    // 
    float sectionDuration;  // number of seconds it takes to cross from left to right of a monitor Section
    float sectionDurationTUs;
    float monitorDuration;
    float monitorDurationTUs;
    
    int yTicks = 50; // starting number of ticks along Y axis
    int yIncrement = 10; // increments for Molecules monitor

    float sectionW;  // LENGTH measure; defaults to distance covered in a minute
    float xTicksPerSection;
    float xTicksTotal;  // number of ticks along X axis

    float xTick; 
    float yTick;

    float currentX;
      // also need to check whether any species count exceeds yTicksTotal; if so, increase yTicksTotal
      // yTicksTotal = whatever is greater: 50 or the largest molecule species count
    
    float labelOffset;
    float textLocTY;
    float textLocRX;
    float textLocBY;
    float textLocLX;
    
    String textCrosshairR;
    String textCrosshairB;
    
    String textTL; 
    String textTC; 
    String textTR; 
    String textRT; 
    String textRC; 
    String textRB; 
    String textBL; 
    String textBC; 
    String textBR; 
    String textLT; 
    String textLC; 
    String textLB;
    
    float rightBoxX;
    float rightBoxW;
    float rightBoxH;
    float rightBoxY;

    float bottomBoxY;
    float bottomBoxW;
    float bottomBoxH;
    float bottomBoxX;

    float yMolQnty;
    float xSeconds;

    String yMolQntyFormatted;
    String xMinutesFormatted;
    String xSecondsFormatted;
    String xFormatted;
    
  // constructor
  public Monitor() {
    init();
  }
  
  public Monitor(String monitorType_) {
    monitorType = monitorType_;
    init();
  }

  // constructor
  public Monitor(String monitorType_, float x_, float y_, float w_, float h_) {
    super(x_, y_, w_, h_);
    monitorType = monitorType_;
    init();
  };
  
  void setType(String monitorType_) {
    monitorType = monitorType_;
  }
  
  void init() {
    super.init();
    
    cFill = fillColor;
    setLabels();
    sectionDuration = 60;  // number of seconds it takes to cross from left to right of a monitor Section
    sectionDurationTUs = sectionDuration * countsPerSecond;
  }
  
  void setLabels() {
    labelOffset = mod/6;
    textFont(fontMyriadPro10, 10);
    labelColor = cFill_Label;
    textLocTY = y() - mod/2;
    textLocRX = y() + w() + mod/2;
    textLocBY = y() + h() + mod/2;
    textLocLX = x() - mod/2;
    
    textCrosshairR = "";
    textCrosshairB = "";
    textTL = ""; 
    textTC = ""; 
    textTR = ""; 
    textRT = ""; 
    textRC = ""; 
    textRB = ""; 
    textBL = ""; 
    textBC = ""; 
    textBR = ""; 
    textLT = ""; 
    textLC = ""; 
    textLB = "";
  }

  void update() {
    super.update();
    sectionQnty         = currentMinute() + 1;
    monitorDuration     = sectionQnty * sectionDuration;
    monitorDurationTUs  = monitorDuration * countsPerSecond;
    sectionW            = w() / sectionQnty;  // LENGTH measure; defaults to distance covered in a minute
    xTicksPerSection    = sectionDurationTUs;
    xTicksTotal         = sectionQnty * xTicksPerSection;
    xTick               = w() / getXTicks(); 
    yTick               = h() / getYTicks();
    currentX            = xTick * currentTU();
    
    // WHEN REIMPLEMENTING THESE, USE VARIABLES SET EACH SECOND
    
    // override default labelling
    if (monitorType == "molecule monitor") {
      textCrosshairR = yMolQntyFormatted;
      textCrosshairB = xFormatted;
      
      textTL = "Molecule Count: " + str(countMolecules());
      textTC = "";
      textTR = "";
      textRT = "";
      textRC = "";
      textRB = "";
      textBL = "Start";
      textBC = "Time";
      textBR = floor(sectionQnty) + " mins";
      textLT = str(floor(getYTicks()));
      textLC = "# of molecules";
      textLB = str(0);
    } else if (monitorType == "ph monitor") {
      textCrosshairR = nf(14 * mouseYLocalNorm(), 0, 1);
      textCrosshairB = xFormatted;
      
      textTL = "pH: " + nf(getPH(), 0, 2);
      textTC = "";
      textTR = "";
      textRT = "";
      textRC = "";
      textRB = "";
      textBL = "Start";
      textBC = "Time";
      textBR = floor(sectionQnty) + " mins";
      textLT = str(14);
      textLC = "pH Level";
      textLB = str(0);

    }
  }
  
  void display() {
    super.display();
    drawGrid();
    drawMonitorLines();
    //drawHead();
    drawStroke(); // stroke and labels should be drawn after visualization
    drawLabels();
    drawCrosshairs();
  }
  
  
  float getXTicks() {
    return xTicksTotal;
  }
  
  float getYTicks() {
    int ticks = countMostAbundantSpecies();
    if (yTicks > ticks) {
      return yTicks;
    } else {
      yTicks = ticks;
      return ticks;
    }
  }


/*----------------------------------------------------------------------------*/
// box

  
  void drawGrid() {
    pushStyle();
    stroke(85);
    pushMatrix();
      translate(x(), y());
      for (int i = 0; i < sectionQnty; i++) {
        line(xTicksPerSection * xTick * i, 0, xTicksPerSection * xTick * i, h());
      }
      if (monitorType.equals("molecule monitor")) {
        int i = 0;
        while (yIncrement * i < yTicks) {
          line(0, h() - (yIncrement * i * yTick), w(), h() - (yIncrement * i * yTick));
          i++;
        }
      }
      if (monitorType.equals("ph monitor")) {
        line(0, h()/2, w(), h()/2);
      }
    popMatrix();
    popStyle();
  }
  
  void drawMonitorLines() {
    // the following variable allows a monitor with decreased resolution to only render certain modulo of available data
    int skip = floor(sectionQnty);
    
    pushMatrix();
    translate(x(), y());
    pushStyle();
    
    if (monitorType.equals("molecule monitor")) {
      float xValue = 0;
      float yValue = h();
      int speciesQnty = countSpecies();
      
      float[] prevX = new float[speciesQnty];
      float[] prevY = new float[speciesQnty];

      // init previous location array
      for (int i = 0; i < prevX.length; i++) {
        prevX[i] = 0;
        prevY[i] = h();
      }

      int[] countAtTimeX = new int[species.size()];
      for (int i = 1; i < speciesRoll.size(); i=i+skip) {
        
        for (int j = 0; j < species.size(); j++) {
          String specName = (String)speciesNamesInOrder.get(j);
          countAtTimeX[j] = countMoleculesPast(specName, (i-1));
        }

        for (int ii = 0; ii < speciesQnty; ii++) {
          stroke(cMonitor[ii]);
          strokeWeight(1.5);

          xValue = i * xTick;
          yValue = h() - (countAtTimeX[ii] * yTick);

          line(xValue, yValue, prevX[ii], prevY[ii]);

          prevX[ii] = xValue;
          prevY[ii] = yValue;
        }
      }
    } else if (monitorType.equals("ph monitor")) {
      
      // pH Monitor
      float xValue = 0;
      float yValue = h();
      float prevX = 0;
      float prevY = h();

      float   pHval;

      for (int i = 1; i < pHRoll.size(); i=i+skip) {
        pHval = (Float)pHRoll.get(i-1);
        stroke(255);
        strokeWeight(1.5);

        xValue = i * xTick;
        yValue = h() - map(pHval, 0, 14, 0, h());

        line(xValue, yValue, prevX, prevY);

        prevX = xValue;
        prevY = yValue;
      }
    }
    popStyle();
    popMatrix();
  }
  
  void drawCrosshairs() {
    
    pushStyle();
    stroke(127);
    pushMatrix();
    
    translate(x, y);
      if (getState() == "over" || getState() == "active" ) {
        // horizontal line
        line(0, mouseYLocal(), w(), mouseYLocal());
        // vertical line
        line(mouseXLocal(), 0, mouseXLocal(), h());
        
        // labels
        fill(0, 150);
        rightBoxX = 0;
        rightBoxW = mod * 5/8;
        rightBoxH = mod/2;
        rightBoxY = mouseYLocal() - rightBoxH/2;
        
        bottomBoxY = 0;
        bottomBoxW = mod*5/8;
        bottomBoxH = mod/2;
        bottomBoxX = mouseXLocal() - rightBoxW/2;
        
        yMolQnty = getYTicks() * mouseYLocalNorm();
        
        xSeconds = sectionDuration * sectionQnty * mouseXLocalNorm();
        
        yMolQntyFormatted = str(round(yMolQnty));
        xMinutesFormatted = nf(round(xSeconds) / 60, 2);
        xSecondsFormatted = nf(round(xSeconds) % 60, 2);
        xFormatted = xMinutesFormatted + ":" + xSecondsFormatted;
        
        pushMatrix();
        translate(w(), 0);
          rect(rightBoxX, rightBoxY, rightBoxW, rightBoxH);
          textAlign(CENTER);
          pushStyle();
            try {
              fill(cText);
              text(textCrosshairR, rightBoxX + rightBoxW/2, rightBoxY + rightBoxH/2 + mod/12);
            } catch (Exception e) {}
          popStyle();
        popMatrix();
        
        pushMatrix();
        translate(0, h());
          rect(bottomBoxX, bottomBoxY, bottomBoxW, bottomBoxH);
          textAlign(CENTER);
          pushStyle();
            try {
              fill(cText);
              text(textCrosshairB, bottomBoxX + bottomBoxW/2, bottomBoxY + bottomBoxH/2 + mod/12);
            } catch (Exception e) {}
          popStyle();
        popMatrix();
      }
    popMatrix();
    popStyle();
  }
  
  void drawStroke() {
    pushStyle();
      noFill();
      /*// frame, to mask a little of line overlap
      stroke(cFill_Bg);
      strokeWeight(3);
      rect(x - 2, y - 2, w + 4, h + 4);*/
      stroke(strokeColor);
      strokeWeight(1);
      rect(x(), y(), w(), h());
    popStyle();
  }

/*----------------------------------------------------------------------------*/
// labels
  void drawLabels() {
    
    pushStyle();
    fill(cText);
    // top text
    pushStyle();
      textFont(fontMyriadProBold12, 12);
      textAlign(LEFT);
      text(textTL, x(), y() - labelOffset);
    popStyle();
    textAlign(CENTER);
    text(textTC, x() + w()/2, y() - labelOffset);
    textAlign(RIGHT);
    text(textTR, x() + w(), y() - labelOffset);
    
    // right text
    textAlign(LEFT);
    text(textRT, x() + w() + labelOffset, y() + labelOffset);
    pushMatrix();
      textAlign(CENTER);
      translate(x() + w() + labelOffset, y() + h()/2);
      rotate(PI/2);
      text(textRC, 0, 0);
    popMatrix();
    textAlign(LEFT);
    text(textRB, x() + w() + labelOffset, y() + h());
    
    // bottom text
    textAlign(LEFT);
    text(textBL, x(), y() + h() + labelOffset + labelOffset);
    textAlign(CENTER);
    text(textBC, x() + w()/2, y() + h() + labelOffset + labelOffset);
    textAlign(RIGHT);
    text(textBR, x() + w(), y() + h() + labelOffset + labelOffset);
    
    // left text
    textAlign(RIGHT);
    text(textLT, x() - labelOffset, y() + labelOffset);
    pushMatrix();
      textAlign(CENTER);
      translate(x() - labelOffset, y() + h()/2);
      rotate(PI/2*-1);
      text(textLC, 0, 0);
    popMatrix();
    textAlign(RIGHT);
    text(textLB, x() - labelOffset, y() + h());
    
    popStyle();
  };
};
