let checkout (id : string) : unit =
  match Internals.Commit.find id with
  | None -> print_endline @@ "'" ^ id ^ "' does not exist"
  | Some hash ->
      let new_index = Internals.Commit.get_index hash in

      (* updating HEAD *)
      if Internals.Branch.exists id then
        Internals.Head.set_to_ref (FilePath.concat "refs/heads" id)
      else Internals.Head.set_to_detached_head hash;

      Internals.Index.write new_index;
      Internals.Index.sync_working_dir ()
