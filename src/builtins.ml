let types = ref [||]

let declarations =
  let open Elpi.API.BuiltIn in
  let open Elpi.API.BuiltInData in
  [
    MLCode
      ( Pred
          ( "js_dummy",
            Easy
              "js_dummy is a dummy pred for dummy purposes (type-check at \
               compile time).",
            fun ~depth:_ -> () ),
        DocAbove );
    MLCode
      ( Pred
          ( "js_info",
            In
              ( string,
                "P",
                In
                  ( string,
                    "M",
                    Easy "js_info P M sends an info message M with prefix P." )
              ),
            fun p m ~depth:_ -> Log.info m ~prefix:p ),
        DocAbove );
    MLCode
      ( Pred
          ( "js_warn",
            In
              ( string,
                "P",
                In
                  ( string,
                    "M",
                    Easy "js_warn P M sends a warning message M with prefix P."
                  ) ),
            fun p m ~depth:_ -> Log.warning m ~prefix:p ),
        DocAbove );
    MLCode
      ( Pred
          ( "js_err",
            In
              ( string,
                "P",
                In
                  ( string,
                    "M",
                    Easy "js_err P M sends an error message M with prefix P." )
              ),
            fun p m ~depth:_ -> Log.error m ~prefix:p ),
        DocAbove );
    MLCode
      ( Pred
          ( "js_names",
            In
              ( list string,
                "LN",
                    Easy
                      "js_names LN LT sends the list of types LT to the OCaml \
                       worker (used during static check)." ),
            fun ln ~depth:_ ->
              types := Array.of_list ln
              ),
        DocAbove );
        MLCode
          ( Pred
              ( "js_type",
                In
                  ( list string,
                    "LN",
                        Easy
                          "js_type" ),
                fun l ~depth:_ -> match l with
                | name::typ::[] when Array.mem name !types ->
                  Format.eprintf "Type: %s %s\n%!" name typ;
                | _ -> ()
                  ),
            DocAbove );
  ]

let make () =
  Elpi.API.BuiltIn.declare ~file_name:"builtins.elpi"
    (declarations @ Elpi.Builtin.std_declarations)
