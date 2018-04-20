/* Message from the Elpi worker are 
   treated by the following function */
function onMessage(event) {
    switch (event.data.type) {
        case "answer":
            console.log(event.data);
            break;
        case "log":
            console.log(event.data);
            break;
    }
}

var elpi = new Worker('js/elpi-worker.js');
/* Binding the onMessage function to the worker */
elpi.onmessage = onMessage;