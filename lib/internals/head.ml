type t = Commit of Hash.t | Branch of string

let get () : t =
  let head = Yojson.Basic.from_file ".flux/HEAD" in
  let head_type =
    Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "type" head)
  in
  let head_val =
    Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "val" head)
  in
  if head_type = "commit" then Commit (Hash.of_string head_val)
  else Branch head_val

let get_current_commit () : Hash.t option =
  match get () with
  | Commit hash -> Some hash
  | Branch branch -> Branch.get_current_commit_opt branch

let get_current_branch () : string option =
  match get () with
  | Commit _ -> None
  | Branch branch -> Some (FilePath.basename branch)

let set_to_detached_head (hash : Hash.t) : unit =
  Yojson.to_file ".flux/HEAD"
    (`Assoc
       [ ("type", `String "commit"); ("val", `String (Hash.to_string hash)) ])

let set_to_branch (branch : string) : unit =
  Yojson.to_file ".flux/HEAD"
    (`Assoc [ ("type", `String "branch"); ("val", `String branch) ])
