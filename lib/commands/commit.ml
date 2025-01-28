let commit (message : string) : unit =
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
    Internals.Object.generate_commit timeStamp parents index message
  in
  Out_channel.with_open_text
    (Filename.concat ".flux/objects" (Internals.Hash.to_string commitHash))
    (fun oc -> Out_channel.output_string oc commit);

  (* move HEAD/ref *)
  match Internals.Head.get () with
  | Commit hash -> Internals.Head.set_to_detached_head hash
  | Ref ref -> Internals.Branch.update_ref ref commitHash
