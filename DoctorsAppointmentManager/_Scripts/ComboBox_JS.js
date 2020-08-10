function setComboBox(ComboBoxID) {
	/*
	 * ==================================================================
	 * ComboBox custom attribute
	 * ==================================================================
	 *
	 * ComboBox_EditableTextBox: Whether the textbox value can be edited
	 *	  values:
	 *		  [default]   false	-   Readonly textbox
	 *					  true	-   Textbox can be edited to filter options
	 * 
	 * ComboBox_OpenOnFocus: When the dropdown list is shown
	 *	  values:
	 *		  [default]   true  -   Shown as soon as textbox is in focus
	 *					  false	-   Shown after textbox has any valid value that matches with any of the option value
	 *								Editable is needed for text based values filtering
	 *					  
	 * ComboBox_IgnoreFirstOption: Whether to display the 1st option in a dropdown list which is sometimes a temporary item to show
	 *	  values:
	 *		  [default]   false	-   Show the 1st option in the combobox dropdown list
	 *					  true	-   Skip the 1st option from the combobox dropdown list
	 *
	 * ComboBox_DropTop: Show drop down list on top of control or not.
	 *	  values:
	 *		  [default]   false	-   Show the show on bottom
	 *					  true	-   Show the show on top
	 *					  
	*/

	var DDL = $("#" + ComboBoxID);

	//var values = [];
	//var texts = [];
	//DDL.find("option").each(function (index, element) {
	//	values.push(element.value.toLowerCase());
	//	texts.push(element.text.toLowerCase());
	//});
	//var valueTextPairs = {
	//	"values": values,
	//	"texts": texts
	//};
	//values = null;
	//texts = null;
	//console.log(valueTextPairs);

	DDL.hide();

	var isDisabled = DDL.prop('disabled');
	var combox_Editable = (DDL.attr("ComboBox_EditableTextBox") == "true") ? true : false;
	var combox_OpenOnFocus = (DDL.attr("ComboBox_OpenOnFocus") == "false") ? false : true;
	var combox_IgnoreFirst = (DDL.attr("ComboBox_IgnoreFirstOption") == "true") ? true : false;
	var combox_DropTop = (DDL.attr("ComboBox_DropTop") == "true") ? true : false;

	var DDL_DIV_ID = DDL.attr("id") + "_DIV";
	var DDL_TB_ID = DDL.attr("id") + "_TB";
	var DDL_Placeholder = (DDL.attr('placeholder') != undefined) ? DDL.attr('placeholder') : "";
	var DDL_Title = (DDL.attr('title') != undefined) ? DDL.attr('title') : "";
	var DDL_TabIndex = (DDL.attr('tabindex') != undefined) ? DDL.attr('tabindex') : "";

	$("#" + DDL_DIV_ID).remove();

	$("<div id='" + DDL_DIV_ID + "' class='combobox'><input id='" + DDL_TB_ID + "' type=text tabindex='" + DDL_TabIndex + "' placeholder='" + DDL_Placeholder + "' title='" + DDL_Title + "' class='tb' autocomplete='off'/><label for='" + DDL_TB_ID + "'>&#9722;</label><div class='combobox_options'></div></div>").insertAfter(DDL);

	var DDL_DIV = $("#" + DDL_DIV_ID);
	var DDL_TB = $("#" + DDL_TB_ID);

	if (!combox_Editable) {
		DDL_TB.attr("readonly", "readonly");
	}

	if (isDisabled) {
		DDL_TB.attr("disabled", "true");
	}

	var DDL_OptionsContainer = $("#" + DDL_DIV_ID + " .combobox_options");

	function getComboBoxOptions(FilterValue = null) {
		var options = [];
		DDL.find("option").each(function (origIndex, origOption) {
			if (combox_IgnoreFirst && origIndex == 0) {
				return true;
			}
			if ((FilterValue == null) ||
				(origOption.value.toLowerCase().indexOf(FilterValue.toLowerCase()) != -1)) {
				var option = $("<div valueIndex='" + origIndex + "' value='" + origOption.value + "'>" + origOption.text + "</div>");
				options.push(option);
			}
		});
		return options;
	}

	function fillComboBoxOptions(FilterValue = null, isTextChange = false) {
		DDL_OptionsContainer.empty();
		var options = getComboBoxOptions(FilterValue);
		$.each(options, function (index, option) {
			if (DDL.val() == option.attr("value")) {
				option.addClass("selected");
				if (!isTextChange) {
					DDL_TB.val(option.text());
				}
			}
			option.attr("optionIndex", index)
			DDL_OptionsContainer.append(option);
			option.click(function () {
				selectOption(option);
				DDL_OptionsContainer.hideOptions();
			});
		});
	}

	function selectOption(newOptionToSelect, triggerChangeEvent = true) {
		prevSelectedOption = DDL_OptionsContainer.find("[class=selected]");
		if (newOptionToSelect == null) {
			if (DDL.val() != null) {
				DDL.val([]);
				prevSelectedOption.removeClass("selected");
			}
		} else {
			DDL.val(newOptionToSelect.attr("value"));
			DDL_TB.val(newOptionToSelect.text());
			newOptionToSelect.addClass('selected');
			if (prevSelectedOption.length >= 1 && prevSelectedOption != null) {
				prevSelectedOption.removeClass("selected");
			}
		}
		if (triggerChangeEvent) {
			DDL.trigger("change", false);
		}
	}

	DDL_OptionsContainer.hideOptions = function () {
		DDL_OptionsContainer.addClass("hide");
		DDL_OptionsContainer.removeClass("show");
	}

	DDL_OptionsContainer.showOptions = function () {
		DDL_OptionsContainer.addClass("show");
		DDL_OptionsContainer.removeClass("hide");
	}

	if (combox_OpenOnFocus) {
		fillComboBoxOptions();
	}

	if (combox_DropTop) {
		DDL_OptionsContainer.addClass("dropTop");
	}

	function selectNextIndexOption(index) {
		var prevOption = DDL_OptionsContainer.find("[class=selected]");
		if (prevOption.length <= 0) {
			selectOption(DDL_OptionsContainer.find("[optionIndex=0]"));
		}
		var prevIndex = parseInt(prevOption.attr("optionIndex"));
		var nextOption = DDL_OptionsContainer.find("[optionIndex=" + (prevIndex + index) + "]");
		if (nextOption.length > 0) {
			nextOption.get(0).scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'start' });
			selectOption(nextOption)
		}
	}

	DDL.off("change");
	DDL.on("change", function (e, handleChange) {
		if (handleChange == false) {
			return;
		}
		var selectBoxSelectedValue = DDL.val();
		var comboBoxSelectedValue = DDL_OptionsContainer.find("[class=selected]").attr("value");
		if (selectBoxSelectedValue != comboBoxSelectedValue) {
			var newOptionToSelect = DDL_OptionsContainer.find("[value='" + selectBoxSelectedValue + "']");
			selectOption(newOptionToSelect, false);
		}
	});

	DDL_TB.focusin(function (e) {
		if (combox_OpenOnFocus) {
			DDL_OptionsContainer.showOptions();
		} else {
			var text = DDL_TB.val();
			if (text.length > 0) {
				fillComboBoxOptions(text);
				DDL_OptionsContainer.showOptions();
			}
		}
		e.stopPropagation();
	});

	DDL_TB.mousedown(function (e) {
		if (DDL_TB.is(":focus")) {
			if (DDL_OptionsContainer.hasClass("show")) {
				DDL_OptionsContainer.hideOptions();
			} else {
				DDL_OptionsContainer.showOptions();
			}
		}
	});

	DDL_DIV.focusout(function () {
		setTimeout(function () {
			DDL_OptionsContainer.hideOptions();
		}, 100);
	});

	var keydownClosed = false;

	DDL_TB.keydown(function (e) {
		var KeyCode = e.which;
		//console.log(KeyCode);

		if (KeyCode == 13) {
			// detecting enter key
			if (DDL_OptionsContainer.hasClass("show")) {
				DDL_OptionsContainer.hideOptions();
				e.preventDefault();
				e.stopPropagation();
				e.stopImmediatePropagation();
			}
		} else if (KeyCode == 27) {
			// detecting escape key
			if (DDL_OptionsContainer.hasClass("show")) {
				DDL_OptionsContainer.hideOptions();
				keydownClosed = true;
			}
		} else if (KeyCode == 38) {
			//up arrow key
			selectNextIndexOption(-1);
		} else if (KeyCode == 40) {
			//down arrow key
			selectNextIndexOption(1);
		} else if (combox_Editable) {
			// detecting rest of the valid input keys
			var KeyList = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 109, 173]
			//valid keys: [0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  a,  b,  c,  d,  e,  f,  g,  h,  i,  j,  k,  l,  m,  n,  o,  p,  q,  r,  s,  t,  u,  v,  w,  x,  y,  z,  n0, n1, n2, n3, n4,  n5,  n6,  n7,  n8,  n9,  -,   -  ]
			if (KeyList.indexOf(KeyCode) != -1) {
				selectOption(null);
				var text = DDL_TB.val() + e.key;
				if (text.length > 0) {
					fillComboBoxOptions(text, true);
					DDL_OptionsContainer.showOptions();
				} else {
					DDL_OptionsContainer.hideOptions();
				}
			}
		}
	});

	DDL_TB.keyup(function (e) {
		var KeyCode = e.which;
		//console.log(KeyCode);

		if (KeyCode == 27) {
			// detecting escape key
			if (keydownClosed) {
				e.preventDefault();
				e.stopPropagation();
				e.stopImmediatePropagation();
				keydownClosed = false;
			}
		} else if (combox_Editable) {
			// operation keys
			var KeyList = [8, 46]
			//valid keys: [backspace, delete]
			if (KeyList.indexOf(KeyCode) != -1) {
				var text = DDL_TB.val();
				selectOption(null);
				if (text.length > 0) {
					fillComboBoxOptions(text, true);
					DDL_OptionsContainer.showOptions();
				}else {
					DDL_OptionsContainer.hideOptions();
				}
			}
		}
	});
}

function comboBox_UpdateView(selectBoxes = null) {
	if (selectBoxes == null) {
		$("select").each(function (index, element) {
			var ClientID = $(element).attr("id");
			setComboBox(ClientID);
		});
	} else {
		selectBoxes.each(function (index, element) {
			var ClientID = $(element).attr("id");
			setComboBox(ClientID);
		});
	}
}
