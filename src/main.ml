open Js_of_ocaml

exception Elpi_error
exception Unknown_action

(** This file is the main program running Elpi. 
  * It compiles to elpi-worker.js which is run
  * as a web worker *)

(* The onmessage function is critical for a web worker *)
let onMessage e = 
  let jsPairStringArrayToML jpsa =
    Array.map (fun obj -> 
      (*let arr = Js.to_array arr in*)
      let n = obj##.name and c = obj##.content in
     (Js.to_string n), (Js.to_string c)) (Js.to_array jpsa)  
  in

  let open ElpiWrapper in
  let action = Js.to_string e##.type_
  and uuid = Js.to_string e##.uuid in

  try 
    match action with
    | "compile" ->
      Query.load (jsPairStringArrayToML e##.files) (Js.to_bool e##.check);
      let types = Js.array (Array.map Js.string!Builtins.types ) in
      resolve uuid types
    | "queryOnce" -> 
      let answer = Query.queryOnce(Js.to_string e##.code) in
      resolve uuid (ToJs.arrayOfAssignements answer)
    | "queryAll" ->  
      let answers = Query.queryAll(Js.to_string e##.code) in
      resolve uuid (ToJs.list (List.map (ToJs.arrayOfAssignements) answers))
    | _ -> raise Unknown_action
  
  (* TODO ElpiTODO : Elpi raises various exceptions on file not found for exemple, 
      but we can't catch them without a catch all clause...
      How to get line and character indication, precie error mesage ? *)
    with 
    | Unknown_action -> 
        reject uuid (Js.string "Unknown action")
    | No_program -> 
        reject uuid (Js.string "No program to query.")
    | Query_failed ->
        reject uuid (Js.string "Query failed.")
    | StaticCheck_failed -> 
        reject uuid (Js.string "Static check failed, cancelling.")
    | ex ->
        let mess = (Printexc.to_string ex) in
        reject uuid (Js.string  mess)
    
(** Main *)
let () =   
  Printexc.record_backtrace true;
  
  (** Loading data folder in the pseudo-filesystem 
    * Elpi needs some files to startup, they are packed in data.ml *)
  Log.debug "Populating the pseudo-file-system...";
  Data.load ();

  (* Plugin the "onmessage" function of the Worker *)
  Worker.set_onmessage onMessage;

  (* Redirect standard outputs to logging *)
  Sys_js.set_channel_flusher stdout (Log.info ~prefix:"stdout");
  Sys_js.set_channel_flusher stderr (Log.error ~prefix:"stderr");

  (* Configuring Elpi outputs *)
  let open Elpi.API.Setup in begin
    set_warn (fun ?loc:_ s -> Log.warning s);
    set_error (fun ?loc:_ s -> Log.error s);
    set_anomaly (fun ?loc:_ s -> Log.warning s);
    set_type_error (fun ?loc:_ s -> Log.error s)
  end;
  
  (** Initializing ELpi 
   * Needs lp-syntax.elpi 
   * to be loaded in the pseudo-filesystem *)
  Log.debug "Starting Elpi...";

  ElpiWrapper.start();
