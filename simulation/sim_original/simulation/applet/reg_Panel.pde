public class Panel extends Region {
  String type = "";
  
  int rank = 0;
  
  Region    titlebar;
  boolean   showTitlebar = true;
  
  Button    collapseButton;
  boolean   collapsed = false;
  boolean   displayContent = true;
  
  float 		defaultPanelW = mod * 2;
  float 		defaultPanelH = mod * 2;
  
  float 		titlebarH = mod/3;
  float 		contentW = mod * 2;
  float 		contentH = mod * 2;
  
  Panel() {
		//if (!allPanels.contains(this)) {
    	allPanels.add(this);
		//}
		setLabel("Panel Default");
    titlebar = new Region();
    titlebar.setFill(cFill_Titlebar);
    titlebar.setStrk(cStrk_Titlebar);

		setFill(cFill_Panel);
		setStrk(cStrk_Panel);

		//showLabel(true);
  }

	void display() {
		displayBg();
		displayTitlebar();
	};

  
  void updateTitlebar() {
    if (showTitlebar() == true) {
			titlebar.setDimensions(x(), y(), w(), titlebarH);
    } else {
			titlebar.setDimensions(0, 0, 0, 0);
    }
    titlebar.update();
  }
  
  void displayTitlebar() {
    //super.display();
		displayBg();
    if (showTitlebar() == true) {
			titlebar.display();
		}
		displayLabel();
  }
  
  int getRank() {
    return rank;
  }

  
  float x() {
    float tmpX = 0;
    if (parent == leftSidebarArea || parent == rightSidebarArea) {
      tmpX = parent.x();
    } else if (parent == headerArea || parent == footerArea) {
      if (rank == 0) {
        tmpX = parent.x();
      } else { tmpX = getYoungerSibling().r(); }
    }
    return tmpX;
  }
  float y() {
    float tmpY = 0;
    if (parent == headerArea || parent == footerArea) {
      tmpY = parent.y();
    } else if (parent == leftSidebarArea || parent == rightSidebarArea) {
      if (rank == 0) {
        tmpY = parent.y();
      } else { tmpY = getYoungerSibling().b(); }
    }
    return tmpY;
  }
  float w() {
    float tmpW = 0;
    if (parent == leftSidebarArea || parent == rightSidebarArea) {
      tmpW = parent.w();
    } else {
      tmpW = tmpW + contentW() + marginLeft + marginRight + paddingLeft + paddingRight;
    }
    return tmpW;
  }
  float h() {
    float tmpH = 0;
    if (showTitlebar == true) {
      tmpH = titlebar.h();
    }
    if (displayContent == true) {
      if (parent == headerArea || parent == footerArea) {
        tmpH = parent.h();
      } else {
        tmpH = tmpH + contentH() + marginTop + marginBottom + paddingTop + paddingBottom;
      }
    } else {
      if (parent == leftSidebarArea || parent == rightSidebarArea) {
        tmpH = tmpH + marginTop + marginBottom;
      }
    }
    return tmpH;
  }
  
  float contentX() {
    float tmpX = relX() + paddingLeft;
    return tmpX;
  }
  float contentY() {
    float tmpY = relY() + paddingTop;
    if (showTitlebar == true) {
      tmpY = tmpY + titlebar.h();
    }
    return tmpY;
  }
  float contentW() {
    float tmpW = 0;
    if (parent == leftSidebarArea || parent == rightSidebarArea) {
      tmpW = relW() - paddingLeft - paddingRight;
    }
    else { // parent == headerArea || parent == footerArea
      tmpW = contentW;
    }
    return tmpW;
  }
  float contentH() {
    float tmpH = 0;
    if (parent == leftSidebarArea || parent == rightSidebarArea) {
      tmpH = contentH;
    }
    else { // parent == headerArea || parent == footerArea
      tmpH = relH() - titlebar.h() - paddingTop - paddingBottom;
    }
    return tmpH;
  }
  float contentR() {
    float tmpR = 0;
    tmpR = contentX() + contentW();
    return tmpR;
  }
  float contentB() {
    float tmpB = 0;
    tmpB = contentY() + contentH();
    return tmpB;
  }
  
  void setContentW(float input) {
    contentW = input;
  }
  
  void setContentH(float input) {
    contentH = input;
  }
  
  Panel getOlderSibling()   {
    ArrayList siblings = getSiblings();
    if (siblings.size() > 1 && rank <= siblings.size()-2) {
      Panel sibling = (Panel)siblings.get(rank +1);
      return sibling;
    }
    else {return null;}
  }
  Panel getYoungerSibling() {
    ArrayList siblings = getSiblings();
    if (siblings.size() > 1 && rank >= 1) {
      Panel sibling = (Panel)siblings.get(rank -1);
      return sibling;
    }
    else {return null;}
  }
  
  ArrayList getSiblings() {
    if      (parent == headerArea)       { return headerPanels;}
    else if (parent == footerArea)       { return footerPanels;}
    else if (parent == leftSidebarArea)  { return leftPanels;  }
    else if (parent == rightSidebarArea) { return rightPanels; }
    else                                 { return allPanels;}
  }
  
  void showTitlebar(boolean input) {
    if (input == true) { showTitlebar = true;
    } else             { showTitlebar = false; }
  }
  
  boolean showTitlebar() {
    if (showTitlebar == true) { return true;
    } else                    { return false; }
  }
  
  void displayContent(boolean input) {
    if (input == true) { displayContent = true;
    } else             { displayContent = false; }
  }
  
  boolean displayContent() {
    if (displayContent == true) { return true;
    } else                    { return false; }
  }
  
  void setRank(int input) {
    rank = input;
  }
  
  void setType(String input) {
    type = input;
  }
  
  String getType() {
    return type;
  }
}
