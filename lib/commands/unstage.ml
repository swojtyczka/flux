let unstage (path : string) : unit =
  (* delete entry for this file *)
  Internals.Index.remove path;

  (* copy file entry from HEAD if needed *)
  match Internals.Head.get_current_commit () with
  | None -> ()
  | Some hash -> (
      let head_index = Internals.Commit.get_index hash in
      let files = Internals.Index.to_list head_index in
      match List.assoc_opt path files with
      | Some hash -> Internals.Index.add path hash
      | None -> () (* if the file wasn't present, do nothing *))
