// javascript code for WarRoom

// global variables
var $currentPick = {"created_at":"2010-03-16T10:26:37-07:00","updated_at":"2010-03-16T10:26:37-07:00","player_id":null,"id":0,"user_id":0,"pick_number":0};
var $interval = 10000;
var playerPage = 0;
// var $isItMyPick = 0;

// All pages
$(document).ready(function(){
    playerTable();
	userTable();
	if (playerPage == 1){
		refreshSidebar();
		playerLoop();		
	}
	setRetaineeDragAndDrop();
});

function playerLoop() {
	// poll every $interval millseconds for new sidebar data
	setInterval(function(){ 
		refreshSidebar();
		}, $interval);
}

function refreshSidebar(){
	getCurrentPick();
	refreshWatchlist();
	refreshDraftList();
	refreshMyTeam();
	refreshComingNext();
	isItMyPick();
}

function addRedAlert() {
	$("#sidebar").addClass("on-the-clock");
	$("div#asshead").addClass("on-the-clock");
}

function removeRedAlert() {
	$("#sidebar").removeClass("on-the-clock");	
	$("div#asshead").removeClass("on-the-clock");
}

function addDraftButton(){
	
}

function removeDraftButton(){
	
}

function getCurrentPick(){
	 // sets a Pick object to $currentPick 
	$.getJSON( '/currentpick', function( json ) {
			$currentPick = json.pick;
	});
}

function isItMyPick() {
	// returns 1 or 0, which is true or false 
	x = $.get('/isitmypick', function(data) {
		// $isItMyPick = data;
		if (data == 1) {
			addRedAlert(); // make background red to alert user
			addDraftButton();
		} else {
			removeRedAlert();
			removeDraftButton();
		};
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

function playerTable(){
    $('#players').dataTable({
        "iDisplayLength": 50,
        "bJQueryUI": true,
        "sPaginationType": "full_numbers"
    });
}

function userTable(){
    $('#users').dataTable({
        "bJQueryUI": true,
    });
}

