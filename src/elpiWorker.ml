exception Elpi_error

(** This file is the main program running Elpi. 
  * It compiles to elperi-work.bc.js which is run as
  * a web worker *)

(* The onmessage function is critical for a web worker *)
let onMessage e = 
  let jsPairStringArrayToML jpsa =
    Array.map (fun arr -> 
      let arr = Js.to_array arr in
      let n = arr.(0) and c = arr.(1) in
      Log.debug (Js.to_string n); Log.debug (Js.to_string c);
     (Js.to_string n), (Js.to_string c)) (Js.to_array jpsa) 
  in
  let action = Js.to_string e##.type_ in
  match action with
  | "compile" -> ElpiWrapper.load(jsPairStringArrayToML e##.files)
  | "queryOnce" -> ElpiWrapper.queryOnce(Js.to_string e##.code)
  | "queryAll" -> ElpiWrapper.queryAll(Js.to_string e##.code)
  | _ -> Log.error ("Unknown action \"" ^ action ^ "\".")



    
(** Main *)
let () =   
  Printexc.record_backtrace true;
  print_string "worker started";
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
    (* TODO ElpiTODO : when not silent Elpi prints info on stderr not stdout *)
    Log.info "Elpi started."
  with e -> 
      (* TODO ElpiTODO : Elpi raise various exceptions on file not found for exemple, 
          but we can't catch them without a catch all clause... *)
      Log.error (Printexc.to_string e); 
      raise Elpi_error
