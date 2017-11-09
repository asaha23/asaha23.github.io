public class PanelContent extends Region {
  
  String    type  = "tab";  // "list" or "tabs";
  String    title;
  Button    tabButton;
  int       rank;
  boolean   active;
  
  float hz1;
  float hz2;
  float hz3;
  float vt1;
  float vt2;
  float vt3;
  float vt4;
  
  float tabH = mod/2;
  float tabW = mod * 15/16;
  float tabInterval = mod/16;
  
  // constructors
  PanelContent(String type_, Region parent_) {
    type = type_;
    parent = parent_;
    init();
  }
  
  // methods
  void init() {
    super.init();
    tabButton = new Button();
    tabButton.setParent(this);
    tabButton.setAction("activateTab");
  }
  void update() {
    super.update();
    hz1 = y();
    hz2 = y() + tabH;
    hz3 = b();
    vt1 = x();
    vt2 = x() + (tabW * rank) + tabInterval;
    vt3 = vt2 + tabW - tabInterval * 2;
    vt4 = r();
    tabButton.update();
    tabButton.setFill(false);
    tabButton.setStrk(false);
    tabButton.setDimensions(vt2, hz1, tabW - tabInterval * 2, tabH);
  }
  
  
  void setTabW(float tabW_) {
    tabW = tabW_;
  }
  
  void setRank(int rank_) {
    rank = rank_;
  }
  
  void activate() {
    active = true;
  }
  
  void deactivate() {
    active = false;
  }
  
  void display() {
    super.display();
    
    float vertex1;
    
    if (type.equals("tab")) {
      pushStyle();
        if (active) {
          fill(cFill_TabActive);
          stroke(cStrk_TabActive);
        }
        else        {
          fill(cFill_TabInactive);
          stroke(cStrk_TabInactive);
        }
        beginShape();
          vertex(vt1, hz2); // 1
          vertex(vt2, hz2); // 2
          vertex(vt2, hz1); // 3
          vertex(vt3, hz1); // 4
          vertex(vt3, hz2); // 5
          vertex(vt4, hz2); // 6
          vertex(vt4, hz3); // 7
          vertex(vt1, hz3); // 8
        endShape();
      popStyle();
      tabButton.display();
    } else if (type.equals("list")) {
      pushStyle();
        fill(color(127, 0, 0));
        rect(vt1, hz1, w(), h());
      popStyle();
    }
  }
}
