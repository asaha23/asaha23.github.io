public class LayoutPanel extends Panel {
  String type = "";
  Widget content;
  
  LayoutPanel() {
		setLabel("SinglePanel Default");
  }

  LayoutPanel(String label_, Widget content_) {
    setLabel(label_);
    content = content_;
		//setLabel("SinglePanel Default");
  }
  
  void update() {
		setDimensions();
		updateTitlebar();
		content.setDimensions(contentX(), contentY(), contentW(), contentH());
    content.update();
  }

	void kill() {
		super.kill();
		content.kill();
	}
  
  void display() {
		super.display();
		content.display();
		displayLabel();
	}
	
	Widget getContent() {
		return content;
	}
	
	void setContent(Widget input) {
		content = input;
	}
	  
  void setContentH(float input) {
		contentH = input;
	}
	
}