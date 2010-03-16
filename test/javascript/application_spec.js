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
// 

Screw.Unit(function(){
  describe("Your application javascript", function(){
    it("does something", function(){
      expect("hello").to(equal, "hello");
    });

    it("accesses the DOM from fixtures/application.html", function(){
      expect($('.select_me').length).to(equal, 2);
    });
  });
});

