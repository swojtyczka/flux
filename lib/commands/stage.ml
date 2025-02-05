let stage (path : string) : unit =
  (* delete old entry *)
  Internals.Index.remove path;

  (* check if the file exists or it should stay deleted *)
  if Sys.file_exists path then (
    (* blob generating *)
    let content = In_channel.with_open_bin path In_channel.input_all in
    let blob, blobHash = Internals.Object.generate_blob content in
    Internals.Object.write blobHash blob;

    (* adding to index *)
    Internals.Index.add path blobHash;

    print_endline @@ "File added: " ^ path)
