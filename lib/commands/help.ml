let help () : unit =
  print_endline @@ "flux help - shows this list\n"
  ^ "flux init - initializes an empty repository\n"
  ^ "flux explode - deletes existing repository\n"
  ^ "flux stage <path> - adds changes for file to the staging area\n"
  ^ "flux unstage <path> - revert index to HEAD for a specific file (doesn't \
     affect working directory)\n" ^ "flux status - shows current status\n"
  ^ "flux commit <message> - creates a commit\n"
  ^ "flux log [<revision>] - shows commit log\n"
  ^ "flux ll [<revision>] - shows commit log (compact)\n"
  ^ "flux checkout <revision> - check out a revision\n"
  ^ "flux branch [<name>] - list all branches / create a new branch\n"
  ^ "flux del <name> - deletes a branch\n"
  ^ "flux delta [<revision>] - shows changes between commit and its parent\n"
  ^ "flux diff <revision_older> [<revision_newer>] - shows changes between two \
     commits\n" ^ "flux merge <revision> - merges into HEAD\n"
  ^ "flux graph [<revision>...] - shows commit graph\n"
  ^ "flux cherry-pick <revision> - cherry-pick a commit onto HEAD\n"
  ^ "flux reset [soft|mixed|hard] <revision> - reset current branch to \
     specific commit (mixed is default)\n"
  ^ "flux revert <revision> - reverts a commit\n"
