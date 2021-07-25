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
let sendCallbackOrder ?b:(b=true) (payload: 'a Js_of_ocaml.Js.t) uuid  =
  let open Js_of_ocaml.Js in
  let message = object%js (self) (* Equivalent of this *)
    val type_ = string (if b then "resolve" else "reject")
    val uuid = string uuid
    val value = payload
  end in
  Js_of_ocaml.Worker.post_message(message)

let resolve uuid value  = sendCallbackOrder value uuid
let reject uuid err  = sendCallbackOrder ~b:false err uuid

let start () =
  try 
    let flags =
      let open Elpi.API.Compile in
      {
        default_flags with
        print_passes = false;
        print_units = true;
      } |> to_setup_flags
    in
    let h, _ = Elpi.API.Setup.init ~flags ~builtins:[Builtins.make ()] ~basedir:"" [] in
    (* In Elpi_API 1.0 we need to keep that header to feed it to the compiler *)
    header := Some(h);
 
    (*Elpi_API.Extend.BuiltInPredicate.document Format.std_formatter (Builtins.declarations @ Elpi_builtin.std_declarations);*)

    (* TODO ElpiTODO : when not silent Elpi prints info on file already-loaded on stderr not stdout *)
    resolve "start" (Js_of_ocaml.Js.string "Elpi started.")
  with e -> (* TODO: wrong *)
    (* TODO ElpiTODO : Elpi raise various exceptions on file not found for exemple, 
        but we can't catch them without a catch all clause... *)
    reject "start" (Js_of_ocaml.Js.string (Printexc.to_string e))

(* Parsing and compiling query *)
let prepare_query prog query =
  let parsed_query = 
    Elpi.API.(Parse.goal (Ast.Loc.initial "") query) in
  let compiled_query = Elpi.API.Compile.query prog parsed_query in
  
  (* We run Elpi's statick checks *)
  if (not (Elpi.API.Compile.static_check 
          ~checker:(Elpi.Builtin.default_checker ())
          compiled_query)) 
    (* TODO ElpiTODO : output done on sdout, should use Warning / errors *)
    then  raise StaticCheck_failed; 
  (* We compile *)
  Elpi.API.Compile.optimize compiled_query

let parse_and_compile files check =
  let elpi = get_header () in
  let parsed_prog =  Elpi.API.Parse.program ~elpi files in
  let compiled_prog = 
    Elpi.API.Compile.program ~elpi [parsed_prog] in

  (* We use a "dummy" query to do a first static check 
   * Elpi seems to need a query to do a static check *)
  if check then ignore (prepare_query compiled_prog "js_dummy.");

  compiled_prog

let load files check = 
  prog := Some(parse_and_compile files check)

let query_once q =
  let prog = get_prog () in
  let executable = prepare_query prog q in

  match (Elpi.API.Execute.once executable) with
    Success(data) -> data
    | Failure -> raise Query_failed
    | NoMoreSteps -> raise Query_failed


let query_loop q more each =
  let prog = get_prog () in
  let executable = prepare_query prog q in

  Elpi.API.Execute.loop executable
                        ~more
                        ~pp:each
