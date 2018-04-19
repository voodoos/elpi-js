(** This file is the main program running Elpi. 
  * It compiles to main.bc.js which is run in
  * a web worker via the elpi-worker.js file *)

open ElpiWorkerBindings

(** Elpi workflow functions *)

(** Javascript API *)

(* let () =  
  Js.export "compile" (fun jstr -> compile (Js.to_string jstr)) ;
  Js.export "query"  (fun jstr -> query (Js.to_string jstr)) ;
  Js.export "run" run*)

let () =   
  (** Loading data folder in the pseudo-filesystem 
    * Elpi needs some files to startup, they are packed in data.ml *)
  log "Populating pseudo-file-system...";
  Data.load ();

  
  log "Starting Elpi...";
  (*ignore (Elpi_API.Setup.init ~silent:true [] "");*)
  log "Elpi started."

  