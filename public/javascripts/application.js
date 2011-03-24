// javascript code for WarRoom

// global variables
var $currentPick = {"created_at":"2010-03-16T10:26:37-07:00","updated_at":"2010-03-16T10:26:37-07:00","player_id":null,"id":0,"user_id":0,"pick_number":0};
var $interval = 15000; // sixty second updates
var playerPage = 0;

// All pages
$(document).ready(function(){
	if (playerPage == 1){
		getCurrentPick();
		refreshMyTeam();
		watchPlayer();
		unwatchPlayer();
		playerLoop();
		confirmDrafteeDialog();
		addDraftButton();
		addRefreshSidebarButtonToAssy();
		playerTable();
	} else {
		userTable();
		pickTable();
		setRetaineeDragAndDrop();
		retaineeTable();
		adminDraftTable();
	}
	$("#login_button").button();
});

function playerLoop() {
	// poll every $interval millseconds for new sidebar data
	setInterval(function(){ 
		// we used to refresh entire sidebar but now just when 
		getCurrentPick();
		}, $interval);
}

function refreshSidebar(){
		// getCurrentPick();
		refreshWatchlist();
		refreshDraftList();
		// refreshMyTeam();
		refreshComingNext();
		isItMyPick(); // find my pick last so that watchlist is repop'd
}

function addRedAlert() {
	$("#asshead").removeClass("off-the-clock");
	$("#sidebar").removeClass("off-the-clock");
	$("#sidebar").addClass("on-the-clock");
	$("#asshead").addClass("on-the-clock");
}

function removeRedAlert() {
	$("#sidebar").removeClass("on-the-clock");	
	$("#asshead").removeClass("on-the-clock");
	$("#asshead").addClass("off-the-clock");
	$("#sidebar").addClass("off-the-clock");
}

function confirmDrafteeDialog() {
	$("#confirmDrafteeDialog").dialog({
        title: "Confirm Your Draft Pick",
        modal: true,
        width: 450,
        autoOpen: false,
		closeOnEscape: false,
		resizable: false
    });
}

function addDraftButton(){
	// add click handler to draft players
	$("#watchlist img.watchlistPlayerIcon").livequery('click', function() { 
		var $playerId = $(this).attr("id");
		$("#confirmDrafteeDialog").html("loading...")
		$("#confirmDrafteeDialog").load("/players/confirm_draftee/"+$playerId) // edit
		$("#confirmDrafteeDialog").dialog('option', 'buttons', { 
		    "Draft": function() { 
				$.post("/draft/", { player_id: $playerId }, function (){
					isItMyPick();
					refreshMyTeam();
					refreshSidebar();
				});
				$(this).dialog("close"); 
			},
			"Cancel": function() { 
				$(this).dialog("close"); 
			}
		});
		$('#confirmDrafteeDialog').dialog('open');		
    });
}

function getCurrentPick(){
	 // sets a Pick object to $currentPick 
	$.getJSON( '/currentpick', function( json ) {
		if ($currentPick.pick_number != json.pick.pick_number) {
			$currentPick = json.pick;			
			refreshSidebar(); // refresh sidebar if pick_number changed
		}
	});
}

function isItMyPick() {
	// returns 1 or 0, which is true or false 
	// x = $.get('/isitmypick', function(data) {
   	x = $.cookie('team');
	if (x == $currentPick.user_id) {
		addRedAlert(); // make background red to alert user
		playBing();
	} else {
		removeRedAlert();
	};
	// });
}

function setRetaineeDragAndDrop(){
	// setup 
	$("#retaineeFailDialog").dialog({
        title: "Retainee Fail",
        modal: true,
        width: 450,
        autoOpen: false,
		closeOnEscape: true,
		resizable: false,
		buttons:{ 
			"Cancel": function() { 
				$(this).dialog("close"); 
			}
		}
    });
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
		$.ajax({ 
	            type: "GET", 
	            url: "/retainees/add_player_to_retainee_list/"+$playerId, 
	            dataType: "html", 
	            error: function(){ 
	              $("#retaineeFailDialog").dialog('open');
	          	}, 
	          	success: function(data){ 
	               	refreshMyRetaineeList();
					toggleRetaineeButton($element);
	      		} 
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

function addRefreshSidebarButtonToAssy() {
	$("#assy").click(function(){
		refreshSidebar();
	});
}

function watchPlayer() {
	$(".unwatch").livequery('click', function(event) {
		var $element = $(this);
		var $playerId = getPlayerId($element.attr("id"));
		$.ajax({
			url:'/players/add_to_watchlist/'+$playerId,
			error: function(){ 
	          // should open dialog
	      	}, 
	      	success: function(data){ 
				refreshWatchlist();
				$element.attr("src","/images/watch.gif");
				$element.removeClass("unwatch");
				$element.addClass("watch");
	  		}
		}); 
		return false;
	});
}

function unwatchPlayer() {
	$(".watch").livequery('click', function(event) {
		var $element = $(this);
		var $playerId = getPlayerId($element.attr("id"));
		$.ajax({
			url:'/players/remove_from_watchlist/'+$playerId,
			error: function(){ 
	          // should open dialog
	      	}, 
	      	success: function(data){ 
				refreshWatchlist();
				$element.attr("src","/images/not_watch.gif");
				$element.removeClass("watch");
				$element.addClass("unwatch");
	  		}
		}); 
		return false;
	});
}

function playBing() {
	var snd = new Audio("bing.wav");
	snd.play();
}

function playerTable(){
    $('#players').dataTable({
        "iDisplayLength": 25,
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
        "bJQueryUI": true
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

function adminDraftTable(){
    $('#adminDraft').dataTable({
        "iDisplayLength": 15,
        "bJQueryUI": true, 
		"aaSorting": [[0,'asc']],
		"aoColumns": [ 
			{ "sType": "numeric" },
			{ "sType": "string" },
			{ "sType": "string" },
			{ "sType": "html"}
		],
		"sPaginationType": "full_numbers"
    });
}
