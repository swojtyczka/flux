let get_path (hash : Hash.t) : string =
  Filename.concat ".flux/objects" @@ Hash.to_string hash

let exists (hash : Hash.t) : bool = Sys.file_exists @@ get_path hash
