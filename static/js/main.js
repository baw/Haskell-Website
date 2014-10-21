(function () {
  var addContact = function () {
    var contact = document.getElementById("contact");
    contact.href = "mailto:" + "brian" + "@" + "brianweiser.io";
  };

  var addEvents = function () {
    var linkSelector = "#projectsLink, #resumeLink";
    var clickMove = "click.move";
    $(linkSelector).on(clickMove, function (event) {
      var projectsHeight = $(".projects").height();
      var resumeHeight = $(".resume").height();
      
      var height = projectsHeight > resumeHeight ? projectsHeight : resumeHeight;
      
      
      $(".main").animate({
        top: 0,
        "min-height": height + 200
      });
      
      $(linkSelector).off(clickMove);
    });
    
    $("#projectsLink, #resumeLink").on("click.show", function (event) {
      event.preventDefault();
      
      var currentId = $(this).prop("id");
      
      var showDiv, hideDiv, pushStateLocation;
      if (currentId === "projectsLink") {
        pushStateLocation = "projects";

        showDiv = ".projects";
        hideDiv = ".resume";
      } else {
        pushStateLocation = "resume";

        showDiv = ".resume";
        hideDiv = ".projects";
      }
    
      if (history !== undefined && history.pushState !== undefined) {
        history.pushState({}, "", pushStateLocation);
      }
      
      ga("send", "pageview", "/" + pushStateLocation);

      $(showDiv).animate({ top: "150px"   });
      $(hideDiv).animate({ top: "-1500px" });
    });
  };

  $(function () {
    addContact();
    addEvents();
  });
})();
