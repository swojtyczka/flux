let read () : Yojson.Basic.t =
  Yojson.Basic.from_file ".flux/index"

let write (json : Yojson.Basic.t) : unit =
  Yojson.Basic.to_file ".flux/index" json

let extract_paths_and_hashes (json : Yojson.Basic.t) : (string * string) list =
  Yojson.Basic.Util.to_list json 
  |> List.map (fun entry -> 
   Yojson.Basic.Util.member "path" entry |> Yojson.Basic.Util.to_string, 
   Yojson.Basic.Util.member "hash" entry |> Yojson.Basic.Util.to_string)

let staged_files () : string list =
  match read () with
    | `List ls -> List.map (Fun.compose Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "path")) ls
    | _ -> []

let add (path : string) (hash : string ) : unit =
  let index = 
  begin 
  match read () with
  | `List ls -> ls
  | _ -> [] 
  end 
  in
  let entry = `Assoc ["path", `String path; "hash", `String hash] in
  write (`List (entry :: index))

let remove (path : string) : unit =
  let index = 
  begin 
  match read () with
  | `List ls -> ls
  | _ -> [] 
  end 
  in
  let filter = fun entry -> 
    Yojson.Basic.Util.member "path" entry |> Yojson.Basic.Util.to_string <> path
  in
  let new_index = List.filter filter index 
  in write (`List new_index)