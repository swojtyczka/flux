let merge (source : string) : unit =
  match Internals.Head.get () with
  | Commit _ -> print_endline "Cannot merge into non-branch"
  | Branch target -> (
      match Internals.Commit.find source with
      | None -> print_endline @@ "'" ^ source ^ "' does not exist"
      | Some hash -> (
          match Internals.Head.get_current_commit () with
          | None -> print_endline "Can't merge into empty branch!"
          | Some head_hash ->
              let base_index =
                Internals.Commit.get_index
                  (Internals.Merge.find_base head_hash hash)
              in
              let current_index = Internals.Index.read () in
              let incoming_index = Internals.Commit.get_index hash in
              let merged_index, conflicted_files =
                Internals.Merge.three_way_merge current_index incoming_index
                  base_index target source
              in
              Internals.Index.write merged_index;
              Internals.Index.sync_working_dir ();

              (* create MERGE_PARENTS file that contains hashes of parents - if this file exists, a merge is in progress *)
              Internals.Merge.write_merge_parents [ head_hash; hash ];

              if not @@ List.is_empty conflicted_files then
                let change_to_string (change : Internals.Diff.change) : string =
                  match change with
                  | Added -> "added"
                  | Modified -> "modified"
                  | Deleted -> "deleted"
                in

                conflicted_files
                |> List.iter (fun (path, (change_ours, change_theirs)) ->
                       let ch_ours_str = change_to_string change_ours in
                       let ch_theirs_str = change_to_string change_theirs in
                       print_endline @@ "CONFLICT (" ^ ch_ours_str ^ "/"
                       ^ ch_theirs_str ^ "): " ^ path ^ " " ^ ch_ours_str
                       ^ " in " ^ target ^ " and " ^ ch_theirs_str ^ " in "
                       ^ source
                       ^ ". After resolving conflicts and staging changes, \
                          commit your progress.")
              else Commit.commit @@ "Merge branch " ^ source ^ " into " ^ target
          ))
