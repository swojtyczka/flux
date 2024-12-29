let update_ref (ref : string) (commitHash : string) : unit =
  Out_channel.with_open_text (Filename.concat ".flux" ref) (fun oc ->
      Out_channel.output_string oc commitHash)

let list_all () : string list = Sys.readdir ".flux/refs/heads" |> Array.to_list

let get_current_commit (branch : string) : string =
  In_channel.with_open_bin
    (FilePath.concat ".flux/refs/heads" branch)
    In_channel.input_all

let exists (name : string) : bool =
  Sys.file_exists (FilePath.concat ".flux/refs/heads" name)

let create (name : string) (hash : string) : unit =
  FileUtil.touch (FilePath.concat ".flux/refs/heads" name);
  Out_channel.with_open_text (Filename.concat ".flux/refs/heads" name)
    (fun oc -> Out_channel.output_string oc hash)

let delete (name : string) : unit =
  FileUtil.rm [ FilePath.concat ".flux/refs/heads" name ]
