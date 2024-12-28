let staged () : unit =
  let head = Internals.Head.get_current_commit_hash () in
  let head_files = 
    if head = "" 
      then Internals.Commit.get_empty_commit_files ()
      else Internals.Commit.get_commit_files head in
  let changes = Internals.Diff.diff_indexes head_files (Internals.Index.read ()) in
  if List.is_empty changes 
  then
    print_endline "Nothing to commit"
  else
    print_endline "Changes to be committed:";
    List.iter (fun x -> print_endline @@ " " ^ fst x ^ " - "^ Internals.Diff.change_to_string (snd x)) changes;