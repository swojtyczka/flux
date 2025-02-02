type change = Added | Deleted | Modified
type t = (string * change) list

let change_to_string (file : string) (c : change) : string =
  let d = Utils.Text.decorate in
  match c with
  | Added -> d "+ " [ "bold"; "green" ] ^ d file [ "green" ]
  | Deleted -> d "- " [ "bold"; "red" ] ^ d file [ "red" ]
  | Modified -> d "M " [ "bold"; "yellow" ] ^ d file [ "yellow" ]

let diff_indexes (older : Index.t) (newer : Index.t) : t =
  let files_old = Index.to_list older in
  let files_new = Index.to_list newer in
  let names_new = List.map fst files_new in
  let hashes_new = List.map snd files_new in
  let common = List.filter (fun x -> List.mem x files_old) files_new in
  let modified =
    List.filter
      (fun x -> List.mem (fst x) names_new && not (List.mem (snd x) hashes_new))
      files_old
    |> List.map fst
  in
  let added =
    List.filter
      (fun x -> not (List.mem x common || List.mem (fst x) modified))
      files_new
    |> List.map fst
  in
  let deleted =
    List.filter
      (fun x -> not (List.mem x common || List.mem (fst x) modified))
      files_old
    |> List.map fst
  in
  List.concat
    [
      List.map (fun x -> (x, Modified)) modified;
      List.map (fun x -> (x, Added)) added;
      List.map (fun x -> (x, Deleted)) deleted;
    ]

let workdir_files () : string list =
  let rec list_files (path : string) (path_nodot : string) : string list =
    let allfiles =
      Sys.readdir path |> Array.to_list |> List.filter (( <> ) ".flux")
    in
    List.concat_map
      (fun file_or_dir ->
        let path_file = Filename.concat path file_or_dir in
        let path_nodot_file = Filename.concat path_nodot file_or_dir in
        if Sys.is_directory path_file then list_files path_file path_nodot_file
        else [ path_nodot_file ])
      allfiles
  in
  list_files "." ""

let diff_workdir_index (index : Index.t) : t =
  let workdir = workdir_files () in
  let index_files = Index.to_list index in
  List.filter_map
    (fun path ->
      let content = In_channel.with_open_bin path In_channel.input_all in
      let _, hash = Object.generate_blob content in
      match List.assoc_opt path index_files with
      | None -> Some (path, Added) (* file is present only in newer index *)
      | Some hash2 -> if hash = hash2 then None else Some (path, Modified))
    workdir
  @ List.filter_map
      (fun (path, _) ->
        if List.mem path workdir then None else Some (path, Deleted))
      index_files

let print_changes (changes : t) : unit =
  List.iter (fun x -> change_to_string (fst x) (snd x) |> print_endline) changes
