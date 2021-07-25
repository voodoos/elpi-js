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
          ( "js_types",
            In
              ( list string,
                "LN",
                In
                  ( list string,
                    "LT",
                    Easy
                      "js_types LN LT sends the list of types LT to the OCaml \
                       worker (used during static check)." ) ),
            fun ln lt ~depth:_ ->
              let typs =
                List.rev_map2
                  (fun n t ->
                    object%js (self)
                      (* Equivalent of this *)
                      val name = Js_of_ocaml.Js.string n

                      val ty = Js_of_ocaml.Js.string t
                    end)
                  ln lt
              in
              types := Array.of_list typs ),
        DocAbove );
  ]

let make () =
  Elpi.API.BuiltIn.declare ~file_name:"builtins.elpi"
    (declarations @ Elpi.Builtin.std_declarations)
