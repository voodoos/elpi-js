exception Elpi_error
exception Unknown_action

(** This file is the main program running Elpi. 
  * It compiles to elpi-worker.js which is run as
  * a web worker *)

(* The onmessage function is critical for a web worker *)
let onMessage e = 
  let jsPairStringArrayToML jpsa =
    Array.map (fun obj -> 
      (*let arr = Js.to_array arr in*)
      let n = obj##.name and c = obj##.content in
     (Js.to_string n), (Js.to_string c)) (Js.to_array jpsa)  
  in


  let action = Js.to_string e##.type_ in
  try 
    (match action with
    | "compile" -> 
      Query.load(jsPairStringArrayToML e##.files);
      (*Log.status "compile" Log.Finished ~details:"Files loaded"*)
    | "queryOnce" -> 
      Query.queryOnce(Js.to_string e##.code);
      (*Log.status "query" Log.Finished ~details:"End of query."*)
    | "queryAll" -> 
      Query.queryAll(Js.to_string e##.code);
      (*Log.status "query" Log.Finished ~details:"End of query."*)
    | _ -> raise Unknown_action);
    
    flush_all ();
    ElpiWrapper.resolve e##.uuid "Finished"
  
  (* TODO ElpiTODO : Elpi raises various exceptions on file not found for exemple, 
      but we can't catch them without a catch all clause...
      How to get line and character indication, precie error mesage ? *)
    with 
    | Unknown_action -> 
        ElpiWrapper.reject e##.uuid "Unknown action"
    | ElpiWrapper.No_program -> 
        ElpiWrapper.reject e##.uuid "No program to query."
    | ElpiWrapper.Query_failed ->
        ElpiWrapper.reject e##.uuid "Query failed."
    | ex ->
        let mess = "Uncaught: \"" ^ (Printexc.to_string ex) ^ "\"." in
        ElpiWrapper.reject e##.uuid mess




    
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
  let open Elpi_API.Setup in begin
    set_warn (Log.warning ~prefix:"Elpi");
    set_error (Log.error ~prefix:"Elpi");
    set_anomaly (Log.warning ~prefix:"Elpi");
    set_type_error (Log.error ~prefix:"Elpi")
  end;
  
  (** Initializing ELpi 
   * Needs lp-syntax.elpi 
   * to be loaded in the pseudo-filesystem *)
  Log.debug "Starting Elpi...";

  ElpiWrapper.start()
