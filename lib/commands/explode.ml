let explode () : unit =
  try 
  FileUtil.rm ~recurse:true [".flux"];
  print_endline "Deleted repository";
  with _ -> print_endline "Couldn't delete repository. Does .flux exist?"