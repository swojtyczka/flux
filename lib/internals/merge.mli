type conflict = string * (Diff.change * Diff.change)
type conflicts = conflict list

val find_base : Hash.t -> Hash.t -> Hash.t

val three_way_merge :
  Index.t -> Index.t -> Index.t -> string -> string -> Index.t * conflicts
