let rec log_from (hash : Internals.Hash.t) : unit =
  if not (Internals.Object.exists hash) then
    print_endline @@ "Object does not exist: " ^ Internals.Hash.to_string hash
  else
    let head =
      match Internals.Head.get_current_commit () with
      | Some hash -> hash
      | None -> Internals.Hash.of_string ""
    in
    let timestamp = Internals.Commit.get_timestamp hash in
    let message = Internals.Commit.get_message hash in
    print_endline @@ "commit "
    ^ Internals.Hash.to_string hash
    ^ " "
    ^ if head = hash then "(HEAD)" else "";
    print_endline @@ "Date: " ^ timestamp;
    print_newline ();
    print_endline @@ message;
    print_newline ();
    print_endline "-----";
    match Internals.Commit.get_parents hash with
    | [] -> ()
    | parent :: _ -> log_from parent

let log ?(from = "HEAD") () : unit =
  match Internals.Commit.find from with
  | None -> print_endline "Log is empty"
  | Some hash -> log_from hash
