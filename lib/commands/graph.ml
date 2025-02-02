let graph (ids : string list) : unit =
  let hashes =
    List.filter_map
      (fun id ->
        match Internals.Commit.find id with
        | None ->
            print_endline @@ "'" ^ id ^ "' does not exist";
            None
        | Some hash -> Some hash)
      ids
  in
  let all_commits = Internals.Graph.find_all_ancestors hashes in
  let branches_to_be_shown =
    Internals.Branch.list_all ()
    |> List.filter (fun branch ->
           let hash = Internals.Branch.get_current_commit branch in
           List.mem hash all_commits)
  in
  let head =
    match Internals.Head.get () with
    | Commit hash ->
        if List.mem hash hashes then
          "\"HEAD\" [style=filled,color=\"#ff0000\"]\n\"HEAD\"->\""
          ^ Internals.Hash.to_string hash
          ^ "\"\n"
        else ""
    | Branch branch ->
        if List.mem branch branches_to_be_shown then
          "\"HEAD\" [style=filled,color=\"#ff0000\"]\n\"HEAD\"->\"" ^ branch
          ^ "\"\n"
        else ""
  in
  let output =
    let nodes =
      all_commits
      |> List.map Internals.Hash.to_string
      |> List.map (fun hash ->
             let message =
               String.escaped
               @@ Internals.Commit.get_message (Internals.Hash.of_string hash)
             in
             let label =
               if String.length message > 20 then
                 String.sub message 0 20 ^ "..."
               else message
             in
             "\"" ^ hash ^ "\"[shape=box,label=\"" ^ String.sub hash 0 6 ^ " - "
             ^ label ^ "\"];")
      |> String.concat "\n"
    in
    let branches =
      branches_to_be_shown
      |> List.map (fun branch ->
             "\"" ^ branch ^ "\" [shape=cds,style=filled,color=\"#00ff00\"]"
             ^ "\"" ^ branch ^ "\"->\""
             ^ Internals.Hash.to_string
                 (Internals.Branch.get_current_commit branch)
             ^ "\";")
      |> String.concat "\n"
    in
    let edges =
      Internals.Graph.get_edges hashes
      |> List.map (fun (commit, parent) ->
             "\"" ^ commit ^ "\"->\"" ^ parent ^ "\";")
      |> String.concat "\n"
    in
    "digraph repo {\nrankdir=\"BT\";\n" ^ head ^ nodes ^ branches ^ edges ^ "}"
  in
  Out_channel.with_open_text ".flux/graph.dot" (fun oc ->
      Out_channel.output_string oc output);
  if
    Sys.command
      "dot -Tsvg .flux/graph.dot -o .flux/graph.svg && imv .flux/graph.svg"
    <> 0
  then print_endline "Failed generating the graph"
