// javascript code for WarRoom

// global variables
var $currentPick = {"created_at":"2010-03-16T10:26:37-07:00","updated_at":"2010-03-16T10:26:37-07:00","player_id":null,"id":0,"user_id":0,"pick_number":0};
var $interval = 10000; // thirty second updates
var playerPage = 0;

// All pages
$(document).ready(function(){
	if (playerPage == 1){
	    playerTable();
		getCurrentPick();
		refreshWatchlist();
		refreshDraftList();
		refreshMyTeam();
		refreshComingNext();
		isItMyPick(); // find my pick last so that watchlist is repop'd
		playerLoop();
		addDraftButton();
	}
	userTable();
	pickTable();
	setRetaineeDragAndDrop();
	retaineeTable();
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
		isItMyPick(); // find my pick last so that watchlist is repop'd
}

function addRedAlert() {
	$("#sidebar").addClass("on-the-clock");
	$("div#asshead").addClass("on-the-clock"); // shouldn't need div
}

function removeRedAlert() {
	$("#sidebar").removeClass("on-the-clock");	
	$("div#asshead").removeClass("on-the-clock");
}

function addDraftButton(){
	// add click handler to draft players
	$(".watchlistPlayerIcon").livequery('click', function() { 
			var $playerId = $(this).attr("id");
	        $.post("/draft/", { player_id: $playerId }, function (textStatus){
				isItMyPick();
				refreshSidebar();
			});
	    });
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
		if (data == 1) {
			addRedAlert(); // make background red to alert user
		} else {
			removeRedAlert();
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
		"aoColumns": [
			{ "asSorting": [ "asc", "desc" ], "sType": "html" }, // name
			{ "asSorting": [ "asc", "desc" ] }, // pos
			{ "asSorting": [ "asc", "desc" ] }, // team
			{ "asSorting": [ "asc", "desc" ] }, // rank
			{ "asSorting": [ "asc", "desc" ] }, // orank
			{ "asSorting": [ "desc", "asc" ] }, // R
			{ "asSorting": [ "desc", "asc" ] }, // HR
			{ "asSorting": [ "desc", "asc" ] }, // RBI
			{ "asSorting": [ "desc", "asc" ] }, // SB
			{ "asSorting": [ "desc", "asc" ] }, // AVG
			{ "asSorting": [ "desc", "asc" ] }, // IP
			{ "asSorting": [ "desc", "asc" ] }, // W
			{ "asSorting": [ "desc", "asc" ] }, // SV
			{ "asSorting": [ "desc", "asc" ] }, // K
			{ "asSorting": [ "asc", "desc" ] }, // ERA
			{ "asSorting": [ "asc", "desc" ] }, // WHIP
			{ "asSorting": [ "asc", "desc" ] } // button
		]
    });
	// add handler to retainButtons
	$(".addRetaineeButton").livequery('click', function (event) {
		var $element = $(this);
		var $playerId = getPlayerId($element.attr("id"));
		$.get("/retainees/add_player_to_retainee_list/"+$playerId, function (textStatus){
			refreshMyRetaineeList();
			toggleRetaineeButton($element);
		});
	})
}

function refreshWatchlist() {
	$("#watchlist").load("/watchlist/show/").highlight();
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

function findPlayerById() {
	playerId = $("input#pick_player_id")[0].value
	$("#draftee").load("/player/show/"+playerId).highlight();
}

function playerTable(){
    $('#players').dataTable({
        "iDisplayLength": 50,
        "bJQueryUI": true,
        "sPaginationType": "full_numbers",
		"aaSorting": [[4,'asc']],
		"aoColumns": [
			{ "asSorting": [ "asc", "desc" ], "sType": "html" }, // name
			{ "asSorting": [ "desc", "asc" ] }, // watch
			{ "asSorting": [ "desc", "asc" ] }, // pos
			{ "asSorting": [ "asc", "desc" ] }, // team
			{ "asSorting": [ "asc", "desc" ] }, // rank
			{ "asSorting": [ "asc", "desc" ] }, // orank
			{ "asSorting": [ "asc", "desc" ] }, // depth
			{ "asSorting": [ "desc", "asc" ] }, // R
			{ "asSorting": [ "desc", "asc" ] }, // HR
			{ "asSorting": [ "desc", "asc" ] }, // RBI
			{ "asSorting": [ "desc", "asc" ] }, // SB
			{ "asSorting": [ "desc", "asc" ] }, // AVG
			{ "asSorting": [ "desc", "asc" ] }, // IP
			{ "asSorting": [ "desc", "asc" ] }, // W
			{ "asSorting": [ "desc", "asc" ] }, // SV
			{ "asSorting": [ "desc", "asc" ] }, // K
			{ "asSorting": [ "asc", "desc" ] }, // ERA
			{ "asSorting": [ "asc", "desc" ] } // WHIP
		]
    });
}

function userTable(){
    $('#usersTable').dataTable({
        "bJQueryUI": true,
    });
}

function retaineeTable(){
    $('#retaineesTable').dataTable({
        "iDisplayLength": 100,
        "bJQueryUI": true
    });
}

function pickTable(){
    $('#picksTable').dataTable({
        "bJQueryUI": true,
        "iDisplayLength": 100,
		"aaSorting": [[0,'desc']],
		"aoColumns": [ 
			{ "sType": "numeric" },
			{ "sType": "html" },
			{ "sType": "string" },
			{ "sType": "string" },
			{ "sType": "string" },
		],
		"sPaginationType": "full_numbers"
    });
}
