import Elpi from "./share/elpi-js/elpi-api.js";
import tokenizer from "./lprolog.js";

const example = `type mappred (A -> B -> prop) -> list A -> list B -> prop.

mappred P nil nil.
mappred P (X::L) (Y::K) :- P X Y, mappred P L K.

kind name             type.
type bob, sue, ned    name.
type age              name -> int -> prop.
type male, female     name -> prop.

age  bob 23 & age sue 24 & age  ned 23.
male bob    & female sue & male ned.
`;

const color_of_level = level => {
  switch (level) {
    case 'info': return 'info';
    case 'warning': return 'warning';
    case 'error': return 'danger';
    default: return 'body';
  }
}

function log(l, p, t) {
  console.log(l, p, t);

  let child = document.createElement("div");
  child.className = 'text-' + color_of_level(l);
  child.innerHTML = "Log (" + l + ") : [ " + p + "] : " + t;
  document.getElementById("console")
    .prepend(child)
}

const results_body = document.getElementById('table-body');
var result_count = 0;

function answer(vals) {
  const num_vars = vals.length;
  if (vals.length > 0) {
    const first_row = document.createElement("tr");
    const th = document.createElement("th");
    th.setAttribute('rowspan', num_vars);
    th.setAttribute('scope', 'row');
    th.textContent = ++result_count;
    first_row.append(th);

    var rows = [];
    vals.forEach(assignement => {
      const td_arg = document.createElement("td");
      td_arg.textContent = assignement.arg;
      const td_ass = document.createElement("td");
      td_ass.textContent = assignement.ass;

      if (rows.length === 0) {
        first_row.append(td_arg, td_ass);
        rows.push(first_row);
      }
      else {
        const row = document.createElement("tr");
        row.append(td_arg, td_ass);
        rows.push(row);
      }
    });

    results_body.append(...rows);
  }
}

require(['vs/editor/editor.main'], function () {
  const container = document.getElementById('editor');
  const build_btn = document.getElementById('build');
  const restart_btn = document.getElementById('restart');
  const query_btn = document.getElementById('query');
  const query_text = document.getElementById('query_text');

  monaco.languages.register({ id: "lprolog" });
  monaco.languages.setMonarchTokensProvider(
    'lprolog',
    tokenizer
  )

  const editor = monaco.editor.create(container, {
    value: example,
    language: 'lprolog'
  });

  // Automatically resize editor
  var doit;
  window.onresize = function () {
    clearTimeout(doit);
    doit = setTimeout(() => editor.layout(), 100);
  };

  // We start Elpi
  const elp = new Elpi(log, answer, "./share/elpi-js/elpi-worker.bc.js");

  const on_start = _val => {
    log("info", "demo", "Elpi started");
    build_btn.removeAttribute('disabled');
    restart_btn.removeAttribute('disabled');
  };

  elp.start.then(on_start);

  build_btn.onclick = _ev => {
    query_btn.setAttribute('disabled', "true");
    build_btn.setAttribute('disabled', "true");
    elp.compile([{
      name: "demo.elpi",
      content: editor.getValue()
    }], true).then(val => {
      const values = val.filter(v => !v.startsWith('std.'));
      console.log("info", "Preds", JSON.stringify(values, null, 4));
      query_btn.removeAttribute('disabled');
    }).catch(err => {
      log("error", "demo", err);
    }).finally(_ => build_btn.removeAttribute('disabled'));
  }

  query_btn.onclick = _ev => {
    results_body.textContent = '';
    elp.queryAll(query_text.value).then(val => {
      console.log("info", "demo", JSON.stringify(val, null, 4));
    }).catch(err => {
      log("error", "demo", err);
    });
  };

  restart_btn.onclick = _ev => {
    build_btn.setAttribute('disabled', "true");
    restart_btn.setAttribute('disabled', "true");
    query_btn.setAttribute('disabled', "true");
    elp.restart().then(on_start);
  }
});
