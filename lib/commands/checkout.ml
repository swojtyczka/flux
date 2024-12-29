let checkout (what : string) : unit = 
  let is_branch = List.mem what (Internals.Branch.list_all ()) in
  let hash =
    if is_branch
    then 
      Internals.Branch.get_current_commit what
    else 
      what
  in

  let new_index = Internals.Commit.get_commit_files hash in
  let new_files = new_index |> Internals.Index.extract_paths_and_hashes in

  (* updating HEAD *)
  if is_branch
    then
      Internals.Head.update_ref (FilePath.concat "refs/heads" what)
    else
      Internals.Head.update_detached_head hash;

  Internals.Index.write new_index;

  (* clear working directory, create files according to new index *)
  FileUtil.rm ~recurse:true (Sys.readdir "." |> Array.to_list |> List.filter ((<>) ".flux"));
  List.iter 
    (fun (path, hash) -> 
      FileUtil.mkdir ~parent:true (FilePath.dirname path);
      let contents = Yojson.Basic.from_file (FilePath.concat ".flux/objects" hash) |> Yojson.Basic.Util.member "content" |> Yojson.Basic.Util.to_string in
      Out_channel.with_open_text path (fun oc -> Out_channel.output_string oc contents))
    new_files
