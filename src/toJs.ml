open Js_of_ocaml

let list t = Js.array (Array.of_list t)

let arrayOfAssignements ?(fl = Js.string) ?(fr = Js.string) asss =
  Js.array
    (Array.of_list
       (List.map
          (fun (arg, ass) ->
            object%js (self)
              (* Equivalent of this *)
              val arg = fl arg

              val ass = fr ass
            end)
          asss))
