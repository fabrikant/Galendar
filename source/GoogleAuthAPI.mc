using Toybox.System;
using Toybox.Communications;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Timer;

class GoogleAuth {

	function initialize(){
	}

	function authorizationPassed(){
		if (Application.Properties.getValue("rKey").equals("")){
			return false;
		} else {
			return true;
		}
	}

	function userCodeRecieved(){
		var result = false;
		if (Application.Storage.getValue(Application.getApp().STOR_KEY_DEVICE_CODE) != null){
			if (Time.now().value() < Application.Storage.getValue(Application.getApp().STOR_KEY_DEVICE_CODE_LIFETIME)){
				result = true;
			}else{
				deleteDeviceCodeFromStorage();
			}
		}
		return result;
	}

	function startAutorization(responseCallbackMetod){
		var clientID = Application.Properties.getValue("ClientID");
		var scope = Application.Properties.getValue("scope");
		var url = "https://accounts.google.com/o/oauth2/device/code";
		var parameters = {
			"client_id" => clientID,
			"scope" => scope
		};

		var options = {
			:method => Communications.HTTP_REQUEST_METHOD_POST,
			:context => responseCallbackMetod
		};

		Communications.makeWebRequest(
			url,
			parameters,
			options,
			method(:onRecieveUserCode)
		);
	}

	function onRecieveUserCode(responseCode, data, responseCallbackMetod){
		if (responseCode == 200){
			var lifeTime = Time.now().add(new Time.Duration(data["expires_in"]-10));// minus 10 secons
			var app = Application.getApp();
			Application.Storage.setValue(app.STOR_KEY_DEVICE_CODE , data["device_code"]);
			Application.Storage.setValue(app.STOR_KEY_VER_URL , data["verification_url"]);
			Application.Storage.setValue(app.STOR_KEY_USER_CODE , data["user_code"]);
			Application.Storage.setValue(app.STOR_KEY_DEVICE_CODE_LIFETIME , lifeTime.value());
			Application.Storage.setValue(app.STOR_KEY_DEVICE_CODE_INTERVAL , data["interval"]);
			responseCallbackMetod.invoke();
			startTimerCheckUserCode();
		}
	}

	private function deleteDeviceCodeFromStorage(){
		var app = Application.getApp();
		Application.Storage.deleteValue(app.STOR_KEY_DEVICE_CODE);
		Application.Storage.deleteValue(app.STOR_KEY_VER_URL);
		Application.Storage.deleteValue(app.STOR_KEY_USER_CODE);
		Application.Storage.deleteValue(app.STOR_KEY_DEVICE_CODE_LIFETIME);
		Application.Storage.deleteValue(app.STOR_KEY_DEVICE_CODE_INTERVAL);
	}

	private function startTimerCheckUserCode(){
		if (userCodeRecieved()){
			var app = Application.getApp();
			var interval = Application.Storage.getValue(app.STOR_KEY_DEVICE_CODE_INTERVAL) * 1000;
			var timer = new Timer.Timer();
			timer.start(method(:onTimerCheckUserCode), interval, false);
		}
	}

	function onTimerCheckUserCode(){
		var app = Application.getApp();
		var url = "https://oauth2.googleapis.com/token";
		var clientID = Application.Properties.getValue("ClientID");
		var ClientKey = Application.Properties.getValue("ClientKey");
		var deviceCode = Application.Storage.getValue(app.STOR_KEY_DEVICE_CODE);

		var parameters = {
			"client_id" => clientID,
			"client_secret" => ClientKey,
			"code" => deviceCode,
			"grant_type" => "http://oauth.net/grant_type/device/1.0"
		};

		var options = {
			:method => Communications.HTTP_REQUEST_METHOD_POST
		};

		Communications.makeWebRequest(
			url,
			parameters,
			options,
			method(:onCheckUserCode)
		);
	}

	function onCheckUserCode(responseCode, data){
		if (responseCode == 200){
			if (data["access_token"] != null){
				System.println("qKey"+ data["access_token"]);
				System.println("rKey"+ data["refresh_token"]);
				Application.Properties.setValue("qKey", data["access_token"]);
				Application.Properties.setValue("rKey", data["refresh_token"]);
				deleteDeviceCodeFromStorage();
			}else{
				startTimerCheckUserCode();
			}
		}else{
			startTimerCheckUserCode();
		}
	}
}