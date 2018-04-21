exception Elpi_error


let answer args assignments =
  let toJSStringArray l = 
    Js.array (Array.of_list (List.map (Js.string) l))
  in
  let open Js in
  let message = object%js (self) (* Equivalent of this *)
    val type_ = string "answer" 
    val args = toJSStringArray args
    val assignments = toJSStringArray assignments
  end in
  Worker.post_message(message)

(* Elpi workflow functions *)

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
      let args, assignments = StringTools.list_of_sol sol in
      answer args assignments
    with Query.No_program -> Log.error "No program to query."
  
  let queryAll q = 
    let loop_answer f (out : Elpi_API.Execute.outcome) =
      (* print_string ("\nIter "^ (string_of_float f) ^ ":\n");*)
      match out with
      | Success(sol) -> 
        let args, assignments = StringTools.list_of_sol sol in
        answer args assignments
      | NoMoreSteps -> ()
      | Failure -> raise Query.Query_failed
    in
    try 
      Query.query_loop q (fun () -> true
      (* TODO : not satifying, we want to ask user !
       * But complcated, three options :
       *  - Lwt ? (subtil, best)
       *  - Elpi hack (easy, costly) (running loop twice for second result etc..)
       *  - A different Elpy query function : start, next, end *)
      ) (loop_answer)
    with Query.No_program -> Log.error "No program to query."
  