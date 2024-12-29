let get_timestamp (hash : Hash.t) : string =
  let commit = Yojson.Basic.from_file @@ Object.get_path hash in
  Yojson.Basic.Util.member "timeStamp" commit |> Yojson.Basic.Util.to_string

let get_message (hash : Hash.t) : string =
  let commit = Yojson.Basic.from_file @@ Object.get_path hash in
  Yojson.Basic.Util.member "message" commit |> Yojson.Basic.Util.to_string

let get_parent (hash : Hash.t) : Hash.t =
  if Hash.is_empty hash || not (Object.exists hash) then Hash.empty
  else
    let commit = Yojson.Basic.from_file @@ Object.get_path hash in
    Yojson.Basic.Util.member "parent" commit
    |> Yojson.Basic.Util.to_string |> Hash.of_string

let get_empty_index () : Index.t = `List []

let get_index (hash : Hash.t) : Index.t =
  if Hash.is_empty hash || not (Object.exists hash) then get_empty_index ()
  else
    let commit = Yojson.Basic.from_file @@ Object.get_path hash in
    Yojson.Basic.Util.member "files" commit
