importScripts('elpiJs.bc.js');

function log(lvl, prefix, text) {
    let message = { type: "log", lvl: lvl, prefix, text };
    postMessage(message);
}

function answer(args, assignements) {
    let message = { type: "answer", args, assignements};
    postMessage(message);
}

/** The following function deals with  
 * messages received from the parent thread. */
onmessage = function(event) {
    switch (event.data.type) {
        case "compile":
            elpiCompile(event.data.code);
            break;
        case "queryOnce":
            elpiQueryOnce(event.data.code);
            break;
    }
}