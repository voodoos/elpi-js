(** This module contains bindings to some of the 
  * javascript functions defined in elpi-worker.js *)
  
let escape s =
  Js.to_string (Js.escape (Js.string s))

let unescape s =
  Js.Unsafe.fun_call (Js.Unsafe.js_expr "unescape") [|Js.Unsafe.inject s|]

(* TODO : really safe ? really needed ? *)
let safeStr s = unescape (escape s)

let log lvl prefix s : unit =
  Js.Unsafe.fun_call (Js.Unsafe.js_expr "log") 
  [|Js.Unsafe.inject  (Js.string lvl); 
    Js.Unsafe.inject (safeStr prefix); 
    Js.Unsafe.inject (safeStr s)|]

let toJSStringArray l = 
 Js.array (Array.of_list (List.map (Js.string) l))

let answer ans ass : unit =
  Js.Unsafe.fun_call (Js.Unsafe.js_expr "answer") 
  [|Js.Unsafe.inject  (toJSStringArray ans);
    Js.Unsafe.inject  (toJSStringArray ass)|]

let more () : bool =
  Js.Unsafe.fun_call (Js.Unsafe.js_expr "askMore") [||]
