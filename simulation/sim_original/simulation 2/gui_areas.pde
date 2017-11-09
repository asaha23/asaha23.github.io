float   horiz1;
float   horiz2;
float   vert1;
float   vert2;

float   horiz1prev;
float   horiz2prev;
float   vert1prev;
float   vert2prev;

Region  headerArea;
Region  footerArea;
Region  leftSidebarArea;
Region  rightSidebarArea;
Region  canvasArea;
//Region  floaterArea;


color panelBg = color(127);

void initAreas() {
  horiz1            = headerH;  // header and footer do not yet exist, although I want to make amends for them
  horiz2            = height - footerH;  // header and footer do not yet exist, although I want to make amends for them
  vert1             = sidebarLeftW;
  vert2             = width - sidebarRightW;
  
  headerArea        = new Region(0, 0, width, horiz1);  // header and footer do not yet exist
  footerArea        = new Region(0, horiz2, width, height - horiz2);  // header and footer do not yet exist
  leftSidebarArea   = new Region(0, horiz1, vert1, height - headerArea.h - footerArea.h);
  rightSidebarArea  = new Region(vert2, horiz1, width - vert2, height - headerArea.h - footerArea.h);
  canvasArea        = new Region(vert1, horiz1, width - leftSidebarArea.w - rightSidebarArea.w, height - headerArea.h - footerArea.h);
  //floaterArea       = new Region(0, 0, width, height);
  
  horiz1prev        = horiz1;
  horiz2prev        = horiz2;
  vert1prev         = vert1;
  vert2prev         = vert2;

	allAreas.add(canvasArea);
	allAreas.add(headerArea);
	allAreas.add(leftSidebarArea);
	allAreas.add(rightSidebarArea);
	allAreas.add(footerArea);
	//allAreas.add(floaterArea);
	

	canvasArea.wallpaper("data/wallpaper/water-050.png", 190);
}
void updateAreas() {
  horiz1            = headerArea.h();  // header and footer do not yet exist, although I want to make amends for them
  horiz2            = height - footerArea.h();  // header and footer do not yet exist, although I want to make amends for them
  vert1             = leftSidebarArea.w();
  vert2             = width - rightSidebarArea.w();
  
  headerArea.setDimensions(0, 0, width, horiz1);  // header and footer do not yet exist
  footerArea.setDimensions(0, horiz2, width, height - horiz2);  // header and footer do not yet exist
  leftSidebarArea.setDimensions(0, horiz1, vert1, height - headerArea.h - footerArea.h);
  rightSidebarArea.setDimensions(vert2, horiz1, width - vert2, height - headerArea.h - footerArea.h);
  canvasArea.setDimensions(vert1, horiz1, width - leftSidebarArea.w - rightSidebarArea.w, height - headerArea.h - footerArea.h);
  //floaterArea.setDimensions(0, 0, width, height);
  
  //if (leftPanels.size() == 0)   { leftSidebarArea.setW(0);}
  //if (rightPanels.size() == 0)  { rightSidebarArea.setW(0);}
  //if (headerPanels.size() == 0) { headerArea.setH(0);}
  //if (footerPanels.size() == 0) { footerArea.setH(0);}

	canvasArea.setFill(cFill_Canvas);
	headerArea.setFill(cFill_Area);
	footerArea.setFill(cFill_Area);
	leftSidebarArea.setFill(cFill_Area);
  rightSidebarArea.setFill(cFill_Area);

	for (int i = 0; i<allAreas.size(); i++) {
		Region area = (Region)allAreas.get(i);
		area.update();
	}
}
void displayAreas() {
	for (int i = 0; i<allAreas.size(); i++) {
		Region area = (Region)allAreas.get(i);
		area.display();
	}
}