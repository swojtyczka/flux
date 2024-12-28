let checkout (what : string) : unit = 
  let is_branch = List.mem what (Internals.Branch.list_all ()) in
  let hash =
    if is_branch
    then 
      Internals.Branch.get_current_commit what
    else 
      what
  in

  let old_files = Internals.Index.read () |> Internals.Index.extract_paths_and_hashes |> List.map fst in
  let new_index = Internals.Commit.get_commit_files hash in
  let new_files = new_index |> Internals.Index.extract_paths_and_hashes in

  (* updating HEAD *)
  if is_branch
    then
      Internals.Head.update_ref (FilePath.concat "refs/heads" what)
    else
      Internals.Head.update_detached_head hash;

  Internals.Index.write new_index;

  (* remove files from old index, copy files according to new index *)
  List.iter Sys.remove old_files;
  List.iter 
    (fun (path, hash) -> 
      let contents = Yojson.Basic.from_file (FilePath.concat ".flux/objects" hash) |> Yojson.Basic.Util.member "content" |> Yojson.Basic.Util.to_string in
      Out_channel.with_open_text path (fun oc -> Out_channel.output_string oc contents))
    new_files
