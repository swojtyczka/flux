type conflict = string * (Diff.change * Diff.change)
type conflicts = conflict list

val find_base : Hash.t -> Hash.t -> Hash.t

val three_way_merge :
  Index.t -> Index.t -> Index.t -> string -> string -> Index.t * conflicts

val is_in_progress : unit -> bool
val write_merge_parents : Hash.t list -> unit
val get_merge_parents : unit -> Hash.t list
val end_merge : unit -> unit
