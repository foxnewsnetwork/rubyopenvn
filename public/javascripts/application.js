$(document).ready(function(){ 
	$("#refreshpage").click( function(){ 
		location.reload();
	} ); // end click
} ); // end ready

function NowLoading(){
  if ($("#now-loading").length == 0) { 
    $("body").append($("#now-loading"));
  } // end if
  $("#now-loading").show();
} // NowLoading
