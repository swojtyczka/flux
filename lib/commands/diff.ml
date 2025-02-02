let diff (older_id : string) (newer_id : string) : unit =
  match Internals.Commit.find older_id with
  | None -> print_endline @@ "'" ^ older_id ^ "' does not exist"
  | Some older_hash -> (
      match Internals.Commit.find newer_id with
      | None -> print_endline @@ "'" ^ newer_id ^ "' does not exist"
      | Some newer_hash ->
          let older_index = Internals.Commit.get_index older_hash in
          let newer_index = Internals.Commit.get_index newer_hash in
          let diff = Internals.Diff.diff_indexes older_index newer_index in
          Internals.Diff.print_changes diff)
