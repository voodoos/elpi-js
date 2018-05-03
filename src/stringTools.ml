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
  
(* type arrow typ -> typ -> typ.
type tconst string -> typ.
type tapp list typ -> typ.
type prop typ.
type forall (typ -> typ) -> typ. % polymorphic type declarations
type ctype string -> typ. 

type typ = 
| Arrow of typ * typ
| App of typ * typ
| Forall of typ * typ
| Ctype of string
| Prop

let lcs = String.concat ""
let string_of_typ  = 
  let rec aux = function
  | Prop -> "prop"
  | Ctype(s) -> s
  | Arrow(t1, t2) -> lcs [aux t1; " -> ("; aux t2; ")"]
  | App(t1, t2) -> lcs [aux t1; " ("; aux t2; ")"]
  | Forall(t1, t2) -> lcs ["V"; aux t1; ", ("; aux t2; ")"]
  in
  aux

let to_typ_once term = 
  let open Elpi_API.Extend.Data in
  match (look 0 term) with
  | App(c, t , lt) -> 
    begin match (Constants.show c) with
    | "ctype" -> begin match (look 0 t) with
                 | CData(c) -> Ctype(C.to_string c)
                 | _ -> Ctype "Bad ctype" end 
    | "prop" -> Prop
    | "tapp"
    | _ -> Ctype "Unknown typ"
    end
  | _ -> Ctype "This is no typ"



let pp_type term = string_of_typ (to_typ_once term)*)