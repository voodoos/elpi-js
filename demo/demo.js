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

elp.start.then(val => { 
  log("info", "ElpiProm", "toto"); 
});

var compilePromise = elp.compile([{
  name: "toto.elpi",
  content: 'world "hello". world "world".'
}], true);

compilePromise.then(val =>{
  log("info", "ElpiProm", JSON.stringify(val, null, 4));
}).catch(err => {
  log("error", "ElpiProm", err);
});

elp.queryAll("world A.").then(val => {
  log("info", "ElpiProm", JSON.stringify(val, null, 4));
}).catch(err => {
  log("error", "ElpiProm", err);
});


elp.queryAll("world A B.").then(val => {
  log("info", "ElpiProm", val);
}).catch(err => {
  log("error", "ElpiProm", err);

  elp.restart().then(val => {
    log("info", "ElpiProm", val);
  
    elp.queryAll("world A.").then(val => {
      log("info", "ElpiProm", JSON.stringify(val, null, 4));
    }).catch(err => {
      log("error", "ElpiProm", err);
    });
  }).catch(err => {
    log("error", "ElpiProm", err);
  });
});


