
  
  function log(l, p, t) { 
    console.log(l, p, t);
  }

  function answer(arg, ass) {
    console.log(arg, ass);
  }
  
  const elp = new Elpi(log, answer);

  elp.compile([{ name: "toto.elpi", 
                content: "world \"hello\". world \"pussycat\"."}]);
  
 elp.queryAll("world A.");