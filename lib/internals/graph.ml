let find_all_ancestors (hashes : Hash.t list) : Hash.t list =
  List.map Merge.ancestors hashes
  |> List.flatten
  |> List.sort_uniq Stdlib.compare

let get_edges (hashes : Hash.t list) : (string * string) list =
  let commits_and_parents =
    find_all_ancestors hashes
    |> List.map (fun hash ->
           ( Hash.to_string hash,
             List.map Hash.to_string (Commit.get_parents hash) ))
  in

  let make_pairs ((key, values) : 'a * 'a list) : ('a * 'a) list =
    List.map (fun value -> (key, value)) values
  in

  commits_and_parents |> List.map make_pairs |> List.flatten
