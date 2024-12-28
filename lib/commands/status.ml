let status () : unit =
  begin match Internals.Head.get_current_branch () with
  | Some branch -> print_endline @@ "On branch " ^ branch
  | _ -> print_endline @@ "HEAD detached at " ^ (Internals.Head.get_current_commit_hash ())
  end;
  Staged.staged ();
  Unstaged.unstaged ();