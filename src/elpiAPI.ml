(** This file will transpile to elpiApi.bc.js and
  * its role is to summon the ELpi Worker and
  * dialogue with it. It gives users a simple API
  * to manage this process *)

(* TODO : for now this is implemented directly in JS *)

let onMessage e = 
  print_string "totoro";
  let action = Js.to_string e##.data##.type_ in
  (match action with
  | "log" -> print_string (Js.to_string e##.data##.text);
  | _ -> print_string ("Unknown action \"" ^ action ^ "\"."));
  Js._true

let worker = Js.Unsafe.global##._Worker
let worker = new%js worker (Js.string "elpi-worker.js")

let () =
  worker##.onmessage := Dom_html.handler(onMessage);

  let message = object%js (self) (* Equivalent of this *)
    val type_ = Js.string "query" 
    val code = Js.string "lecode"
  end in
  print_string "before";
  worker##postMessage(message) 
  