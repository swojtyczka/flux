let update_ref (ref : string) (hash : Hash.t) : unit =
  Out_channel.with_open_text (Filename.concat ".flux" ref) (fun oc ->
      Out_channel.output_string oc @@ Hash.to_string hash)

let list_all () : string list = Sys.readdir ".flux/refs/heads" |> Array.to_list

let get_current_commit (ref : string) : Hash.t =
  In_channel.with_open_bin
    (FilePath.concat ".flux/refs/heads" ref)
    In_channel.input_all
  |> Hash.of_string

let exists (name : string) : bool =
  Sys.file_exists (FilePath.concat ".flux/refs/heads" name)

let create (name : string) (hash : Hash.t) : unit =
  FileUtil.touch (FilePath.concat ".flux/refs/heads" name);
  Out_channel.with_open_text (Filename.concat ".flux/refs/heads" name)
    (fun oc -> Out_channel.output_string oc @@ Hash.to_string hash)

let delete (name : string) : unit =
  FileUtil.rm [ FilePath.concat ".flux/refs/heads" name ]
