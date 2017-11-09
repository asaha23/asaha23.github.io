public class Widget extends Region {
  String type = "";
  
  Widget() {
  	start();
	}
  
  Widget(String type_) {
    type = type_;
		start();
  }

	void kill() {
		super.kill();
		allWidgets.remove(this);
	}
	
	void start() {
		//setLabel("Widget Default");
		//if (!allWidgets.contains(this)) {
			allWidgets.add(this);
		//}
		setStrk(cStrk_Widget);
		setFill(cFill_Widget);
	};
  
  void update() {
    //super.update();
  }
  
  void display() {
    //super.display();
  }
  
  void setType(String input) {
    type = input;
  }
  
  String getType(String input) {
    return type;
  }
}