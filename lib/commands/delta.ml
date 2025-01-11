let delta (hash : Internals.Hash.t) : unit =
  if not (Internals.Object.exists hash) then
    print_endline @@ "Object does not exist: " ^ Internals.Hash.to_string hash
  else
    let parent_files =
      match Internals.Commit.get_parents hash with
      | [] -> Internals.Commit.empty_index
      | parent :: _ -> Internals.Commit.get_index parent
    in
    let files = Internals.Commit.get_index hash in
    let diff = Internals.Diff.diff_indexes parent_files files in
    Internals.Diff.print_changes diff

let delta_head () : unit =
  match Internals.Head.get_current_commit () with
  | None -> print_endline "No commits yet"
  | Some hash -> delta hash
