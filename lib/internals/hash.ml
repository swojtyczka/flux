type t = string

let of_string : string -> t = Fun.id
let to_string : t -> string = Fun.id
let empty : t = ""
let is_empty (hash : t) : bool = hash = empty

let generate_blob (content : string) : string * t =
  let blob =
    `Assoc [ ("type", `String "blob"); ("content", `String content) ]
    |> Yojson.to_string
  in
  let blobHash = Sha1.string blob |> Sha1.to_hex in
  (blob, blobHash)

let generate_commit (parent : t) (message : string) : string * t =
  let commit =
    `Assoc
      [
        ("timeStamp", `String (Utils.Timestamp.get ()));
        ("parent", `String parent);
        ("files", Yojson.Basic.from_file ".flux/index");
        ("message", `String message);
      ]
    |> Yojson.Basic.to_string
  in
  let commitHash = Sha1.to_hex @@ Sha1.string commit in
  (commit, commitHash)
