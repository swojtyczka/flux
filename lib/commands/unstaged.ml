let unstaged () : unit =
  let changes = Internals.Diff.diff_workdir_staged () in
  if List.is_empty changes 
  then
    print_endline "Working tree clean"
  else
    print_endline "Changes not staged for commit:";
    List.iter (fun x -> print_endline @@ " " ^ fst x ^ " - "^ Internals.Diff.change_to_string (snd x)) changes;