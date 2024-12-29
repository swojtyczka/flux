let delta (hash : string) : unit =
  let parent_files = Internals.Commit.get_commit_parent hash |> Internals.Commit.get_commit_files in
  let files = Internals.Commit.get_commit_files hash in
  let diff = Internals.Diff.diff_indexes parent_files files in
  List.iter (fun x -> print_endline @@ " " ^ fst x ^ " - "^ Internals.Diff.change_to_string (snd x)) diff