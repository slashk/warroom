// javascript code for WarRoom

// global variables
var $currentPick = 0;
var $interval = 10000;

// All pages
$(document).ready(function(){
    playerTable();
	playerLoop();
	setRetaineeDragAndDrop();
	refreshWatchlist(15000);
});

function playerLoop() {
	setInterval(function(){ 
		$.get("/currentpick", function(){
			// if dbCurrentPick > currentPick
			//		update all sidebar widgets
			// 		check isItMyPick?
			//			redAlert -- make background colors red
			//			pop alert that you are on clock
			//			refresh screen
			//			add + button to each player name
			alert(response)
		}, "json")
		}, $interval);
}

function playerTable(){
    $('#players').dataTable({
        "iDisplayLength": 50,
        "bJQueryUI": true,
        "sPaginationType": "full_numbers"
    });
}

function setRetaineeDragAndDrop(){
	// retainees box
	$('.removeRetaineeButton').livequery('click', function (event) { 
			var $element = $(this);
			var $playerId = getPlayerId($element.attr("id"));
	        $.get("/retainees/remove_player_from_retainee_list/"+$playerId, function (textStatus){
				refreshMyRetaineeList();
				$nonRetaineeButton = $("#"+$playerId+"-nonRetainee")
				toggleRetaineeButton($nonRetaineeButton);				
			});
	    }); 
	// attach dataTable to nonRetainedPlayers
	$('#nonRetainedPlayers').dataTable({
        "iDisplayLength": 50,
        "bJQueryUI": true,
		"aaSorting": [[3,'asc']],
		"bPaginate": false,
		
    });
	// add handler to retainButtons
	$(".addRetaineeButton").livequery('click', function (event) {
		var $element = $(this);
		var $playerId = getPlayerId($element.attr("id"));
		$.get("/retainees/add_player_to_retainee_list/"+$playerId, function (textStatus){
			alert(textStatus);
			refreshMyRetaineeList();
			toggleRetaineeButton($element);
		});
	})
}

function refreshWatchlist($interval) {
	setInterval(function(){ $("#watchlist").load("/watchlist/show/"+$.cookie("auth_token")).highlight() }, $interval);
}

function refreshMyTeam() {

}

function refreshComingNext() {
	
}

function refreshMyRetaineeList () {
	$("#retainedPlayers").load("/retainees/retained_players/1").highlight();
}

function getPlayerId (x) {
	return x.split("-")[0];
}

function toggleRetaineeButton (element) {
	element.unbind("click");
	// find out if its add or remove
	element.toggleClass("addRetaineeButton").toggleClass("removeRetaineeButton");
	// change icon
	if (element.attr("src") == "/images/delete.png") {
		element.attr("src","/images/add.png");
	} else {
		element.attr("src","/images/delete.png");
	}
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
