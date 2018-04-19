(** This file is the main program running Elpi. 
  * It compiles to main.bc.js which is run in
  * a web worker via the elpi-worker.js file *)

(** Elpi workflow functions *)

(** Javascript API *)

(* let () =  
  Js.export "compile" (fun jstr -> compile (Js.to_string jstr)) ;
  Js.export "query"  (fun jstr -> query (Js.to_string jstr)) ;
  Js.export "run" run*)

let () =   
  (** Loading data folder in the pseudo-filesystem 
    * Elpi needs some files to startup, they are packed in data.ml *)
  Log.debug "Populating pseudo-file-system...";
  Data.load ();


  (* Configuring Elpi outputs *)
  Elpi_API.Setup.set_warn (Log.warning ~prefix:"Elpi");
  Elpi_API.Setup.set_error (Log.error ~prefix:"Elpi");
  Elpi_API.Setup.set_anomaly (Log.warning ~prefix:"Elpi");
  Elpi_API.Setup.set_type_error (Log.error ~prefix:"Elpi");
  
  Log.info "Starting Elpi...";
  ignore (Elpi_API.Setup.init ~lp_syntax:"data/lp-syntax.elpi" ~silent:false [] "");
  Log.info "Elpi started."

  