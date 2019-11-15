using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;


class GalendarView extends WatchUi.View {

	var googleAuth;

    function initialize() {
        View.initialize();
        googleAuth = new GoogleAuth();
    }

    // Load your resources here
    function onLayout(dc) {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {

    	if (googleAuth.authorizationPassed()){
	        var timetable = new Timetable({:title=>Rez.Strings.Title});
			timetable.loadItems();
	        WatchUi.pushView(timetable, new TimetableDelegate(), WatchUi.SLIDE_UP );
        }else{
        	googleAuth.startAutorization(method(:onRecieveAuthEvent));
        }

    }

	function onRecieveAuthEvent(){
		if (googleAuth.authorizationPassed()){
			//Направить запрос на события календаря
			System.println("authorizationPassed");
		}else if (googleAuth.userCodeRecieved()){
			var app = Application.getApp();
			var url = Application.Storage.getValue(app.STOR_KEY_VER_URL);
			var userCode = Application.Storage.getValue(app.STOR_KEY_USER_CODE);
			System.println(userCode);
			Communications.openWebPage(url, {}, {});
		}
	}

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}








