let unstage (path : string) : unit =
  (* delete entry for this file *)
  Internals.Index.remove path;

  (* copy file entry from HEAD if needed *)
  let head_index = Internals.Commit.get_commit_files @@ Internals.Head.get_current_commit_hash () in
  let files = Internals.Index.extract_paths_and_hashes head_index in
  match List.assoc_opt path files with
  | Some hash -> Internals.Index.add path hash
  | None -> ()