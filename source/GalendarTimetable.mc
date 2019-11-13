using Toybox.WatchUi;

class Timetable extends WatchUi.Menu2 {

	function initialize(options){
		Menu2.initialize(options);
	}

	function loadItems(){

	    // Add menu items for demonstrating toggles, checkbox and icon menu items
	    addItem(new WatchUi.MenuItem("Toggles", "sublabel", "toggle", null));
	    addItem(new WatchUi.MenuItem("Checkboxes", null, "check", null));
	    addItem(new WatchUi.MenuItem("Icons", null, "icon", null));
	    addItem(new WatchUi.MenuItem("Custom", null, "custom", null));

	}
}