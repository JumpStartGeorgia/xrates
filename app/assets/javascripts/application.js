// This is a manifest file that"ll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// require twitter/bootstrap
// require dataTables/jquery.dataTables
// require dataTables/bootstrap/3/jquery.dataTables.bootstrap
// require vendor
// require_tree .

//= require i18n
//= require i18n/translations
//= require jquery
//= require jquery_ujs
//= require jquery.ui.core
//= require jquery.ui.effect
//= require jquery.ui.datepicker
//= require highstock
//= require highcharts-exporting
// require twitter/bootstrap/dropdown
// require bootstrap-select.min
//= require select2.min
// require dev
//= require tab
//= require_self

$(document).ready(function (){
	// set focus to first text box on page
	if(gon.highlight_first_form_field){
    $(":input:visible:enabled:first").focus();
	}

	// workaround to get logout link in navbar to work
	$("body")
		.off("click.dropdown touchstart.dropdown.data-api", ".dropdown")
		.on("click.dropdown touchstart.dropdown.data-api", ".dropdown form", function (e) { e.stopPropagation() });

  $(".tabs").toggle($(".menu-toggle").css("display") == "none");
  $(".menu-toggle").click(function (e) {
    $(".tabs").toggle();
    e.preventDefault();
  });
});
