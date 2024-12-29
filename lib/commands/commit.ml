let commit (message : string) : unit =
  (* create commit file *)
  let commit, commitHash =
    let parent =
      match Internals.Head.get_current_commit () with
      | None -> Internals.Hash.of_string ""
      | Some hash -> hash
    in
    Internals.Hash.generate_commit parent message
  in
  Out_channel.with_open_text
    (Filename.concat ".flux/objects" (Internals.Hash.to_string commitHash))
    (fun oc -> Out_channel.output_string oc commit);

  (* move HEAD/ref *)
  match Internals.Head.get () with
  | Commit hash -> Internals.Head.set_to_detached_head hash
  | Ref ref -> Internals.Head.set_to_ref ref
