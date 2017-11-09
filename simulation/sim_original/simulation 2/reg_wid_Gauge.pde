public class Gauge extends Widget {
  
  Gauge() {
		setLabel("Gauge Default");
  }
  
  Gauge(String type_) {
    type = type_;
		setLabel("Gauge Default");
  }
  void update() {
    //super.update();
  }
  
  void display() {
    //super.display();
		displayBg();
		displayLabel();
  }
}