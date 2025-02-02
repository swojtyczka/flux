let head_branch_info (hash : Internals.Hash.t) : string =
  let d = Utils.Text.decorate in
  let head =
    match Internals.Head.get_current_commit () with
    | Some hash -> hash
    | None -> Internals.Hash.empty
  in
  let branches =
    Internals.Branch.list_all ()
    |> List.filter (fun branch ->
           match Internals.Branch.get_current_commit_opt branch with
           | Some branch_hash when branch_hash = hash -> true
           | _ -> false)
  in
  let show_head = head = hash in
  let head_branch =
    match Internals.Head.get () with Branch branch -> branch | Commit _ -> ""
  in
  let ordered_branches =
    if show_head && head_branch <> "" then
      head_branch :: List.filter (( <> ) head_branch) branches
    else branches
  in
  let show_branches = List.length ordered_branches > 0 in
  (if show_head || show_branches then
     d "(" [ "yellow" ]
     ^
     if show_head then
       d "HEAD" [ "magenta"; "bold" ] ^ if head_branch <> "" then "->" else ", "
     else ""
   else "")
  ^ (List.map (fun branch -> d branch [ "cyan" ]) ordered_branches
    |> String.concat ", ")
  ^ if show_head || show_branches then d ")" [ "yellow" ] else ""

let log (id : string) : unit =
  let d = Utils.Text.decorate in
  match Internals.Commit.find id with
  | None -> print_endline @@ "'" ^ id ^ "' does not exist"
  | Some hash ->
      let rec log_from (hash : Internals.Hash.t) : unit =
        let timestamp = Internals.Commit.get_timestamp hash in
        let message = Internals.Commit.get_message hash in
        let author = Internals.Commit.get_author hash in
        print_endline
        @@ d ("commit " ^ Internals.Hash.to_string hash) [ "yellow" ]
        ^ " " ^ head_branch_info hash;
        print_endline @@ "Author: " ^ author;
        print_endline @@ "Date: " ^ timestamp;
        print_newline ();
        print_endline @@ message;
        print_newline ();
        print_endline "-----";
        match Internals.Commit.get_parents hash with
        | [] -> ()
        | parent :: _ -> log_from parent
      in
      log_from hash

let ll (id : string) : unit =
  let d = Utils.Text.decorate in
  match Internals.Commit.find id with
  | None -> print_endline @@ "'" ^ id ^ "' does not exist"
  | Some hash ->
      let rec log_from (hash : Internals.Hash.t) : unit =
        let message = Internals.Commit.get_message hash in
        print_endline
        @@ d (Internals.Hash.to_string hash) [ "yellow"; "bold" ]
        ^ " " ^ d message [ "underline" ] ^ " " ^ head_branch_info hash;
        match Internals.Commit.get_parents hash with
        | [] -> ()
        | parent :: _ -> log_from parent
      in
      log_from hash
