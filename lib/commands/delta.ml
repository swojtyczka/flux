let delta (hash : Internals.Hash.t) : unit =
  let parent_files =
    Internals.Commit.get_parent hash |> Internals.Commit.get_index
  in
  let files = Internals.Commit.get_index hash in
  let diff = Internals.Diff.diff_indexes parent_files files in
  Internals.Diff.print_changes diff

let delta_head () : unit =
  match Internals.Head.get_current_commit () with
  | None -> print_endline "No commits yet"
  | Some hash -> delta hash
