let get_path (hash : Hash.t) : string =
  Filename.concat ".flux/objects" @@ Hash.to_string hash

let exists (hash : Hash.t) : bool = Sys.file_exists @@ get_path hash

let exists_commit (hash : Hash.t) : bool =
  exists hash
  && get_path hash |> Yojson.Basic.from_file
     |> Yojson.Basic.Util.member "type"
     |> Yojson.Basic.to_string = "commit"

let generate_blob (content : string) : string * Hash.t =
  let blob =
    `Assoc [ ("type", `String "blob"); ("content", `String content) ]
    |> Yojson.to_string
  in
  let blobHash = Sha1.string blob |> Sha1.to_hex |> Hash.of_string in
  (blob, blobHash)

let generate_commit (timeStamp : string) (parents : Hash.t list)
    (index : Index.t) (message : string) : string * Hash.t =
  let commit =
    `Assoc
      [
        ("type", `String "commit");
        ("timeStamp", `String timeStamp);
        ( "parents",
          `List (List.map (fun hash -> `String (Hash.to_string hash)) parents)
        );
        ("files", index);
        ("message", `String message);
      ]
    |> Yojson.Basic.to_string
  in
  let commitHash = Sha1.string commit |> Sha1.to_hex |> Hash.of_string in
  (commit, commitHash)
