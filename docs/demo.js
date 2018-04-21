
  
  function log(l, p, t) { 
    console.log(l, p, t);
    child = document.createElement("div");
    child.innerHTML = "Log (" + l + ") : [ " + p + "] : " + t;
    document.getElementById("console")
    .appendChild(child)
  }

  function answer(arg, ass) {
    log("answer", "",  JSON.stringify(arg, null, 4) +  JSON.stringify(ass, null, 4));
  }
  
  const elp = new Elpi(log, answer);

  elp.compile([{ name: "toto.elpi", 
                content: "world \"hello\". world \"pussycat\"."}]);
  
 elp.queryAll("world A.");