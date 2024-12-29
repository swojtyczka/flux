let staged () : unit =
  let head = Internals.Head.get_current_commit_hash () in
  let head_files =
    if head = "" then Internals.Commit.get_empty_commit_files ()
    else Internals.Commit.get_commit_files head
  in
  let changes =
    Internals.Diff.diff_indexes head_files (Internals.Index.read ())
  in
  if List.is_empty changes then print_endline "Nothing to commit"
  else print_endline "Changes to be committed:";
  List.iter
    (fun x ->
      print_endline @@ " " ^ fst x ^ " - "
      ^ Internals.Diff.change_to_string (snd x))
    changes

let unstaged () : unit =
  let changes = Internals.Diff.diff_workdir_staged () in
  if List.is_empty changes then print_endline "Working tree clean"
  else print_endline "Changes not staged for commit:";
  List.iter
    (fun x ->
      print_endline @@ " " ^ fst x ^ " - "
      ^ Internals.Diff.change_to_string (snd x))
    changes

let status () : unit =
  (match Internals.Head.get_current_branch () with
  | Some branch -> print_endline @@ "On branch " ^ branch
  | _ ->
      print_endline @@ "HEAD detached at "
      ^ Internals.Head.get_current_commit_hash ());
  staged ();
  unstaged ()
