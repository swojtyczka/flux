let config_file () : string = FilePath.concat (Unix.getenv "HOME") ".fluxconfig"

let name () : string option =
  try
    Some
      (Yojson.Basic.from_file @@ config_file ()
      |> Yojson.Basic.Util.member "user"
      |> Yojson.Basic.Util.member "name"
      |> Yojson.Basic.Util.to_string)
  with _ -> None

let email () : string option =
  try
    Some
      (Yojson.Basic.from_file @@ config_file ()
      |> Yojson.Basic.Util.member "user"
      |> Yojson.Basic.Util.member "email"
      |> Yojson.Basic.Util.to_string)
  with _ -> None

let isset () : bool =
  match (name (), email ()) with Some _, Some _ -> true | _ -> false
