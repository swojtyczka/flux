let help () : unit =
  print_endline @@ "flux help - shows this list\n" ^
  "flux init - initializes an empty repository\n" ^
  "flux explode - deletes existing repository\n" ^
  "flux stage <path> - adds changes for file to the staging area\n" ^
  "flux status - shows current status\n" ^
  "flux commit <message> - creates a commit\n" ^
  "flux log (<hash>) - shows commit log (optional: starting from <hash>)\n" ^
  "flux staged - shows differences between staging area and HEAD\n" ^
  "flux unstaged - shows unstaged changes\n" ^
  "flux checkout <hash/ref> - check out commit or branch\n" ^
  "flux branch (<name>) - list all branches / create a new branch\n"