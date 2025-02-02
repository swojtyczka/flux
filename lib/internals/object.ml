let get_path (hash : Hash.t) : string =
  Filename.concat ".flux/objects" @@ Hash.to_string hash

let write (hash : Hash.t) (content : string) =
  Out_channel.with_open_text (get_path hash) (fun oc ->
      Out_channel.output_string oc content)

let exists (hash : Hash.t) : bool = Sys.file_exists @@ get_path hash

let exists_commit (hash : Hash.t) : bool =
  exists hash
  && get_path hash |> Yojson.Basic.from_file
     |> Yojson.Basic.Util.member "type"
     |> Yojson.Basic.Util.to_string = "commit"

let generate_blob (content : string) : string * Hash.t =
  let blob =
    `Assoc [ ("type", `String "blob"); ("content", `String content) ]
    |> Yojson.to_string
  in
  let blobHash = Sha1.string blob |> Sha1.to_hex |> Hash.of_string in
  (blob, blobHash)

let generate_commit (timeStamp : string) (parents : Hash.t list)
    (index : Yojson.Basic.t) (message : string) (author : string) :
    string * Hash.t =
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
        ("author", `String author);
      ]
    |> Yojson.Basic.to_string
  in
  let commitHash = Sha1.string commit |> Sha1.to_hex |> Hash.of_string in
  (commit, commitHash)

let read_blob_content (hash : Hash.t) : string =
  Yojson.Basic.from_file (get_path hash)
  |> Yojson.Basic.Util.member "content"
  |> Yojson.Basic.Util.to_string
