let find_all_ancestors (hashes : Internals.Hash.t list) : Internals.Hash.t list
    =
  List.map Internals.Merge.ancestors hashes
  |> List.flatten
  |> List.sort_uniq Stdlib.compare

let get_edges (hashes : Internals.Hash.t list) : (string * string) list =
  let commits_and_parents =
    find_all_ancestors hashes
    |> List.map (fun hash ->
           ( Internals.Hash.to_string hash,
             List.map Internals.Hash.to_string
               (Internals.Commit.get_parents hash) ))
  in

  let make_pairs ((key, values) : 'a * 'a list) : ('a * 'a) list =
    List.map (fun value -> (key, value)) values
  in

  commits_and_parents |> List.map make_pairs |> List.flatten
