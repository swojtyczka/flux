let get () : string * string =
  let head = Yojson.Basic.from_file ".flux/HEAD" in
  let head_type = Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "type" head) in
  let head_val = Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "val" head) in
  head_type, head_val

let get_current_commit_hash () : string =
  let head_type, head_val = get () in
  match head_type with
  | "commit" -> head_val
  | "ref" -> let path = Filename.concat ".flux" head_val in
    In_channel.with_open_bin path In_channel.input_all
  | _ -> ""

let get_current_branch () : string option =
  let head_type, head_val = get () in
  match head_type with
  | "commit" -> None
  | "ref" -> Some (FilePath.basename head_val)
  | _ -> None

let update_detached_head (commitHash : string) : unit =
  Yojson.to_file ".flux/HEAD" (`Assoc ["type", `String "commit"; "val", `String commitHash])

let update_ref (ref : string) : unit = 
  Yojson.to_file ".flux/HEAD" (`Assoc ["type", `String "ref"; "val", `String ref])
