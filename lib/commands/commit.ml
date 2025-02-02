let commit (message : string) : unit =
  (* check if author is set*)
  match (Config.User.name (), Config.User.email ()) with
  | Some user_name, Some user_email -> (
      (* create commit file *)
      let commit, commitHash =
        let timeStamp = Utils.Timestamp.get () in
        let parents =
          if Internals.Merge.is_in_progress () then (
            let p = Internals.Merge.get_merge_parents () in
            Internals.Merge.end_merge ();
            p)
          else
            match Internals.Head.get_current_commit () with
            | None -> []
            | Some hash -> [ hash ]
        in
        let index = Internals.Index.read () in
        let author = user_name ^ " <" ^ user_email ^ ">" in
        Internals.Object.generate_commit timeStamp parents index message author
      in
      Out_channel.with_open_text
        (Filename.concat ".flux/objects" (Internals.Hash.to_string commitHash))
        (fun oc -> Out_channel.output_string oc commit);

      (* move HEAD/branch *)
      match Internals.Head.get () with
      | Commit hash -> Internals.Head.set_to_detached_head hash
      | Branch branch -> Internals.Branch.update_branch branch commitHash)
  | _ -> print_endline "Please set your name and email in ~/.fluxconfig"
