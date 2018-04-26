(** Logging facilities
  * The debugging val acts as a flag 
  * to show or not dev-level messages *)

let debugging = true

type level =
  | Debug (* For devellopment purpose only *)
  | Info | Warning | Error

let string_of_level = function
| Debug -> "info" | Info -> "info" 
| Warning -> "warning" | Error -> "error"

let log ?lvl:(lvl=Info) ?prefix:(prefix="") text =
if(not (lvl = Debug) || debugging) then begin
  let open Js in
  let message = object%js (self) (* Equivalent of this *)
    val type_ = string "log" 
    val lvl = string (string_of_level lvl)
    val prefix = string prefix 
    val text = string text 
  end in
  Worker.post_message(message)
end

let debug ?prefix:(prefix="") text = 
  log ~lvl:Debug ~prefix:prefix text

let info ?prefix:(prefix="") text = 
  log ~lvl:Info ~prefix:prefix text

let warning ?prefix:(prefix="") text = 
log ~lvl:Warning ~prefix:prefix text

let error ?prefix:(prefix="") text = 
log ~lvl:Error ~prefix:prefix text

type state =
| Started
| Running
| Finished

let string_of_state = function
  | Started -> "started"| Running -> "running" | Finished -> "finished"

let status ?details:(details="") id state =
 let open Js in
 let message = object%js (self)
    val type_ = string "status" 
    val id = string id
    val state = string (string_of_state state)
    val details = string details 
  end in
  Worker.post_message(message)