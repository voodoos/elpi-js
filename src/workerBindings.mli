(** This module contains bindings to some of the 
  * javascript functions defined in elpi-worker.js *)
  
  val log : string -> string -> string -> unit

  val answer : string list -> string list -> unit