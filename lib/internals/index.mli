type t = Yojson.Basic.t

val read : unit -> t
val write : t -> unit
val add : string -> Hash.t -> unit
val remove : string -> unit
val to_list : t -> (string * Hash.t) list
val of_list : (string * Hash.t) list -> t
