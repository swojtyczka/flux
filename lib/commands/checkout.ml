let checkout (id : string) : unit =
  let is_branch = List.mem id (Internals.Branch.list_all ()) in
  let hash =
    if is_branch then Internals.Branch.get_current_commit id
    else Internals.Hash.of_string id
  in

  let new_index = Internals.Commit.get_index hash in
  let new_files = Internals.Index.to_list new_index in

  (* updating HEAD *)
  if is_branch then Internals.Head.set_to_ref (FilePath.concat "refs/heads" id)
  else Internals.Head.set_to_detached_head hash;

  Internals.Index.write new_index;

  (* clear working directory, create files according to new index *)
  FileUtil.rm ~recurse:true
    (Sys.readdir "." |> Array.to_list |> List.filter (( <> ) ".flux"));
  List.iter
    (fun (path, hash) ->
      FileUtil.mkdir ~parent:true (FilePath.dirname path);
      let contents =
        Yojson.Basic.from_file @@ Internals.Object.get_path hash
        |> Yojson.Basic.Util.member "content"
        |> Yojson.Basic.Util.to_string
      in
      Out_channel.with_open_text path (fun oc ->
          Out_channel.output_string oc contents))
    new_files
