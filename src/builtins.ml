let types = ref [||]

let make () = 
    let open Elpi_API.Extend.BuiltInPredicate in
    builtin_of_declaration 
      ([MLCode(
        Pred("js_dummy",
          Easy "js_dummy is a dummy pred for dummy purposes (type-check at compile time).",
          fun ~depth:_ -> ()
        ),
        DocAbove 
      );
      MLCode(
        Pred("js_info",
          In(string, "P", 
            In(string, "M", Easy "js_info P M sends an info message M with prefix P.")),
          fun p m ~depth:_ -> Log.info m ~prefix:p
        ),
        DocAbove 
      );
      MLCode(
        Pred("js_warn",
          In(string, "P", 
            In(string, "M", Easy "js_warn P M sends a warning message M with prefix P.")),
          fun p m ~depth:_ -> Log.warning m ~prefix:p
        ),
        DocAbove 
      );
      MLCode(
        Pred("js_err",
          In(string, "P", 
            In(string, "M", Easy "js_err P M sends an error message M with prefix P.")),
          fun p m ~depth:_ -> Log.error m ~prefix:p
        ),
        DocAbove 
      );
      MLCode(
        Pred("js_types",
          In(list any, "LN",
            In(list any, "LT", 
              Easy "js_types LT sends the list of types LT to the OCaml worker (used during statick check).")),
          fun ln lt ~depth:_ -> 
            let open Elpi_API.Extend.Data in
            let typs = List.rev_map2 (fun n t -> 
              let name = (match (Elpi_API.Extend.Data.look 0 n) with
                        | CData(c) -> Elpi_API.Extend.Data.C.to_string c
                        | _ -> failwith "Not a string") 
              in
              let typ = (match (Elpi_API.Extend.Data.look 0 t) with
                        | CData(c) -> Elpi_API.Extend.Data.C.to_string c
                        | _ -> failwith "Not a string") 
              in 
              object%js (self) (* Equivalent of this *)
                val name = Js.string name
                val type_ = Js.string typ
              end) ln lt
            in
            types := Array.of_list typs
        ),
        DocAbove 
      )] @ Elpi_builtin.std_declarations)