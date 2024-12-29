type t = Commit of Hash.t | Ref of string

let get () : t =
  let head = Yojson.Basic.from_file ".flux/HEAD" in
  let head_type =
    Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "type" head)
  in
  let head_val =
    Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "val" head)
  in
  if head_type = "commit" then Commit (Hash.of_string head_val)
  else Ref head_val

let get_current_commit () : Hash.t option =
  match get () with
  | Commit hash -> Some hash
  | Ref ref ->
      let path = Filename.concat ".flux" ref in
      if Sys.file_exists path then
        Some
          (In_channel.with_open_bin path In_channel.input_all |> Hash.of_string)
      else None

let get_current_branch () : string option =
  match get () with Commit _ -> None | Ref ref -> Some (FilePath.basename ref)

let set_to_detached_head (hash : Hash.t) : unit =
  Yojson.to_file ".flux/HEAD"
    (`Assoc
       [ ("type", `String "commit"); ("val", `String (Hash.to_string hash)) ])

let set_to_ref (ref : string) : unit =
  Yojson.to_file ".flux/HEAD"
    (`Assoc [ ("type", `String "ref"); ("val", `String ref) ])
