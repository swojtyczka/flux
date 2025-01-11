let staged () : unit =
  let head_files =
    match Internals.Head.get_current_commit () with
    | None -> Internals.Commit.empty_index
    | Some hash -> Internals.Commit.get_index hash
  in
  let changes =
    Internals.Diff.diff_indexes head_files (Internals.Index.read ())
  in
  if List.is_empty changes then print_endline "Nothing to commit"
  else print_endline "Changes to be committed:";
  Internals.Diff.print_changes changes

let unstaged () : unit =
  let changes = Internals.Diff.diff_workdir_index () in
  if List.is_empty changes then print_endline "Working tree clean"
  else print_endline "Changes not staged for commit:";
  Internals.Diff.print_changes changes

let head () : unit =
  match Internals.Head.get_current_branch () with
  | Some branch -> print_endline @@ "On branch " ^ branch
  | None -> (
      match Internals.Head.get_current_commit () with
      | Some hash ->
          print_endline @@ "HEAD detached at " ^ Internals.Hash.to_string hash
      | None -> ())

let status () : unit =
  head ();
  staged ();
  unstaged ()
