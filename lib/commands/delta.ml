let delta (id : string) : unit =
  match Internals.Commit.find id with
  | None -> print_endline @@ "'" ^ id ^ "' does not exist"
  | Some hash ->
      let parent_files =
        match Internals.Commit.get_parents hash with
        | [] -> Internals.Commit.empty_index
        | parent :: _ -> Internals.Commit.get_index parent
      in
      let files = Internals.Commit.get_index hash in
      let diff = Internals.Diff.diff_indexes parent_files files in
      Internals.Diff.print_changes diff
