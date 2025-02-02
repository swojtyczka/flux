let mark_conflict (text_curr : string) (text_incoming : string)
    (current : string) (incoming : string) : string =
  "<<<<<<< " ^ current ^ "\n" ^ text_curr ^ "\n=======\n" ^ text_incoming
  ^ "\n>>>>>>> " ^ incoming

(* find ancestors ordered by depth *)
let ancestors (hash : Hash.t) : Hash.t list =
  let visited = Hashtbl.create 100 in
  let queue = Queue.create () in
  Queue.push hash queue;

  let rec iter acc =
    match Queue.take_opt queue with
    | None -> acc
    | Some hash ->
        let parents =
          Commit.get_parents hash
          |> List.filter (Fun.negate (Hashtbl.mem visited))
          |> List.to_seq |> Queue.of_seq
        in
        Queue.iter (fun x -> Hashtbl.add visited x true) parents;
        Queue.transfer parents queue;
        iter (hash :: acc)
  in
  List.rev (iter [])

let find_base (ours : Hash.t) (theirs : Hash.t) : Hash.t =
  let ancestors_ours = ancestors ours in
  let ancestors_theirs = ancestors theirs in
  List.find (fun x -> List.mem x ancestors_theirs) ancestors_ours

type double_change = { ours : Diff.change option; theirs : Diff.change option }

let compose_changes (diff_current : Diff.t) (diff_incoming : Diff.t) :
    (string * double_change) list =
  let paths_changed = List.map fst diff_current @ List.map fst diff_incoming in

  List.map
    (fun path ->
      ( path,
        {
          ours = List.assoc_opt path diff_current;
          theirs = List.assoc_opt path diff_incoming;
        } ))
    paths_changed

type conflict = string * (Diff.change * Diff.change)
type conflicts = conflict list

let three_way_merge (current_index : Index.t) (incoming_index : Index.t)
    (base_index : Index.t) (current_name : string) (incoming_name : string) :
    Index.t * conflicts =
  let diff_current = Diff.diff_indexes base_index current_index in
  let diff_incoming = Diff.diff_indexes base_index incoming_index in

  let all_changes = compose_changes diff_current diff_incoming in

  let current_files = Index.to_list current_index in
  let incoming_files = Index.to_list incoming_index in

  let files = Index.to_list base_index |> List.to_seq |> Hashtbl.of_seq in
  let conflicted_files = Hashtbl.create 100 in

  List.iter
    (fun (path, { ours; theirs }) ->
      match (ours, theirs) with
      | None, None -> ()
      | (None | Some Deleted), Some Deleted | Some Deleted, None ->
          Hashtbl.remove files path
      | None, Some (Added | Modified) ->
          let hash = List.assoc path incoming_files in
          Hashtbl.replace files path hash
      | Some (Added | Modified), None ->
          let hash = List.assoc path current_files in
          Hashtbl.replace files path hash
      (* conflict *)
      | Some change_ours, Some change_theirs ->
          let file_ours =
            try Object.read_blob_content (List.assoc path current_files)
            with _ -> ""
          in
          let file_theirs =
            try Object.read_blob_content (List.assoc path incoming_files)
            with _ -> ""
          in
          if file_ours = file_theirs then
            let hash = List.assoc path current_files in
            Hashtbl.replace files path hash
          else
            let blob, blobHash =
              Object.generate_blob
                (mark_conflict file_ours file_theirs current_name incoming_name)
            in
            Object.write blobHash blob;
            Hashtbl.replace files path blobHash;
            Hashtbl.replace conflicted_files path (change_ours, change_theirs))
    all_changes;
  ( files |> Hashtbl.to_seq |> List.of_seq |> Index.of_list,
    conflicted_files |> Hashtbl.to_seq |> List.of_seq )

let is_in_progress () : bool = Sys.file_exists ".flux/MERGE_PARENTS"

let write_merge_parents (parents : Hash.t list) : unit =
  Yojson.Basic.to_file ".flux/MERGE_PARENTS"
    (`List (List.map (fun hash -> `String (Hash.to_string hash)) parents))

let get_merge_parents () : Hash.t list =
  Yojson.Basic.from_file ".flux/MERGE_PARENTS"
  |> Yojson.Basic.Util.to_list
  |> List.map (Fun.compose Hash.of_string Yojson.Basic.Util.to_string)

let end_merge () : unit = Sys.remove ".flux/MERGE_PARENTS"
