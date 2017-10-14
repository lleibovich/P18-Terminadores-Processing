  function getColorString(rgbArray) {
	return rgbArray[0] + ";" + rgbArray[1] + ";" + rgbArray[2];
  }
  function getUlColorsString(ulName) {
	var str = "";
	$("#" + ulName + " li .s10").each(function(i) {
	  str += getColorString(getRgbArrayFromHex($(this).html())) + "|";
	});
	str = str.replace(/\|\s*$/, "");
	return str;
  }
  function getUlWordsString(ulName) {
	var str = "";
	$("#" + ulName + " li .s10").each(function(i) {
	  str += $(this).html() + ";";
	});
	str = str.replace(/\;\s*$/, "");
	return str;
  }
  function buildCfgString() {
	var os = require("os");
	var fearsWordsString = getUlWordsString("ulFearsWords");
	var strengthWordsString = getUlWordsString("ulStrengthsWords");
	var fearsColorsStrnig = getUlColorsString("ulFearsColors");
	var strengthColorsString = getUlColorsString("ulStrengthsColors");
	var backgroundColorString = getColorString(getRgbArrayFromElement($("#colBackground")));
	var cfgString = "";
	cfgString += "AnimationType=" + $("#selAnimationType").val() + os.EOL;
	cfgString += "SensorType=" + $("#selSensorType").val() + os.EOL;
	cfgString += "CameraName=" + "ABC" + os.EOL;
	cfgString += "Fears=" + fearsWordsString + os.EOL;
	cfgString += "FearsColors=" + fearsColorsStrnig + os.EOL;
	cfgString += "Strengths=" + strengthWordsString + os.EOL;
	cfgString += "StrengthsColors=" + strengthColorsString + os.EOL;
	cfgString += "ProjectorResolution=" + "x,y" + os.EOL;
	cfgString += "ProjectorName=" + "ABC" + os.EOL;
	cfgString += "FontName=" + $("#txtFontName").val() + os.EOL;
	cfgString += "FontSize=" + $("#txtFontSize").val() + os.EOL;
	cfgString += "DisalignConversionFactor=" + $("#txtDisalignConversionFactor").val() + os.EOL;
	cfgString += "DisalignIntervalMs=" + $("#txtDisalignIntervalMs").val() + os.EOL;
	cfgString += "BackgroundColor=" + backgroundColorString + os.EOL;
	cfgString += "LocationType=" + $("#selLocationType").val() + os.EOL;

	return cfgString;
  }
  function deleteItemList(item) {
	$(item).closest('li').remove();
  }
  function getHtmlAddWord(word) {
	var item = "<li><div class='row slim'><div class='col s10'>" + word + "</div><div class='col s2'><a class='waves-effect waves-light- btn slim' onClick='deleteItemList($(this));'>-</a></div></div></li>";
	return item;
  }
  function getHtmlAddColor(colorHex) {
	//
	var item = "<li><div class='row slim'><div class='col s10' style='color: " + colorHex + ";background-color:" + colorHex +";'>" + colorHex + "</div><div class='col s2'><a class='waves-effect waves-light- btn slim' onClick='deleteItemList($(this));'>-</a></div></div></li>";
	return item;
  }
  function addFearWord(word) {
	var item = getHtmlAddWord(word);
	$("#ulFearsWords").append(item);
  }
  function addStrengthWord(word) {
	var item = getHtmlAddWord(word);
	$("#ulStrengthsWords").append(item);
  }
  function addFearColor(color) {
	var item = getHtmlAddColor(color);
	$("#ulFearsColors").append(item);
  }
  function addStrengthColor(color) {
	var item = getHtmlAddColor(color);
	$("#ulStrengthsColors").append(item);
  }
  function getRgbArrayFromElement(input) {
	var hex = $(input).val();
	return getRgbArrayFromHex(hex);
  }
  function getRgbArrayFromHex(hex) {
	hex = hex.substring(1, 7);
	var rgb = new Array();
	rgb.push(parseInt(hex.substring(0, 2), 16));
	rgb.push(parseInt(hex.substring(2, 4), 16));
	rgb.push(parseInt(hex.substring(4, 6), 16));
	return rgb;
  }