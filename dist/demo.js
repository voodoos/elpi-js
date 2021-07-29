import Elpi from "./share/elpi-js/elpi-api.js";
import tokenizer from "./lprolog.js";

function log(l, p, t) {
  console.log(l, p, t);
  if (l != 'error') {
    let child = document.createElement("div");
    child.innerHTML = "Log (" + l + ") : [ " + p + "] : " + t;
    document.getElementById("console")
      .appendChild(child)
  }
}

function answer(vals) {
  log("answer", "", JSON.stringify(vals, null, 4));
}

// var compilePromise = elp.compile([{
//   name: "toto.elpi",
//   content: 'world "hello". world "world".'
// }], true);

// compilePromise.then(val =>{
//   log("info", "demo", JSON.stringify(val, null, 4));
// }).catch(err => {
//   log("error", "demo", err);
// });

// elp.queryAll("world A.").then(val => {
//   log("info", "demo", JSON.stringify(val, null, 4));
// }).catch(err => {
//   log("error", "demo", err);
// });


// elp.queryAll("world A B.").then(val => {
//   log("info", "demo", val);
// }).catch(err => {
//   log("error", "demo", err);

//   elp.restart().then(val => {
//     log("info", "demo", val);
  
//     elp.queryAll("world A.").then(val => {
//       log("info", "demo", JSON.stringify(val, null, 4));
//     }).catch(err => {
//       log("error", "demo", err);
//     });
//   }).catch(err => {
//     log("error", "demo", err);
//   });
// });

require(['vs/editor/editor.main'], function () {
  const container = document.getElementById('editor');
  const build_btn = document.getElementById('build');
  const restart_btn = document.getElementById('restart');
  const query_btn = document.getElementById('query');
  const query_text = document.getElementById('query_text');

  monaco.languages.register({ id: "lprolog"});
  monaco.languages.setMonarchTokensProvider(
    'lprolog',
    tokenizer
  )

  const editor = monaco.editor.create(container, {
    value: ['world "hello".', 'world "world".'].join('\n'),
    language: 'lprolog'
  });

  // We start Elpi
  const elp = new Elpi(log, answer, "./share/elpi-js/elpi-worker.bc.js");

  build_btn.onclick = _ev => 
    elp.compile([{
        name: "demo.elpi",
        content: editor.getValue()
      }], true).then(val =>{
          log("info", "demo", JSON.stringify(val, null, 4));
          query_btn.removeAttribute('disabled');
        }).catch(err => {
          log("error", "demo", err);
        });

  query_btn.onclick = _ev =>
    elp.queryAll(query_text.getValue()).then(val => {
        log("info", "demo", JSON.stringify(val, null, 4));
      }).catch(err => {
        log("error", "demo", err);
      });

  elp.start.then(_val => { 
    log("info", "demo", "Elpi started"); 
    build_btn.removeAttribute('disabled');
    restart_btn.removeAttribute('disabled');
  });
});
