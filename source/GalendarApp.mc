using Toybox.Application;
using Toybox.Communications;

class GalendarApp extends Application.AppBase {

	enum{
		STOR_KEY_DEVICE_CODE,
		STOR_KEY_VER_URL,
		STOR_KEY_USER_CODE,
		STOR_KEY_DEVICE_CODE_LIFETIME,
		STOR_KEY_DEVICE_CODE_INTERVAL
	}

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {

    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new GalendarView() ];
    }


}