let revert (source : string) : unit =
  let target =
    match Internals.Head.get () with
    | Branch branch -> branch
    | Commit hash -> Internals.Hash.to_string hash
  in
  match Internals.Commit.find source with
  | None -> print_endline @@ "'" ^ source ^ "' does not exist"
  | Some hash -> (
      let source_parents = Internals.Commit.get_parents hash in
      let source_message = Internals.Commit.get_message hash in
      if List.length source_parents > 1 then
        print_endline "Can't revert merge commit"
      else
        match Internals.Head.get_current_commit () with
        | None -> print_endline "Can't revert on empty branch!"
        | Some _ ->
            let base_index = Internals.Commit.get_index hash in
            let current_index = Internals.Index.read () in
            let incoming_index =
              match source_parents with
              | [] -> Internals.Commit.empty_index
              | [ parent ] -> Internals.Commit.get_index parent
              | _ -> failwith "impossible"
            in
            let merged_index, conflicted_files =
              Internals.Merge.three_way_merge current_index incoming_index
                base_index target source
            in
            Internals.Index.write merged_index;
            Internals.Index.write_working_dir merged_index;

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
                     ^ ch_theirs_str ^ "): " ^ path ^ " " ^ ch_ours_str ^ " in "
                     ^ target ^ " and " ^ ch_theirs_str ^ " in " ^ source
                     ^ ". After resolving conflicts and staging changes, \
                        commit your progress.")
            else Commit.commit @@ "Revert \"" ^ source_message ^ "\"")
