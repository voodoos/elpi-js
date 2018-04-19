(** This module contains bindings to some of the 
  * javascript functions defined in elpi-worker.js *)
  
let escape s =
  Js.to_string (Js.escape (Js.string s))

let unescape s =
  Js.Unsafe.fun_call (Js.Unsafe.js_expr "unescape") [|Js.Unsafe.inject s|]

let log s : unit =
  Js.Unsafe.fun_call (Js.Unsafe.js_expr "log") [|Js.Unsafe.inject (unescape (Js.string s))|]