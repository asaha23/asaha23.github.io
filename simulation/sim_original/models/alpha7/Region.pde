public class Region {
  
  int     id;
  color   cBg = color(255);
  Region  parent;

  boolean scrollBars;
  boolean hasFill = false;
  boolean hasStrk = false;
  
  // variables
  float x = 0;
  float y = 0;
  float w = 0;
  float h = 0;
  float mx; // middle, x coord
  float my; // middle, y coord
  float r; // right
  float b; // bottom
  
  color cFill;
  color cStrk;
  
  // constructor
  public Region(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    setDimensions();
  }
  
  public Region() {
    setDimensions();
  }
  
  void setParent(Region r) {
    parent = r;
  }
  
  void setDimensions() {
    mx = x + w/2;
    my = y + h/2;
    r = x + w;
    b = y + h;
  }
  
  void setDimensions(float x_, float y_, float w_, float h_) {
    setX(x_);
    setY(y_);
    setW(w_);
    setH(h_);
  }
  
  void setX(float xInput) { x = xInput; setDimensions(); }
  void setY(float yInput) { y = yInput; setDimensions(); }
  void setW(float wInput) { w = wInput; setDimensions(); }
  void setH(float hInput) { h = hInput; setDimensions(); }
  void setB(float bInput) {
    float prevB = b;
    b = bInput;
    float diff = prevB - b;
    h = h - diff;
    setDimensions();
  }
  void setR(float rInput) {
    float prevR = r;
    r = rInput;
    float diff = prevR - r;
    w = w - diff;
    setDimensions();
  }
  
  float getX() {return x; }
  float getY() {return y; }
  float getW() {return w; }
  float getH() {return h; }
  float getR() {return r; }
  float getB() {return b; }
  
  float x() {return getX();}
  float y() {return getY();}
  float w() {return getW();}
  float h() {return getH();}
  float r() {return getR();}
  float b() {return getB();}
  
  
  void init() {
      cFill = color(127);
      cStrk = color(63);
  }
  void update() {}
  void display() {
    pushStyle();
      noFill();
      noStroke();
      if (hasFill == true) {fill(cFill);}
      if (hasStrk == true) {stroke(cStrk);}
      rect(x(), y(), w(), h());
    popStyle();
  }
  
  void setFill(boolean bool) {
    if (bool == true) { hasFill = true; }
    if (bool != true) { hasFill = false; }
  }
  void setFill(color col) {
    setFill(true);
    cFill = col;
  }
  
  void setStrk(boolean bool) {
    if (bool == true) { hasStrk = true; }
    if (bool != true) { hasStrk = false; }}
  void setStrk(color col) {
    setFill(true);
    cStrk = col;
  }
  
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
}