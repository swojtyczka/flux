let soft = Branch.update_branch

let mixed (branch : string) (hash : Hash.t) =
  soft branch hash;
  Commit.get_index hash |> Index.write

let hard (branch : string) (hash : Hash.t) =
  mixed branch hash;
  Commit.get_index hash |> Index.write_working_dir
