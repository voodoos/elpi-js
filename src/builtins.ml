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
      )] @ Elpi_builtin.std_declarations)