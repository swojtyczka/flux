let checkout (id : string) : unit =
  match Internals.Commit.find id with
  | None -> print_endline @@ "'" ^ id ^ "' does not exist"
  | Some hash ->
      let new_index = Internals.Commit.get_index hash in
      let new_files = Internals.Index.to_list new_index in

      (* updating HEAD *)
      if Internals.Branch.exists id then
        Internals.Head.set_to_ref (FilePath.concat "refs/heads" id)
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
