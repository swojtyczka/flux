let get_timestamp (hash : Hash.t) : string =
  let commit = Yojson.Basic.from_file @@ Object.get_path hash in
  Yojson.Basic.Util.member "timeStamp" commit |> Yojson.Basic.Util.to_string

let get_message (hash : Hash.t) : string =
  let commit = Yojson.Basic.from_file @@ Object.get_path hash in
  Yojson.Basic.Util.member "message" commit |> Yojson.Basic.Util.to_string

let get_parents (hash : Hash.t) : Hash.t list =
  if Hash.is_empty hash || not (Object.exists hash) then []
  else
    let commit = Yojson.Basic.from_file @@ Object.get_path hash in
    Yojson.Basic.Util.member "parents" commit
    |> Yojson.Basic.Util.to_list
    |> List.map (Fun.compose Hash.of_string Yojson.Basic.Util.to_string)

let get_empty_index () : Index.t = `List []

let get_index (hash : Hash.t) : Index.t =
  if Hash.is_empty hash || not (Object.exists hash) then get_empty_index ()
  else
    let commit = Yojson.Basic.from_file @@ Object.get_path hash in
    Yojson.Basic.Util.member "files" commit

let rec nth_ancestor (hash : Hash.t) (n : int) : Hash.t option =
  if n = 0 then Some hash
  else
    match get_parents hash with
    | [] -> None
    | hash :: _ -> nth_ancestor hash (n - 1)

let find (query : string) : Hash.t option =
  let params = String.split_on_char '~' query in
  let params_num = List.length params in

  if params_num <= 2 then
    let base = List.hd params in

    let base_commit =
      if base = "HEAD" then Head.get_current_commit ()
      else if Branch.exists base then Branch.get_current_commit_opt base
      else if Object.exists_commit (Hash.of_string base) then
        Some (Hash.of_string base)
      else None
    in

    match base_commit with
    | None -> None
    | Some hash ->
        if params_num = 1 then Some hash
        else nth_ancestor hash (int_of_string (List.hd @@ List.tl params))
  else None
