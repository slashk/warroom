require("spec_helper.js");
require("../../public/javascripts/application.js");

// list of functions in public/javascripts/application.js
// playerLoop: main event loop on homepage
// playerTable : add table sort to #search
// setRetaineeDragAndDrop
// refreshWatchlist
// refreshMyTeam
// refreshComingNext
// refreshMyRetaineeList
// getPlayerId : takes 
// toggleRetaineeButton
// draft

Screw.Unit(function(){
  describe("Your application javascript", function(){
    it("expect one #asshead", function(){
		expect($('#asshead').length).to(equal, 1);
    });


    it("calls addRedAlert to change className", function(){
      	addRedAlert();
		expect($('#asshead')[0].className).to(equal, "on-the-clock");
    });

    it("calls removeRedAlert to change className", function(){
      	removeRedAlert();
		expect($('#asshead')[0].className).to(equal, "off-the-clock");
    });

  });
});

