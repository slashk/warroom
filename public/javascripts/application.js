// javascript code for WarRoom

// All pages
$(document).ready(function(){
    playerTable();
    //$('#sidebar').tabs();
});

function playerTable() {
    $('#players').dataTable({
        "iDisplayLength": 50,
        "bJQueryUI": true,
        "sPaginationType": "full_numbers"
    });
}

function dashboard() {
	// the dashboard is main page
	// setup event loop 
	// check for draft change (current draft pick number)
	// 		if changed, then update everything
	//				this requires service that spits out current-draft-pick
	//				warroom.com/pick/current ?
	// check for watchlist change
	// 		if changed, then update watchlist
	//				this requires service that spits out current-watchlist
	//				this is hard because it's a join, not a object ?
}

//    $("#style-guidelines").dialog({
//        title: "Event Style Guidelines",
//        modal: false,
//        width: 450,
//        autoOpen: false,
//        buttons: {
//            Ok: function() {
//                $(this).dialog('close');
//            }
//        }
//    });
//	$('#help-icon-style-guidelines').click(function () {
//		$('#style-guidelines').dialog('open');
//	});


//    $("#newstabs").tabs();

//$(document).ready(function() {
//    // accordian for race details
//    $('#race_detail').accordion({
//        animated: 'bounceslide',
//        icons: {
//            header: "ui-icon-circle-triangle-e",
//            headerSelected: "ui-icon-circle-triangle-s"
//        }
//    });
//});

//function add_another_race() {
//    $('#races').append($(".raceEntry:first").clone());
//}

