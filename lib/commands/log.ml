let rec log_from (hash : string) : unit =
  if hash = "" then print_newline ()
  else
    let headHash = Internals.Head.get_current_commit_hash () in
    let curr = Internals.Commit.get_commit_timeStamp_and_message hash in
    print_endline @@ "commit " ^ hash ^ " "
    ^ if headHash = hash then "(HEAD)" else "";
    print_endline @@ "Date: " ^ fst curr;
    print_newline ();
    print_endline @@ snd curr;
    print_newline ();
    print_endline "-----";
    let parent = Internals.Commit.get_commit_parent hash in
    log_from parent

let log () : unit = log_from @@ Internals.Head.get_current_commit_hash ()
