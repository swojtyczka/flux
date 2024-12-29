type t

val of_string : string -> t
val to_string : t -> string
val empty : t
val is_empty : t -> bool
val generate_blob : string -> string * t
val generate_commit : t -> string -> string * t
