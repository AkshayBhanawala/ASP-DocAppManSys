var X = window.location.pathname;
if (X.includes(".aspx")) {
	var url = window.location.protocol + "//" + window.location.hostname + ":" + window.location.port
	window.location.replace(url);
}

function performAjaxCall(PostBackURL, DATA=null, SuccessFunction=null, FailureFunction=null, CompleteFunction=null) {
	$.ajax({
		type: "POST",
		url: PostBackURL,
		data: DATA,
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (response) {
			if(SuccessFunction != null){
				SuccessFunction(response);
			}
		},
		failure: function (response) {
			if(FailureFunction != null){
				FailureFunction(response);
			}
		},
		complete: function () {
			if(CompleteFunction != null){
				CompleteFunction();
			}
		}
	});
}

$(document).ready(function () {
	$("#div_maincontainer").nextAll().remove();
});