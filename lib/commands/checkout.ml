let checkout (id : string) : unit =
  if Internals.Merge.is_in_progress () then
    print_endline
      "Merge is in progress! Finish resolving conflicts and commit your changes"
  else
    let head_index =
      match Internals.Head.get_current_commit () with
      | None -> Internals.Commit.empty_index
      | Some hash -> Internals.Commit.get_index hash
    in
    if List.length @@ Internals.Diff.diff_workdir_index head_index > 0 then
      print_endline "You have uncommitted/unstaged changes. Can't checkout"
    else
      match Internals.Commit.find id with
      | None -> print_endline @@ "'" ^ id ^ "' does not exist"
      | Some hash ->
          let new_index = Internals.Commit.get_index hash in

          (* updating HEAD *)
          if Internals.Branch.exists id then Internals.Head.set_to_branch id
          else Internals.Head.set_to_detached_head hash;

          Internals.Index.write new_index;
          Internals.Index.sync_working_dir ()
