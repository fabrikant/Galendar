using Toybox.WatchUi;
using Toybox.System;

// This is the menu input delegate for the main menu of the application
class TimetableDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
    	System.println("select "+item.getId());
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
