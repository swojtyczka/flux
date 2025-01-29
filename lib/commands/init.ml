let init () : unit =
  if Sys.file_exists ".flux" then print_endline "Repository already exists"
  else
    try
      FileUtil.mkdir ".flux";
      FileUtil.mkdir ".flux/objects";
      FileUtil.mkdir ".flux/refs";
      FileUtil.mkdir ".flux/refs/heads";
      FileUtil.touch ".flux/HEAD";
      FileUtil.touch ".flux/index";
      FileUtil.touch ".flux/refs/heads/master";

      Yojson.to_file ".flux/index" (`List []);
      Yojson.to_file ".flux/HEAD"
        (`Assoc [ ("type", `String "branch"); ("val", `String "master") ]);

      print_endline "Initialized empty repository"
    with _ ->
      print_endline "Couldn't initalize repository. Does .flux already exist?"
