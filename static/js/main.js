(function () {
  var mainElm = document.getElementById("main");
  var projectsElm = document.getElementById("projects");
  var resumeElm = document.getElementById("resume");
  var projectsLinkElm = document.getElementById("resumeLink");
  var resumeLinkElm = document.getElementById("projectsLink");
  
  var links = [projectsLinkElm, resumeLinkElm];
  
  var addClass = function (el, className) {
    if (el.classList) {
      el.classList.add(className);
    } else {
      el.className += ' ' + className;
    }
  };
  
  var addContact = function () {
    var contact = document.getElementById("contact");
    contact.href = "mailto:" + "brian" + "@" + "brianweiser.io";
  };

  var addEvents = function () {
    links.forEach(function (link) {
      link.addEventListener("click", mainMove);
      link.addEventListener("click", changeContent);
    });
  };
  
  var mainMove = function (event) {
    event.preventDefault();
    var projectsHeight = resumeElm.style.height;
    var resumeHeight = projectsElm.style.height;
    
    var height = projectsHeight > resumeHeight ? projectsHeight : resumeHeight;
    
    main.style.minHeight = height + 200 + "px";
    addClass(mainElm, "raise");
    
    links.forEach(function (link) {
      link.removeEventListener("click", mainMove);
    });
  };
  
  var changeContent = function (event) {
    event.preventDefault();
    
    var currentId = event.target.getAttribute("id");
    
    var showDivElm, hideDivElm, pushStateLocation;
    if (currentId === "projectsLink") {
      pushStateLocation = "projects";

      showDivElm = projectsElm;
      hideDivElm = resumeElm;
    } else {
      pushStateLocation = "resume";

      showDivElm = resumeElm;
      hideDivElm = projectsElm;
    }
  
    pushState(pushStateLocation);

    addClass(showDivElm, "lower");
    removeClass(hideDivElm, "lower");
  };
  
  var pushState = function (pushStateLocation) {
    if (history !== undefined && history.pushState !== undefined) {
      history.pushState({}, "", pushStateLocation);
    }
    
    ga("send", "pageview", "/" + pushStateLocation);
  };
  
  var removeClass = function (el, className) {
    if (el.classList) {
      el.classList.remove(className);
    } else {
      var regex = new RegExp('(^|\\b)' + className + '(\\b|$)', 'gi');
      el.className = el.className.replace(regex, ' ');
    }
  };
  
  addContact();
  addEvents();
})();
