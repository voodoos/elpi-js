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
    * @callback loggerCB
    * @param {string} lvl 
    *   The log level (Info, Warning or Error).
    * @param {string} prefix
    *   The prefix, "who" sent the message.
    * @param {string} text
    *   The text of the message
    */


  /** 
    * @callback answerCB
    * @param {array({arg: string, ass: string})} values 
    *   An array containing pairs argument / assignement
    */

  /**
   * Creates a worker.
   * 
   * @param {loggerCB}
   *  The callback used when the Worker asks for logging
   * @param {answerCB} 
   *  The callback used when the Worker gives an answer
   *
   */
  constructor(loggerCB, answerCB, startCB) {
    this.worker = null;

    this.logger = loggerCB;
    this.answer = answerCB;

    /* We cannot send directly callbacks to the worker
     * because functiosn are not clonable.
     * What we do is storing the callback with a unique
     * id and sending the id to the worker. When the worker 
     * finishes its work it sends back the id and 
     * the callback is called.
     */
    this.callbacks = [];
    this.defaultCallback = (success, mess) => {
      if(success) loggerCB("info", "ElpiCB", mess)
      else loggerCB("error", "ElpiCB", mess)
    };

    var that = this;
    /* Message from the Elpi worker are 
    treated by the following function */
    this.onmessage = function (event) {
      var d = event.data;

      switch (d.type) {
        case "answer":
          answerCB(d.values);
          break;
        case "log":
          loggerCB(d.lvl, d.prefix, d.text);
          break;
        case "callback":
          /* If it's a callback message, we use the id to call 
           * the correct callback */
          that.callbacks[d.id](d.success, d.message);
      }
    }

    this.start(startCB);
  }

  /**
   * Starts the Elpi Worker
   * It must be in the same folder.
   */
  start(cb) {
    if(cb != undefined) this.callbacks["start"] = cb;
    else this.callbacks["start"] = this.defaultCallback;

    this.worker = new Worker("elpi-worker.js");
    this.worker.onmessage = this.onmessage;
  }

  registerCB(cb) {
    var uuid = generateUUID();

    if(cb != undefined) this.callbacks[uuid] = cb;
    else this.callbacks[uuid] = this.defaultCallback;

    return uuid;
  }

  /**
   * Sends the query to the worker. The worker will
   * then send successivley all the answers to that query.
   * 
   * @param {array({name: string, content: string})} files
   *   An array of files. Files are describded using two
   * strings: the name of the file and its content.
   *   All files in the array will be compiled and ready
   * to be queried (if no errors where found)
   * 
   */
  compile(files, cb) {
    var uuid = this.registerCB(cb);
    var message = { type: "compile", files, cb: uuid };

    this.worker.postMessage(message);
  }


  /**
   * Sends the query to the worker. The worker will
   * then send successivley all the answers to that query.
   * 
   * @param {string} code
   *   The code of the query. It must end by a dot.
   *   For example "plus 2 4 Res."
   * 
   */
  queryAll(code, cb) {
    var uuid = this.registerCB(cb);
    var message = { type: "queryAll", code, cb: uuid };

    this.worker.postMessage(message);
  }

  /**
   * Stop and restart the Elpi Worker
   * 
   */
  restart(cb) {
    this.worker.terminate();
    this.start(cb);
  }

}

export default Elpi;