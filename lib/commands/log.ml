let log (id : string) : unit =
  match Internals.Commit.find id with
  | None -> print_endline @@ "'" ^ id ^ "' does not exist"
  | Some hash ->
      let rec log_from (hash : Internals.Hash.t) : unit =
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
      in
      log_from hash

let ll (id : string) : unit =
  match Internals.Commit.find id with
  | None -> print_endline @@ "'" ^ id ^ "' does not exist"
  | Some hash ->
      let rec log_from (hash : Internals.Hash.t) : unit =
        let head =
          match Internals.Head.get_current_commit () with
          | Some hash -> hash
          | None -> Internals.Hash.of_string ""
        in
        let message = Internals.Commit.get_message hash in
        print_endline
        @@ Internals.Hash.to_string hash
        ^ " " ^ message
        ^ if head = hash then "(HEAD)" else "";
        match Internals.Commit.get_parents hash with
        | [] -> ()
        | parent :: _ -> log_from parent
      in
      log_from hash
