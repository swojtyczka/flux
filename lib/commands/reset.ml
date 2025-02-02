let reset (id : string) (param : string) =
  if Internals.Merge.is_in_progress () then
    print_endline
      "Merge is in progress! Finish resolving conflicts and commit your changes"
  else
    match Internals.Commit.find id with
    | None -> print_endline @@ "'" ^ id ^ "' does not exist"
    | Some hash -> (
        match Internals.Head.get () with
        | Commit _ -> print_endline "No branch to reset"
        | Branch branch -> (
            match param with
            | "soft" -> Internals.Reset.soft branch hash
            | "mixed" -> Internals.Reset.mixed branch hash
            | "hard" -> Internals.Reset.hard branch hash
            | _ -> print_endline @@ "Unknown reset mode: '" ^ param ^ "'"))
