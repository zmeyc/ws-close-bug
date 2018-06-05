"use strict";

var WebSocket = WebSocket || MozWebSocket;

var contentWindow = document.getElementById("outputFrame").contentWindow
var outputFrameBody = contentWindow.document.body;
var connection = null;

function connect() {
    var serverUrl = "ws://localhost:4040";
    
    if (connection) {
        connection.close();
    }
    connection = new WebSocket(serverUrl);

    connection.onopen = function(evt) {
        console.log("connection.onopen()");
        outputFrameBody.innerText = "";
    };

    connection.onmessage = function(evt) {
        console.log("connection.onmessage()");
        outputFrameBody.innerText += evt.data;
    };
}
