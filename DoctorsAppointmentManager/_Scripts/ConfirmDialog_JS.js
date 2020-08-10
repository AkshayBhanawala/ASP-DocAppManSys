function openConfirmDialog(PositiveFunction = closeConfirmDialog, NegativeFunction = closeConfirmDialog) {
	$("#div_confirmDialog").removeClass("hide");
	$("#div_confirmDialog").addClass("show");
	$("#div_confirmDialog").bind('keyup', function (event) {
		if (event.keyCode == 27) {
			$("#BTN_ConfirmDialog_No").click();
		} else if (event.keyCode == 37 || event.keyCode == 38) {
			$("#BTN_ConfirmDialog_Yes")[0].focus();
		} else if (event.keyCode == 39 || event.keyCode == 40) {
			$("#BTN_ConfirmDialog_No")[0].focus();
		}
	});
	setTimeout(function () {
		$("#BTN_ConfirmDialog_No")[0].focus();
	}, 100);

	function positiveHandle(e) {
		PositiveFunction();
		if (PositiveFunction.name != closeConfirmDialog.name) {
			closeConfirmDialog();
		}
		return false;
	}
	function negativeHandle(e) {
		NegativeFunction();
		if (NegativeFunction.name != closeConfirmDialog.name) {
			closeConfirmDialog();
		}
		return false;
	}
	$("#BTN_ConfirmDialog_Yes").bind("click", positiveHandle);
	$("#BTN_ConfirmDialog_No").bind("click", negativeHandle,);
}

function closeConfirmDialog() {
	$("#div_confirmDialog").removeClass("show");
	$("#div_confirmDialog").addClass("hide");
	$("#div_confirmDialog").off();
	$("#BTN_ConfirmDialog_Yes").off();
	$("#BTN_ConfirmDialog_No").off();
}