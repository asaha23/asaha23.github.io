public class Region {
  int     id;
  Region  parent;
	boolean hidden = false;

	boolean showLabel = false;
	String 	label;
	PFont labelFont;
	float labelX;
	float labelY;
	
	void setLabelX(float input) {
		labelX = input;
	}
	void setLabelY(float input) {
		labelY = input;
	}
	float getLabelX() {
		return labelX;
	}
	float getLabelY() {
		return labelY + mod/4;
	};
	
	void setLabel(String input) {
		showLabel = true;
		label = input;
	}
	
	void setLabel(boolean input) {
		showLabel = input;
	}
	
	void setLabelFont(PFont input) {
		labelFont = input;
	};
	
	String getLabel() {
		return label;
	}

	// occasionally, a region must be associated with a particular piece of content; this string is for storage.
	String content;

  boolean scrollBars;
  
  // absolute variables
  float x = 0;
  float y = 0;
  float w = 0;
  float h = 0;
  float r;    // right
  float b;    // bottom
  float mx;   // middle, x coord
  float my;   // middle, y coord
  float relX; // these variables are generated at runtime based on margin plus absolute
  float relY; // variables.
  float relW;
  float relH;
  float relR;
  float relB;
  
  boolean hasFill; // by default, regions have no background
  boolean hasStrk; // by default, regions have no outline
  color   cFill;
  color   cStrk = color(0);
  
  PImage  wallpaper;
  int     wallpaperDarkness;
  
  float   margin = 0;
  float   marginTop    = margin;
  float   marginRight  = margin;
  float   marginBottom = margin;
  float   marginLeft   = margin;
  
  float   padding = 0; 
  float   paddingTop    = padding;
  float   paddingRight  = padding;
  float   paddingBottom = padding;
  float   paddingLeft   = padding;
  
  String corners = "";
  float  cornerRadius = mod/8;
  
  public Region(Region parent_) {
		parent = parent_;
    x = parent.x();
    y = parent.y();
    w = parent.w();
    h = parent.h();
    setDimensions();
		setLabel("Region Default");
		labelFont = fontMyriadPro12;
  }
  
  // constructor
  public Region(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    setDimensions();
		labelFont = fontMyriadPro12;
		//setLabel("Region Default");
  }
  
  public Region() {
    setDimensions();
		labelFont = fontMyriadPro12;
		//setLabel("Region Default");
  }

  void update() {
    setDimensions();

  }
  void display() {
		displayBg();
		displayLabel();
  }
  
  void setParent(Region region) {
    parent = region;
  }
  
  void setDimensions(float x_, float y_, float w_, float h_) {
    setX(x_);
    setY(y_);
    setW(w_);
    setH(h_);
    setDimensions();
  }

	void kill() {
		allRegions.remove(this);
	};

	float storedX;
	float storedY;
	float storedW;
	float storedH;
	void hide() {
		hidden = true;
		storedX = x();
		storedY = y();
		storedW = w();
		storedH = h();
		setDimensions(width, height, 0, 0);
	}
	void unHide() {
		hidden = false;
		setX(storedX);
		setY(storedY);
		setW(storedW);
		setH(storedH);
		setDimensions();
	}
  
  void setDimensions() {
    setR();
    setB();
    setMX();
    setMY();
    setRelX();
    setRelY();
    setRelW();
    setRelH();
    setRelR();
    setRelB();
  }
  
  void setR()     {r  = x() + w();}
  void setB()     {b  = y() + h();}
  void setMX()    {mx = x() + w()/2;}
  void setMY()    {my = y() + h()/2;}
  void setRelX()  {relX = x() + marginLeft;} 
  void setRelY()  {relY = y() + marginTop;}
  void setRelW()  {relW = w() - (marginLeft + marginRight);}
  void setRelH()  {relH = h() - (marginTop + marginBottom);}
  void setRelR()  {relR = r() - marginRight;}
  void setRelB()  {relB = b() - marginBottom;}

  void setX(float xInput) { x = xInput; }
  void setY(float yInput) { y = yInput; }
  void setW(float wInput) { w = wInput; }
  void setH(float hInput) { h = hInput; }
  void setR(float rInput) {
    float prevR = r();
    setR(rInput);
    float diff = prevR - r();
    setW(w() - diff);
  }
  void setB(float bInput) {
    float prevB = b();
    setB(bInput);
    float diff = prevB - b();
    setH(h() - diff);
  }

  float x()     				{return x; }
  float y()     				{return y; }
  float w()     				{return w; }
  float h()     				{return h; }
  float r()     				{return r; }
  float b()     				{return b; }
  float mx()    				{return mx;}
  float my()    				{return my;}
  float relX()  				{return relX;}
  float relY()  				{return relY;}
  float relW()  				{return relW;}
  float relH()  				{return relH;}
  float relR()  				{return relR;}
  float relB()  				{return relB;}
  float cornerRadius() 	{return cornerRadius; }
	
  
  void scrollBars() {}
  
  boolean mouseOver() {
    if (mouseX > x() && mouseY > y() && mouseX < r() && mouseY < b()) {
      return true;
    }
    return false;
  }
  
  float mouseXLocal() {
    return mouseX - x();
  };
  float mouseYLocal() {
    return mouseY - y();
  };
  
  float mouseXLocalNorm() {
    return norm(mouseX - x(), 0, w());
  }
  
  float mouseYLocalNorm() {
    return norm(mouseY - y(), h(), 0);
  }
  
  String getState() {
    String state;
    if (mouseOver() && mousePressed == true) {
        state = "active";
    } else if (mouseOver()) {
        state = "over";
    } else {
      state = "up";
    }
    return state;
  }

	void displayLabel() {
		if (showLabel == true) {
			pushStyle();
				fill(255);
				textFont(labelFont);
	    	text(label, x() + getLabelX(), y() + getLabelY());
	   	popStyle();
		} 
	}

  void displayBg() {
    pushMatrix();
    translate(x(), y());
    pushStyle();
      if (cFill == 0) 				{ noFill(); }
      else                    { fill(cFill);}
      if (cStrk == 0)					{ noStroke(); }
      else                    { stroke(cStrk);}
			
      if (corners.equals("rounded"))  { roundRect(0,0,w(), h(), cornerRadius()); }
      else                            { rect(		  0,0,w(), h()); }
    popStyle();
    popMatrix();
    if (wallpaper != null) {
      displayWallpaper();
    }
  }

	void setFill(color input) { cFill = input; }
	void setStrk(color input) { cStrk = input; }
	void removeFill() { cFill = 0; }
	void removeStrk() { cStrk = 0; }
	

	void wallpaper(String imagePath, int darkness) {
  	PImage img = loadImage(imagePath);
  	wallpaper = img;
  	wallpaperDarkness = darkness;
	}

	void displayWallpaper() {
	  pushStyle();
	    noStroke();
	    float imageW = wallpaper.width; 
	    float imageH = wallpaper.height;
  
	    int imageQntyHoriz = ceil(w() / imageW);
	    int imageQntyVert = ceil(h() / imageH);
  
	    for (int i = 0; i < imageQntyHoriz; i++) {
	      for (int j = 0; j < imageQntyVert; j++) {
	        float imageX = x() + (i * imageW);
	        float imageY = y() + (j * imageH);
	        image(wallpaper, imageX, imageY);
	      }
	    }
	    fill(color(0, wallpaperDarkness));
	    rect(x(), y(), w(), h());
	  popStyle();
	}
  
  void setMargin(float input) {
    margin = input;
    setMarginTop(input);
    setMarginRight(input);
    setMarginBottom(input);
    setMarginLeft(input);
  }
  
  void setMarginTop(float input)     { marginTop = input;}
  void setMarginRight(float input)   { marginRight = input;}
  void setMarginBottom(float input)  { marginBottom = input;}
  void setMarginLeft(float input)    { marginLeft = input;}
  
  void setPadding(float input) {
    padding = input;
    setPaddingTop(input);
    setPaddingRight(input);
    setPaddingBottom(input);
    setPaddingLeft(input);
  }
  
  void setPaddingTop(float input)     { paddingTop = input;}
  void setPaddingRight(float input)   { paddingRight = input;}
  void setPaddingBottom(float input)  { paddingBottom = input;}
  void setPaddingLeft(float input)    { paddingLeft = input;}
  
  void setCorners(String input) {
    corners = input;
  }
}