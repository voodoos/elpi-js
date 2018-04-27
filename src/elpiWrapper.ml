exception No_program
exception StaticCheck_failed
exception Query_failed

let header = ref None
let prog = ref None

let get_prog () =
  match !prog with
    None -> raise No_program
  | Some(p) -> p

let get_header () =
  match !header with
    None -> raise No_program
  | Some(h) -> h


(* Callback handling is a bit tricky : messages cannot
 * carry functions so we use unique ids *)
let sendCallbackOrder ?b:(b=true) (payload: 'a Js.t) uuid  =
  let open Js in
  let message = object%js (self) (* Equivalent of this *)
    val type_ = string (if b then "resolve" else "reject")
    val uuid = string uuid
    val value = payload
  end in
  Worker.post_message(message)

let resolve uuid value  = sendCallbackOrder value uuid
let reject uuid err  = sendCallbackOrder ~b:false err uuid

let start () =
  try 
    let h, _ = Elpi_API.Setup.init [] ~builtins:(Elpi_builtin.std_builtins) ~basedir:"" ~silent:false  in
    (* In Elpi_API 1.0 we need to keep that header to feed it to the compiler *)
    header := Some(h);
    (* TODO ElpiTODO : when not silent Elpi prints info on file already-loaded on stderr not stdout *)
    resolve "start" (Js.string "Elpi started.")
  with e -> (* TODO: wrong *)
      (* TODO ElpiTODO : Elpi raise various exceptions on file not found for exemple, 
          but we can't catch them without a catch all clause... *)
      reject "start" (Js.string (Printexc.to_string e))

(* Parsing and compiling files *)
let parse_and_compile files =
  let parsed_prog =  Elpi_API.Parse.program files in
  Elpi_API.Compile.program (get_header ()) [parsed_prog]
  (* TODO ElpiTODO : 
  
    Numerous errors from Elpi for all the externals in pervasives.elpi :
    [Elpi] External new_safe not declared
    ...
  *)

let load files = 
  prog := Some(parse_and_compile files)

(* Parsing and compiling query *)
let prepare_query prog query =
  let parsed_query = Elpi_API.Parse.goal query in
  let compiled_query = Elpi_API.Compile.query prog parsed_query in
  
  (* We run Elpi's statick checks *)
  if (not (Elpi_API.Compile.static_check 
          (get_header ())
          compiled_query)) 
    (* TODO ElpiTODO : output done on sdout, should use Warning / errors *)
    then  raise StaticCheck_failed; 
  (* We compile *)
  Elpi_API.Compile.link compiled_query

let query_once q =
  let prog = get_prog () in
  let executable = prepare_query prog q in

  match (Elpi_API.Execute.once executable) with
    Success(data) -> data
    | Failure -> raise Query_failed
    | NoMoreSteps -> raise Query_failed


let query_loop q more each =
  let prog = get_prog () in
  let executable = prepare_query prog q in

  Elpi_API.Execute.loop executable
                        more
                        each
  