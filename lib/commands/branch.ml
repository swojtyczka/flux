let branch : string option -> unit =
  function
  | None -> 
    let current = match Internals.Head.get_current_branch () with None -> "" | Some name -> name in
    Internals.Branch.list_all () |> List.iter (fun branch -> print_endline @@ branch ^ (if branch = current then "*" else ""))
  | Some name -> 
    if Internals.Branch.exists name 
      then print_endline "Branch already exists!" 
      else Internals.Branch.create name (Internals.Head.get_current_commit_hash ())