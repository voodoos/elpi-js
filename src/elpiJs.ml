(** This file is the main program running Elpi. 
  * It compiles to main.bc.js which is run in
  * a web worker via the elpi-worker.js file *)

exception Elpi_error

(** Elpi workflow functions *)

(** The load function populate the pseudo filesystem
  * with the users files and ask Elpi to compile them *)
let load files =
  let filenames = 
    Array.to_list (Array.map (fun (name, content) ->
      Sys_js.update_file name content; (* Populating *)
      name) files) in
  try Query.load filenames
  with e -> Log.error (Printexc.to_string e); raise Elpi_error

let queryOnce q =
  try 
    let sol : Elpi_API.Data.solution = Query.query_once q in
    let args = StringTools.string_list_of_args sol.arg_names in
    let assignments = StringTools.string_list_of_assignements sol.assignments in
    WorkerBindings.answer args assignments
  with Query.No_program -> Log.error "No program to query."



(** Javascript API *)
let () =  
  (** It's easy to communicate with Js arrays via js_of_ocaml
    * We encode (string, string) array as (string array[2]) array   
    *)
  let jsPairStringArrayToML jpsa =
    Array.map (fun arr -> 
      let arr = Js.to_array arr in
      let n = arr.(0) and c = arr.(1) in
      Log.debug (Js.to_string n); Log.debug (Js.to_string c);
     (Js.to_string n), (Js.to_string c)) (Js.to_array jpsa) 
  in
  Js.export "elpiCompile" (fun jstrarr -> 
    load (jsPairStringArrayToML jstrarr));
  Js.export "elpiQueryOnce"  (fun jstr -> 
    queryOnce (Js.to_string jstr))
  (* Js.export "run" run *)



(** Main *)
let () =   
  Printexc.record_backtrace true;

  (** Loading data folder in the pseudo-filesystem 
    * Elpi needs some files to startup, they are packed in data.ml *)
  Log.debug "Populating the pseudo-file-system...";
  Data.load ();


  (* Redirect standard outputs to logging *)
  Sys_js.set_channel_flusher stdout (Log.info ~prefix:"stdout");
  Sys_js.set_channel_flusher stderr (Log.error ~prefix:"stderr");

  (* Configuring Elpi outputs *)
  Elpi_API.Setup.set_warn (Log.warning ~prefix:"Elpi");
  Elpi_API.Setup.set_error (Log.error ~prefix:"Elpi");
  Elpi_API.Setup.set_anomaly (Log.warning ~prefix:"Elpi");
  Elpi_API.Setup.set_type_error (Log.error ~prefix:"Elpi");
  
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