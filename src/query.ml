exception No_program
exception Query_failed

let prog = ref None

let get_prog () =
  match !prog with
    None -> raise No_program
  | Some(p) -> p

  

(* Parsing and compiling files *)
let parse_and_compile files =
  let parsed_prog =  Elpi_API.Parse.program files in
  Elpi_API.Compile.program [parsed_prog]

let load files = 
  prog := Some(parse_and_compile files)

(* Parsing and compiling query *)
let prepare_query prog query =
  let parsed_query = Elpi_API.Parse.goal query in
  Elpi_API.Compile.query prog parsed_query

let query_once q =
  let prog = get_prog () in
  let compiled_query = prepare_query prog q in

  (* TODO ElpiTODO : static check *)

  match (Elpi_API.Execute.once prog compiled_query) with
    Success(data) -> data
    | Failure -> raise Query_failed
    | NoMoreSteps -> raise Query_failed