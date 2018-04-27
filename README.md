# Elpi-js

This project aims to provide an easy way to use the *Elpi lambda-prolog interpreter* ([homepage here](https://github.com/LPCIC/elpi/)), written in OCaml, in a completely web based setting.

See the [DEMO](https://voodoos.github.io/elpi-js/demo).

## What's in

This is done in a three step process :

- The Elpi_api in OCaml is compiled into a web worker using the [js_of_ocaml]() compiler. It creates the `lib/elpi-js.js` file from `.ml` sources in the `src` folder.
- A small API is given to handle the lifecycle of the worker and communicate with it in the `lib/elpi-api.js` file.
- Finally a set of bindings for ReasonML is provided [TODO] for easy use of the api in web oriented projects.

## Node-based project
The project is not yet published to npm, but you can add it to your project via git :
```
yarn add https://github.com/voodoos/elpi-js
```

And then simply use the javascript sources in the `node_modules/elpi-js/lib` folder or ask `bsb`to use the Reason bindings by adding `elpi-js` to `bs-dependencies` in your `bsconfig.json`.

## Usage

Once the `elpi-api.js` file is loaded you can easily create a new Elpi worker by instantiating the `elpi` class with some callback functions for handling the results :
```
function log(l, p, t) { 
      console.log(l, p, t);
}

function answer(arg, ass) {
      console.log(arg, ass);
}

const elp = new Elpi(log, answer);
```

You can then send program to compile to Elpi :
```
elp.compile([{ name: "toto.elpi", 
               content: "world \"hello\". world \"pussycat\"."}]);
```

And query them :
```
elp.queryAll("world A.");
```

## API documentation

```js
/**
 * @file Elpi-api
 * This file provide a small api to communicate
 * with elpi-worker to run lambda-prolog programs
 * in the browser
 *
 */

function generateUUID() { // Public Domain/MIT
  var d = new Date().getTime();
  if (typeof performance !== 'undefined' && typeof performance.now === 'function'){
      d += performance.now(); //use high-precision timer if available
  }
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
      var r = (d + Math.random() * 16) % 16 | 0;
      d = Math.floor(d / 16);
      return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
  });
}

/**
 *  The main class, handling the lifecycle of
 * the Elpi Worker. 
 * 
 * */
class Elpi {
  /**
   * Creates a worker.
   * 
   * @callback loggerCB
   *    @param {string} lvl 
   *       The log level (Info, Warning or Error).
   *    @param {string} prefix
   *       The prefix, "who" sent the message.
   *    @param {string} text
   *       The text of the message
   *  The callback used when the Worker asks for logging
   * 
   * @callback answerCB
   *    @param {array(string)} args 
   *       The args of the answer
   *    @param {array(string)} assignements
   *       The assignements of the args
   *  The callback used when the Worker gives an answer
   * 
   */
  constructor(loggerCB, answerCB);

  /**
   * Sends some files for compilation to the Worker.
   * It returns a promise.
   * At the end of the execution the worker will resolve
   * the promise with a status message. Or reject it with
   * an error message.
   * 
   * @param {array({name: string, content: string})} files
   *   An array of files. Files are describded using two
   * strings: the name of the file and its content.
   *   All files in the array will be compiled and ready
   * to be queried (if no errors where found)
   * 
   * @returns {Promise}
   */
  compile(files);


  /**
   * Sends the query to the worker. The worker will
   * then send successivley all the answers to that query.
   * It also returns a promise. 
   * At the end of the execution the worker will resolve
   * the promise with the array of all answers.
   * Or reject it with an error message.
   * 
   * @param {string} code
   *   The code of the query. It must end by a dot.
   *   For example "plus 2 4 Res."
   * 
   * @returns {Promise}
   */
  queryAll(code);

  /**
   * Stop and restart the Elpi Worker
   * 
   * Returns a promise which is stored 
   * in the start property.
   * 
   * @returns {Promise}
   */
  restart();

}

export default Elpi;
```
