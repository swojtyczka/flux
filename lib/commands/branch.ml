let branch_list () : unit =
  let current =
    match Internals.Head.get_current_branch () with
    | None -> ""
    | Some name -> name
  in
  Internals.Branch.list_all ()
  |> List.iter (fun branch ->
         print_endline @@ branch ^ if branch = current then "*" else "")

let branch_create (name : string) =
  if Internals.Branch.exists name then print_endline "Branch already exists!"
  else
    match Internals.Head.get_current_commit () with
    | None -> Internals.Branch.create name Internals.Hash.empty
    | Some hash -> Internals.Branch.create name hash

let branch_delete (name : string) =
  if Internals.Branch.exists name then
    match Internals.Head.get_current_branch () with
    | Some curr ->
        if curr <> name then Internals.Branch.delete name
        else print_endline "Can't delete currently checked out branch"
    | None -> Internals.Branch.delete name
  else print_endline "Branch doesn't exist!"
