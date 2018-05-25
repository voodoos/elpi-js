exception Elpi_error


let answer assignments =
  let open Js in
  let message = object%js (self) (* Equivalent of this *)
    val type_ = string "answer" 
    val values = ToJs.arrayOfAssignements assignments
  end in
  Worker.post_message(message)

(* Elpi workflow functions *)

(** The load function populate the pseudo filesystem
  * with the users files and ask Elpi to compile them *)
  let load files =
    let filenames = 
      Array.to_list (Array.map (fun (name, content) ->
        Sys_js.update_file name content; (* Populating *)
        name) files) 
    in
    try ElpiWrapper.load filenames
    with 
    | ElpiWrapper.StaticCheck_failed -> raise ElpiWrapper.StaticCheck_failed
    | e -> Log.error (Printexc.to_string e); raise Elpi_error
  
  let queryOnce q = 
    try 
      let sol : Elpi_API.Data.solution = ElpiWrapper.query_once q in
      let assignments = StringTools.list_of_sol sol in
      answer assignments;
      assignments
    with ElpiWrapper.No_program -> raise ElpiWrapper.No_program
  
  let queryAll q = 
    let res = ref [] in
    let loop_answer f (out : Elpi_API.Execute.outcome) =
      (* print_string ("\nIter "^ (string_of_float f) ^ ":\n");*)
      match out with
      | Success(sol) -> 
        let assignments = StringTools.list_of_sol sol in
        res := assignments::!res;
        answer assignments
      | NoMoreSteps -> ()
      | Failure -> () (*raise ElpiWrapper.Query_failed*) (* ElpiTODO : looks like NoMoreSteps is never reached *)
    in
    try 
      ElpiWrapper.query_loop q (fun () -> true
      (* TODO : not satifying, we want to ask user !
       * But complcated, three options :
       *  - Elpi hack (easy, costly) (running loop twice for second result etc..)
       *  - A different Elpy query function : start, next, end *)
      ) (loop_answer);
      !res
    with ElpiWrapper.No_program -> raise ElpiWrapper.No_program
  
