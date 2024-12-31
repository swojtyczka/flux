let get_path (hash : Hash.t) : string =
  Filename.concat ".flux/objects" @@ Hash.to_string hash

let exists (hash : Hash.t) : bool = Sys.file_exists @@ get_path hash

let generate_blob (content : string) : string * Hash.t =
  let blob =
    `Assoc [ ("type", `String "blob"); ("content", `String content) ]
    |> Yojson.to_string
  in
  let blobHash = Sha1.string blob |> Sha1.to_hex |> Hash.of_string in
  (blob, blobHash)

let generate_commit (timeStamp : string) (parent : Hash.t) (index : Index.t)
    (message : string) : string * Hash.t =
  let commit =
    `Assoc
      [
        ("timeStamp", `String timeStamp);
        ("parent", `String (Hash.to_string parent));
        ("files", index);
        ("message", `String message);
      ]
    |> Yojson.Basic.to_string
  in
  let commitHash = Sha1.string commit |> Sha1.to_hex |> Hash.of_string in
  (commit, commitHash)
