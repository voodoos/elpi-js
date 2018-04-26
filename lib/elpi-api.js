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
    this.resolves = [];
    this.resolves["start"] = startCB;
    this.rejects  = []

    var that = this;
    /* Message from the Elpi worker are 
    treated by the following function */
    this.onmessage = function (event) {
      var d = event.data;
      console.log(d);
      switch (d.type) {
        case "answer":
          answerCB(d.values);
          break;
        case "log":
          loggerCB(d.lvl, d.prefix, d.text);
          break;
        case "resolve":
          /* If it's a callback message, we use the id to call 
           * the correct callback */
          that.resolves[d.uuid](d.value);
          if(d.uuid !== "start") {
            delete that.resolves[d.uuid];
            delete that.rejects[d.uuid];
          }
          break;
        case "reject":
          /* If it's a callback message, we use the id to call 
            * the correct callback */
          that.rejects[d.uuid](d.value);
          delete that.resolves[d.uuid];
          delete that.rejects[d.uuid];
          break;
      }
    }

    this.start();
  }

  /**
   * Starts the Elpi Worker
   * It must be in the same folder.
   */
  start() {
    this.worker = new Worker("elpi-worker.js");
    this.worker.onmessage = this.onmessage;
  }

  registerPromise(uuid, message) {
    var that = this;
    return new Promise(function (resolve, reject) {
      // save callbacks for later
      that.resolves[uuid] = resolve
      that.rejects[uuid] = reject
  
      that.worker.postMessage(message);
    }) 
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
  compile(files) {
    var uuid = generateUUID();
    var message = { type: "compile", files, uuid };

    return this.registerPromise(uuid, message)
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
    var uuid = generateUUID();
    var message = { type: "queryAll", code, uuid };

    return this.registerPromise(uuid, message)
  }

  /**
   * Stop and restart the Elpi Worker
   * 
   */
  restart(cb) {
    this.worker.terminate();
    this.start();
  }

}

export default Elpi;