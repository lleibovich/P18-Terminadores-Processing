$().ready(function() {
	// Redirect to vars page by default
	window.location.hash="#vars_words";
	$("select").material_select();
	addFearColor($("#colAddFear").val());
	addStrengthColor($("#colAddStrength").val());
	$("#txtAddFear").onEnter(function(e) {
	  $("#btnAddFear").trigger("click");
	});
	$("#txtAddStrength").onEnter(function(e) {
	  $("#btnAddStrength").trigger("click");
	});
	$("#btnAddFear").on("click", function(e) {
	  var fear = $("#txtAddFear").val();
	  if (fear == "") return;
	  if ($("#ulFearsWords").children().length >= MAX_WORDS_FEARS) {
		alert("No se pueden agregar miedos, llegó al máximo.", "Máximo alcanzado");
		return;
	  }
	  addFearWord(fear);
	  $("#txtAddFear").val("");
	});
	$("#btnAddStrength").on("click", function(e) {
	  var strength = $("#txtAddStrength").val();
	  if (strength == "") return;
	  if ($("#ulStrengthsWords").children().length >= MAX_WORDS_STRENGTHS) {
		alert("No se pueden agregar fortalezas, llegó al máximo.", "Máximo alcanzado");
		return;
	  }
	  addStrengthWord(strength);
	  $("#txtAddStrength").val("");
	});
	$("#colAddFear").on("change", function(e) {
	  console.log(getRgbArrayFromElement($(this)));
	  addFearColor($(this).val());
	});
	$("#colAddStrength").on("change", function(e) {
	  console.log(getRgbArrayFromElement($(this)));
	  addStrengthColor($(this).val());
	});
	$("#btnPlay").on("click", function(e) {
	  const remote = require('electron').remote
	  const dialog = remote.dialog;
	
	  var fs = require("fs");
	  console.log(buildCfgString());
	  var child = require('child_process').exec;
	  const appL = require('electron').remote.app;
	  var executablePath = appL.getAppPath() + "\\app\\";
	  fs.writeFile(executablePath + "cfg.txt", buildCfgString(), (err) => {
		if(err){
		  alert("No se pudo guardar la configuración: "+ err.message);
		  dialog.showErrorBox("No se pudo guardar la configuración", err.message);
		} else {
		  //alert("The file has been succesfully saved");
		  child("start /d \"" + executablePath + "\" Main.exe", function(err, data) {
			if(err){
			  console.error(err);
	
			  dialog.showErrorBox("No se pudo guardar la configuración", err);
			  return;
			}
			console.log(data.toString());
		  });
		}
	  });
	})
});