let stage (path : string) : unit =
  (* delete old entry *)
  Internals.Index.remove path;

  (* check if the file exists or it should stay deleted *)
  if Sys.file_exists path 
  then    
    (* blob generating *)
    let contents = In_channel.with_open_bin path In_channel.input_all in
    let blob, blobFileName = Internals.Blob.generate contents in
    Out_channel.with_open_text (FilePath.concat ".flux/objects" blobFileName) (fun oc -> Out_channel.output_string oc blob);

    (* adding to index *)
    Internals.Index.add path blobFileName;

    print_endline @@ "File added: " ^ path