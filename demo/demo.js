
  
  function log(l, p, t) { 
    console.log(l, p, t);
  }

  function answer(arg, ass) {
    console.log(arg, ass);
  }
  
  const elp = new Elpi(log, answer);
  
  elp.compile([["toto.elpi", 
                "hello \"world\". hello \"pussycat\"."]]);
  
 elp.queryAll("hello A.");