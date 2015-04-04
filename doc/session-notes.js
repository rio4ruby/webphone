<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>STEP 3 : Create Session and End Session</title>
</head>
<body>
<center><b><summary>STEP 3:Create Session and End Session</summary></b></center><hr>
<BR><b>Pre-Requisite ::
<BR><b>STEP 1 : Obtain Oauth Token
<BR><b>STEP 2: Obtain E911 Id
<BR><BR>
Access Token:&nbsp;<input id="token" type="text" value="" size="40"><br><br>
E911 Id:&nbsp;<input id="xE911Id" type="text" value="" size="40"><br><br><br>
<button id="createSession">&nbsp;Create Session&nbsp;</button>
<button id="deleteSession">&nbsp;Stop Session&nbsp;</button><hr>
<div id="progress"></div>
<div id="event"></div>
<script language="JavaScript">
function log(text){
	document.getElementById('progress').innerHTML = document.getElementById('progress').innerHTML + '<br>' +text;
}
function logEvent(text){
	document.getElementById('event').innerHTML = document.getElementById('event').innerHTML + '<br>' +text;
}
var GW_URL = "https://api.att.com",SERVICE_NAME="RTC",version="v1", REGISTER_RESOURCE = "sessions";
var registerURL = GW_URL + "/" + SERVICE_NAME + "/" + version + "/" + REGISTER_RESOURCE;
//var window.sessionId="";
createSession.onclick = function(){
var accessToken = document.getElementById('token').value;
var xE911Id = document.getElementById('xE911Id').value;
			var obj={
			mediaType: "dtls-srtp",
			ice:  "true",
			services: [
				"ip_voice_call",
				"ip_video_call"
			]
		};
		var body = {};
		body.session = obj;
		// Create and send a session request.
		var req = new XMLHttpRequest();
		// Set headers and send request.
		req.open("POST", registerURL, true);
		req.setRequestHeader("content-type", "application/json");
		req.setRequestHeader("accept", "application/json");
		req.setRequestHeader("x-e911id", xE911Id);
		req.setRequestHeader("authorization", "Bearer " + accessToken);
				// Clean up contents of the div.
		document.getElementById('deleteSession').disabled = true;
		document.getElementById('progress').innerHTML = "";
		document.getElementById('event').innerHTML = "";
		log("Registering address : "+JSON.stringify(obj));
		req.send(JSON.stringify(body, null, " "));
		// On response
		req.onreadystatechange = function() {
			if (this.readyState == 4) {
				console.log("Registering...");
				// Success response 201 Created
				if (this.status == 201) {
					document.getElementById('createSession').disabled = true;
					document.getElementById('deleteSession').disabled = false;
					console.log("Registration successful");
					log("Registration successful");
					var location  = this.getResponseHeader('location');
					var tokens = location.split("/");
					var index = tokens.indexOf("sessions");
					window.sessionId = tokens[index + 1];
					console.log("Session Id : " + window.sessionId);
					log("Session Id : " + window.sessionId);
					log("Starting event long polling");
					startLongpollingChannel();
				} else {
					console.log("Registration unsuccessful: " + this.status + " " + this.statusText);
					switch (this.status) {
						case 401: // 401 Unauthorized
						case 403: // 403 Forbidden
						case 400: // 403 Forbidden
							log("HTTP Error:"+this.status + this.responseText);
							break;
						default:
							log("HTTP Error:"+"NETWORK_FAILURE");
							break;
					}
				}
			};
		};
};
//Long Polling Function - GET EVENTS
function startLongpollingChannel() {
			var CHANNEL_RESOURCE="events" ;
			var channelURL = GW_URL + "/" + SERVICE_NAME + "/" + version + "/" + REGISTER_RESOURCE +  "/" + window.sessionId +  "/" + CHANNEL_RESOURCE;
			console.log("Querying channel...");
			logEvent("Querying channel...");
			var req = new XMLHttpRequest();
			req.open("GET", channelURL, true);
			req.setRequestHeader('Cache-Control', 'no-cache');
			req.setRequestHeader('Pragma', 'no-cache');
		    req.setRequestHeader("accept", "application/json");
			var tokenwa = document.getElementById("token").value;
			req.setRequestHeader("authorization", "Bearer " + tokenwa);
			req.send(null);
			// On response
			req.onreadystatechange = function() {
				if (this.readyState == 4) {
					// Success response 200 OK
					if (this.status == 200) {
						console.log("Received long polling response: " + this.status + " " + this.statusText + " " + this.responseText);
						logEvent("Received long polling response: " + this.status + " " + this.statusText + " " + this.responseText);
						var json = JSON.parse(this.responseText);
						// Parse channel events
						// Poll again
							timer = 2000;
							setTimeout(function(){startLongpollingChannel(window.sessionId);},5);
					}
						// Success response 204 No Content
						else if (this.status == 204) {
						console.log("Get channel successful: " + this.status + " " + this.statusText + " " + this.responseText);
						logEvent("Get channel successful:  " + this.status + " " + this.statusText + " " + this.responseText);
						// Poll again
							timer = 2000;
							setTimeout(function(){startLongpollingChannel(window.sessionId);},5);
					}
				}
			};
		};
// Stop Session
deleteSession.onclick = function(){
		var accessToken = document.getElementById('token').value;
		unregisterURL = GW_URL + "/" + SERVICE_NAME + "/" + version + "/" + REGISTER_RESOURCE +  "/" + window.sessionId;
		var req = new XMLHttpRequest();
		req.open("DELETE", unregisterURL, false);
		req.setRequestHeader("authorization", "Bearer " + accessToken);
		req.setRequestHeader("X-http-method-override", "DELETE");
		req.setRequestHeader("Accept", "application/json");
		req.send(null);
		log("Session closed");
		document.getElementById('event').innerHTML = "";
		document.getElementById('createSession').disabled = false;
		document.getElementById('deleteSession').disabled = true;
};
</script>
</body>
</html>
