// javascript code for WarRoom

// global variables
var $currentPick = {"created_at":"2010-03-16T10:26:37-07:00","updated_at":"2010-03-16T10:26:37-07:00","player_id":null,"id":0,"user_id":0,"pick_number":0};
var $interval = 10000;
var $isItMyPick = "0";

// All pages
$(document).ready(function(){
    playerTable();
	playerLoop();
	setRetaineeDragAndDrop();
	refreshWatchlist(15000);
});

function playerLoop() {
	setInterval(function(){ 
		getCurrentPick();
		refreshWatchlist();
		refreshDraftList();
		if ($isItMyPick) {
			soundRedAlert(); // make background red to alert user
			addDraftButton();
		} else {
			removeRedAlert();
			removeDraftButton();
		};
		refreshMyTeam();
		refreshComingNext();
		// if dbCurrentPick > currentPick
		//		update all sidebar widgets
		// 		check isItMyPick?
		//			redAlert -- make background colors red
		//			pop alert that you are on clock
		//			refresh screen
		//			add + button to each player name
		// setInterval(function(){ $("#myteam").load("/picks/myteam").highlight() }, $interval);
		}, $interval);
}

function playerTable(){
    $('#players').dataTable({
        "iDisplayLength": 50,
        "bJQueryUI": true,
        "sPaginationType": "full_numbers"
    });
}

function soundRedAlert() {
	$("#sidebar").addClass("on-the-clock");
	$("div#asshead").addClass("on-the-clock");
}

function removeRedAlert() {
	$("#sidebar").removeClass("on-the-clock");	
	$("div#asshead").addClass("on-the-clock");
}

function addDraftButton(){
	
}

function removeDraftButton(){
	
}

function getCurrentPick(){
	 // sets a Pick object to $currentPick 
	$.getJSON( '/currentpick', function( json ) {
		if (json.pick.pick_number > $currentPick.pick_number) { 
			$currentPick = json.pick;
			refreshComingNext();
			isItMyPick();
		};	
	});
}

function isItMyPick() {
	// returns 1 or 0, which is true or false 
	x = $.get('/isitmypick', function(data) {
		$isItMyTurn = data;
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

function refreshWatchlist() {
	$("#watchlist").load("/watchlist/show/"+$.cookie("auth_token")).highlight();
}

function refreshMyTeam() {
	$("#myteam").load("/myteam").highlight();
}

function refreshComingNext() {
	$("#inline").load("/inline").highlight();	
}

function refreshMyRetaineeList () {
	$("#retainedPlayers").load("/retainees/retained_players/1").highlight();
}

function refreshDraftList() {
	$("#draft_live").load("/draftpicks").highlight();	
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
