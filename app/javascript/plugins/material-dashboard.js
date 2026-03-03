/***********************
 *  CORE FUNCTIONS (UNCHANGED)
 ***********************/

function focused(e) {
  e.parentElement.classList.contains("input-group") &&
    e.parentElement.classList.add("focused");
}

function defocused(e) {
  e.parentElement.classList.contains("input-group") &&
    e.parentElement.classList.remove("focused");
}

function setAttributes(t, s) {
  Object.keys(s).forEach(function (e) {
    t.setAttribute(e, s[e]);
  });
}

function debounce(n, a, i) {
  var r;
  return function () {
    var e = this,
      t = arguments,
      s = i && !r;
    clearTimeout(r);
    r = setTimeout(function () {
      r = null;
      i || n.apply(e, t);
    }, a);
    s && n.apply(e, t);
  };
}

function getEventTarget(e) {
  return (e = e || window.event).target || e.srcElement;
}

function navbarBlurOnScroll(e) {
  let t = document.getElementById(e);
  if (!t) return;

  var s,
    scrollAttr = t.getAttribute("data-scroll");
  let n = ["blur", "shadow-blur", "left-auto"],
    a = ["shadow-none"];

  function i() {
    t.classList.add(...n);
    t.classList.remove(...a);
    l("blur");
  }

  function r() {
    t.classList.remove(...n);
    t.classList.add(...a);
    l("transparent");
  }

  function l(e) {
    var t = document.querySelectorAll(".navbar-main .nav-link"),
      s = document.querySelectorAll(".navbar-main .sidenav-toggler-line");
    if (e === "blur") {
      t.forEach((e) => e.classList.remove("text-body"));
      s.forEach((e) => e.classList.add("bg-dark"));
    } else {
      t.forEach((e) => e.classList.add("text-body"));
      s.forEach((e) => e.classList.remove("bg-dark"));
    }
  }

  window.onscroll = debounce(
    scrollAttr === "true"
      ? function () {
          (window.scrollY > 5 ? i : r)();
        }
      : function () {
          r();
        },
    10
  );

  if (navigator.platform.indexOf("Win") > -1) {
    s = document.querySelector(".main-content");
    if (!s) return;

    s.addEventListener(
      "ps-scroll-y",
      debounce(
        scrollAttr === "true"
          ? function () {
              (s.scrollTop > 5 ? i : r)();
            }
          : function () {
              r();
            },
        10
      )
    );
  }
}

function initNavs() {
  var total = document.querySelectorAll(".nav-pills");
  total.forEach(function (i) {
    if (i.querySelector(".moving-tab")) return;

    var r = document.createElement("div"),
      t = i.querySelector("li:first-child .nav-link").cloneNode();
    t.innerHTML = "-";
    r.classList.add("moving-tab", "position-absolute", "nav-link");
    r.appendChild(t);
    i.appendChild(r);

    r.style.padding = "0px";
    r.style.width =
      i.querySelector("li:nth-child(1)").offsetWidth + "px";
    r.style.transform = "translate3d(0px, 0px, 0px)";
    r.style.transition = ".5s ease";

    i.onmouseover = function (e) {
      let a = getEventTarget(e).closest("li");
      if (!a) return;

      let s = Array.from(a.closest("ul").children),
        n = s.indexOf(a) + 1;

      i.querySelector("li:nth-child(" + n + ") .nav-link").onclick =
        function () {
          let e = 0;
          if (i.classList.contains("flex-column")) {
            for (var t = 1; t <= s.indexOf(a); t++)
              e += i.querySelector("li:nth-child(" + t + ")").offsetHeight;
            r.style.transform = "translate3d(0px," + e + "px, 0px)";
            r.style.height =
              i.querySelector("li:nth-child(" + t + ")").offsetHeight;
          } else {
            for (t = 1; t <= s.indexOf(a); t++)
              e += i.querySelector("li:nth-child(" + t + ")").offsetWidth;
            r.style.transform = "translate3d(" + e + "px, 0px, 0px)";
            r.style.width =
              i.querySelector("li:nth-child(" + n + ")").offsetWidth + "px";
          }
        };
    };
  });
}

function toggleSidenav() {
  let body = document.body,
    sidenav = document.getElementById("sidenav-main"),
    className = "g-sidenav-pinned";

  if (!sidenav) return;

  body.classList.contains(className)
    ? (body.classList.remove(className),
      setTimeout(() => sidenav.classList.remove("bg-white"), 100),
      sidenav.classList.remove("bg-transparent"))
    : (body.classList.add(className),
      sidenav.classList.add("bg-white"),
      sidenav.classList.remove("bg-transparent"));
}

function navbarColorOnResize() {
  let sidenav = document.getElementById("sidenav-main");
  let ref = document.querySelector("[data-class]");
  if (!sidenav) return;

  if (window.innerWidth > 1200) {
    ref?.classList.contains("active") &&
    ref?.getAttribute("data-class") === "bg-transparent"
      ? sidenav.classList.remove("bg-white")
      : sidenav.classList.add("bg-white");
  } else {
    sidenav.classList.add("bg-white");
    sidenav.classList.remove("bg-transparent");
  }
}

function sidenavTypeOnResize() {
  let e = document.querySelectorAll('[onclick="sidebarType(this)"]');
  window.innerWidth < 1200
    ? e.forEach((e) => e.classList.add("disabled"))
    : e.forEach((e) => e.classList.remove("disabled"));
}

/***********************
 *  INIT PIPELINE (TURBO SAFE)
 ***********************/

function initDashboard() {
  // input focus handling
  document
    .querySelectorAll("input.form-control")
    .forEach((e) =>
      setAttributes(e, {
        onfocus: "focused(this)",
        onfocusout: "defocused(this)",
      })
    );

  // navbar blur
  document.getElementById("navbarBlur") &&
    navbarBlurOnScroll("navbarBlur");

  // nav pills
  setTimeout(initNavs, 100);

  // sidenav toggles
  document
    .getElementById("iconNavbarSidenav")
    ?.addEventListener("click", toggleSidenav);
  document
    .getElementById("iconSidenav")
    ?.addEventListener("click", toggleSidenav);

  navbarColorOnResize();
  sidenavTypeOnResize();
}

/***********************
 *  EVENT BINDINGS
 ***********************/

document.addEventListener("turbo:load", initDashboard);
document.addEventListener("turbo:render", initDashboard);
document.addEventListener("DOMContentLoaded", initDashboard);
window.addEventListener("resize", navbarColorOnResize);
window.addEventListener("resize", sidenavTypeOnResize);
