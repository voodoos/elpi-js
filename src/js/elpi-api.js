/**
 * @file Elpi-api
 * This file provide a small api to communicate
 * with elpi-worker to run lambda-prolog programs
 * in the browser
 *
 */

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
    * @param {array(string)} args 
    *   The args of the answer
    * @param {array(string)} assignements
    *   The assignements of the args
    *  of the answer
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
  constructor(loggerCB, answerCB) {
    this.worker = null;

    this.logger = loggerCB;
    this.answer = answerCB;
    
    /* Message from the Elpi worker are 
    treated by the following function */
    this.onmessage = function (event) {
      var d = event.data;
      
      switch (d.type) {
          case "answer":
              answerCB(d.args, d.assignments);
              break;
          case "log":
              loggerCB(d.lvl, d.prefix, d.text);
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
    var message = { type: "compile", files };
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
  queryAll(code) {
    var message = { type: "queryAll", code };
    this.worker.postMessage(message);
  }

  /**
   * Stop and restart the Elpi Worker
   * 
   */
  restart() {
    this.worker.terminate();
    this.start();
  }
  
}

export default Elpi;