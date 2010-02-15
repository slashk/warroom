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

