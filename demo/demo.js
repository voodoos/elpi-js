import Elpi from "./elpi-api.js";

function log(l, p, t) {
  console.log(l, p, t);
  let child = document.createElement("div");
  child.innerHTML = "Log (" + l + ") : [ " + p + "] : " + t;
  document.getElementById("console")
    .appendChild(child)
}

function answer(vals) {
  log("answer", "", JSON.stringify(vals, null, 4));
}

const elp = new Elpi(log, answer);

elp.compile([{
  name: "toto.elpi",
  content: "world \"hello\". world \"pussycat\"."
}]);

elp.queryAll("world A.");