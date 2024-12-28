let commit (message : string) : unit =
  (* create commit file *)
  let commit, commitHash = 
    Internals.Commit.generate_commit
      (Internals.Head.get_current_commit_hash ())
      message
  in
  Out_channel.with_open_text (Filename.concat ".flux/objects" commitHash) (fun oc -> Out_channel.output_string oc commit);

  (* move HEAD/ref *)
  let head_type, head_val = Internals.Head.get () in
  match head_type with
  | "commit" -> Internals.Head.update_detached_head commitHash
  | "ref" -> Internals.Branch.update_ref head_val commitHash
  | _ -> print_endline "HEAD is corrupted! :("