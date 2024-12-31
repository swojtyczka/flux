type t = string

let of_string : string -> t = Fun.id
let to_string : t -> string = Fun.id
let empty : t = ""
let is_empty (hash : t) : bool = hash = empty
