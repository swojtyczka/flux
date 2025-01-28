let checkout (id : string) : unit =
  if Internals.Merge.is_in_progress () then
    print_endline
      "Merge is in progress! Finish resolving conflicts and commit your changes"
  else
    match Internals.Commit.find id with
    | None -> print_endline @@ "'" ^ id ^ "' does not exist"
    | Some hash ->
        let new_index = Internals.Commit.get_index hash in

        (* updating HEAD *)
        if Internals.Branch.exists id then
          Internals.Head.set_to_branch id
        else Internals.Head.set_to_detached_head hash;

        Internals.Index.write new_index;
        Internals.Index.sync_working_dir ()
