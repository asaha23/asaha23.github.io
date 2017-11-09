public class ListPanel extends Panel {
  //String type = ""; // either "list" or "tabs"... redundant to Panel class
  ArrayList contentArray;
  
  // variables for list or tabs
  float spacer = mod/8;
  
  // variables for list
  float listItemH = mod * 5/8;
  
  // variables for tabs
  int currentTab = 0;
  float tabH = mod/2;
  float tabW = mod * 15/16;
  
  ListPanel(String type_, ArrayList contentArray_ /*arraylist of widgets!*/) {
    type = type_;
		contentArray = new ArrayList();
    contentArray = contentArray_;
		start();
  }

	void kill() {
		for (int i = 0; i<contentArray.size(); i++) {
			Widget widget = (Widget)contentArray.get(i);
			widget.kill();
		}
		contentArray.clear();
		super.kill();
	}

	void start() {}
  
  void update() {}
  
  void display() {}
  
  void setContent(ArrayList input) { contentArray = input; }

  ArrayList getContent() { return contentArray; }

  void tab(int rank) {}

	void beginLegend() {}

	void updateLegend() {}

  void displaycontentArray() {}
  
  float bottomButtonB() {
    float result = 0;
    if (type.equals("legend")) {
      Button button = (Button)contentArray.get(contentArray.size()-1);
      result = button.b();
    }
    return result;
	}
  
  void setButtonQnty() {}
}