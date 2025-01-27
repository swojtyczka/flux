type t = Yojson.Basic.t

let read () : t = Yojson.Basic.from_file ".flux/index"
let write (index : t) : unit = Yojson.Basic.to_file ".flux/index" index

let add (path : string) (hash : Hash.t) : unit =
  let index = match read () with `List ls -> ls | _ -> [] in
  let entry =
    `Assoc [ ("path", `String path); ("hash", `String (Hash.to_string hash)) ]
  in
  write (`List (entry :: index))

let remove (path : string) : unit =
  let index = match read () with `List ls -> ls | _ -> [] in
  let filter =
   fun entry ->
    Yojson.Basic.Util.member "path" entry |> Yojson.Basic.Util.to_string <> path
  in
  let new_index = List.filter filter index in
  write (`List new_index)

let to_list (index : t) : (string * Hash.t) list =
  Yojson.Basic.Util.to_list index
  |> List.map (fun entry ->
         ( Yojson.Basic.Util.member "path" entry |> Yojson.Basic.Util.to_string,
           Yojson.Basic.Util.member "hash" entry
           |> Yojson.Basic.Util.to_string |> Hash.of_string ))

let of_list (ls : (string * Hash.t) list) : t =
  `List
    (List.map
       (fun (path, hash) ->
         `Assoc
           [ ("path", `String path); ("hash", `String (Hash.to_string hash)) ])
       ls)

let sync_working_dir () : unit =
  (* clear working directory, create files according to new index *)
  FileUtil.rm ~recurse:true
    (Sys.readdir "." |> Array.to_list |> List.filter (( <> ) ".flux"));
  List.iter
    (fun (path, hash) ->
      FileUtil.mkdir ~parent:true (FilePath.dirname path);
      let contents =
        Yojson.Basic.from_file @@ Object.get_path hash
        |> Yojson.Basic.Util.member "content"
        |> Yojson.Basic.Util.to_string
      in
      Out_channel.with_open_text path (fun oc ->
          Out_channel.output_string oc contents))
    (read () |> to_list)
