// javascript code for WarRoom
// All pages
$(document).ready(function(){
    playerTable();
	setRetaineeDragAndDrop();
    //$('#sidebar').tabs();
});

function playerTable(){
    $('#players').dataTable({
        "iDisplayLength": 50,
        "bJQueryUI": true,
        "sPaginationType": "full_numbers"
    });
}

function setRetaineeDragAndDrop(){
	// add handler to retainButtons
	$(".addRetaineeButton").click(function (){
		var $element = $(this);
		var $playerRow = $element.parents(".player");
		var $playerId = $playerRow.attr("id");
		$.get("/retainees/add_player_to_retainee_list/"+$playerId, function (textStatus){
			// if successful, highlight row and change add icon to cancel icon
			// $element.parent("td").html("<img src='images/cancel.png' style='removeRetaineeButton'>");
			// $playerRow.addClass("retainedPlayer");
			// maybe also update status of retainee picks
			// rebind cancel function to new cancel icon
			$("#retainedPlayers").load("/retainees/retained_players/1");
		});
	})
	// make retainedPlayers cancel-able
	$(".removeRetaineeButton").click(function (){
		var $playerRow = $(this).parent("span");
		var $playerId = $playerRow.attr("id");
		$.get('/retainees/remove_player_from_retainee_list/'+$playerId, function (){
			$playerRow.fadeOut();					
		});
	});
}

function refreshRetaineeList () {
	$("#retainedPlayers").load("/retainees/retained_players/1");
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
