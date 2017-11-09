public class Widget extends Region {
  String type = "";
  
  Widget() {
		//setLabel("Widget Default");
		//if (!allWidgets.contains(this)) {
			allWidgets.add(this);
		//}
		setStrk(color(0, 0, 255));
		setFill(color(0, 0, 127, 127));
  }
  
  Widget(String type_) {
    type = type_;
		//setLabel("Widget Default");
		//if (!allWidgets.contains(this)) {
			allWidgets.add(this);
		//}
		setStrk(color(0, 0, 255));
		setFill(color(0, 0, 127, 127));
  }
  
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