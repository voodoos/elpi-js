(** Logging facilities
  * The debugging val acts as a flag 
  * to show or not Debug-level messages *)

let debugging = true

type level =
  | Debug (* For devellopment purpose only *)
  | Info | Warning | Error

let string_of_level = function
| Debug -> "info" | Info -> "info" 
| Warning -> "warning" | Error -> "error"

let log ?lvl:(lvl=Info) ?prefix:(prefix="") text =
  if(not (lvl = Debug) || debugging) then
   ElpiWorkerBindings.log (string_of_level lvl) prefix text
   (*if prefix = "" then text else String.concat "" ["["; prefix; "] "; text]*)

let debug ?prefix:(prefix="") text = 
  log ~lvl:Debug ~prefix:prefix text

let info ?prefix:(prefix="") text = 
  log ~lvl:Info ~prefix:prefix text

let warning ?prefix:(prefix="") text = 
log ~lvl:Warning ~prefix:prefix text

let error ?prefix:(prefix="") text = 
log ~lvl:Error ~prefix:prefix text