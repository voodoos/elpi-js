(* Tools for priting Elpi results 
 * These results have the type Elpi_API.Data.solution 
 *
 * type solution = {
 *    assignments : term StrMap.t;
 *    constraints : syntactic_constraints;
 *    custom_constraints : custom_constraints;
 *}
 *
 *)

let string_list_of_args sm =
  let list = Elpi_API.Data.StrMap.bindings sm in
  List.map (fun (l, _) -> l) list

let string_list_of_assignements ass =
  let arr = Array.map 
    (fun term ->
    Elpi_API.Pp.term (Format.str_formatter) term;
    let str = Format.flush_str_formatter () in
    str)
    ass
  in
  Array.to_list arr

let string_list_of_assignements ass =
  let bindings = Elpi_API.Data.StrMap.bindings ass in
  List.map (fun (arg, term) -> 
      Elpi_API.Pp.term (Format.str_formatter) term;
      let str = Format.flush_str_formatter () in
      arg, str) bindings

let string_of_assignments ass =
  Elpi_API.Data.StrMap.fold
    (fun name term acc ->
      Elpi_API.Pp.term (Format.str_formatter) term;
      let str = Format.flush_str_formatter () in
       String.concat "" [acc; name; " := "; str])
ass ""

let string_of_constraints cons =
  Elpi_API.Pp.constraints (Format.str_formatter) cons;
  Format.flush_str_formatter ()
                             
let string_of_cconstraints cons =
  Elpi_API.Pp.custom_constraints (Format.str_formatter) cons;
  Format.flush_str_formatter ()

let string_of_sol (s : Elpi_API.Data.solution) =
  String.concat "" [
  "Assignments : "; (string_of_assignments (s.assignments))
  ; "\nConstraints : "; (string_of_constraints (s.constraints))
  ; "\nCustom constraints : "
  ; (string_of_cconstraints (s.custom_constraints))
  ; "\n"
  ]

let list_of_sol (sol : Elpi_API.Data.solution) =
  let assignments : (string * string) list = string_list_of_assignements sol.assignments in
  assignments
  
