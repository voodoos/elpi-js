exception Elpi_error

(** This file is the main program running Elpi. 
  * It compiles to elperi-work.bc.js which is run as
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
    match action with
    | "compile" -> Query.load(jsPairStringArrayToML e##.files)
    | "queryOnce" -> Query.queryOnce(Js.to_string e##.code)
    | "queryAll" -> Query.queryAll(Js.to_string e##.code)
    | _ -> Log.error ("Unknown action \"" ^ action ^ "\".");
    flush_all ()
  
  (* TODO ElpiTODO : Elpi raises various exceptions on file not found for exemple, 
      but we can't catch them without a catch all clause...
      How to get line and character indication, precie error mesage ? *)
    with 
    | ElpiWrapper.Query_failed -> Log.warning ("No results."); flush_all ()
    | e -> Log.error ("Uncaught exception: \"" ^ (Printexc.to_string e) ^ "\"."); flush_all ()




    
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

  try 
    ignore(Elpi_API.Setup.init ~silent:false [] "");
    (* TODO ElpiTODO : when not silent Elpi prints info on file loading on stderr not stdout *)
    Log.info "Elpi started."
  with e -> 
      (* TODO ElpiTODO : Elpi raise various exceptions on file not found for exemple, 
          but we can't catch them without a catch all clause... *)
      Log.error (Printexc.to_string e); 
      raise Elpi_error
