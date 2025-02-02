let _ : unit =
  let argc = Array.length Sys.argv in
  if argc < 2 then Flux.Commands.Help.help ()
  else
    let command = Sys.argv.(1) in
    match command with
    | "help" -> Flux.Commands.Help.help ()
    | "init" -> Flux.Commands.Init.init ()
    | "explode" -> Flux.Commands.Explode.explode ()
    | "stage" ->
        if argc < 3 then print_endline "Too few arguments"
        else Flux.Commands.Stage.stage Sys.argv.(2)
    | "unstage" ->
        if argc < 3 then print_endline "Too few arguments"
        else Flux.Commands.Unstage.unstage Sys.argv.(2)
    | "status" -> Flux.Commands.Status.status ()
    | "commit" ->
        if argc < 3 then print_endline "Too few arguments"
        else Flux.Commands.Commit.commit Sys.argv.(2)
    | "log" ->
        if argc < 3 then Flux.Commands.Log.log "HEAD"
        else Flux.Commands.Log.log Sys.argv.(2)
    | "ll" ->
        if argc < 3 then Flux.Commands.Log.ll "HEAD"
        else Flux.Commands.Log.ll Sys.argv.(2)
    | "checkout" ->
        if argc < 3 then print_endline "Too few arguments"
        else Flux.Commands.Checkout.checkout Sys.argv.(2)
    | "branch" ->
        if argc < 3 then Flux.Commands.Branch.branch_list ()
        else Flux.Commands.Branch.branch_create Sys.argv.(2)
    | "del" ->
        if argc < 3 then print_endline @@ "Too few arguments"
        else Flux.Commands.Branch.branch_delete Sys.argv.(2)
    | "delta" ->
        if argc < 3 then Flux.Commands.Delta.delta "HEAD"
        else Flux.Commands.Delta.delta Sys.argv.(2)
    | "diff" ->
        if argc < 3 then print_endline @@ "Too few arguments"
        else if argc < 4 then Flux.Commands.Diff.diff Sys.argv.(2) "HEAD"
        else Flux.Commands.Diff.diff Sys.argv.(2) Sys.argv.(3)
    | "merge" ->
        if argc < 3 then print_endline "Too few arguments"
        else Flux.Commands.Merge.merge Sys.argv.(2)
    | "graph" ->
        if argc < 3 then Flux.Commands.Graph.graph [ "HEAD" ]
        else
          Flux.Commands.Graph.graph
            (Sys.argv |> Array.to_seq |> Seq.drop 2 |> List.of_seq)
    | "cherry-pick" ->
        if argc < 3 then print_endline "Too few arguments"
        else Flux.Commands.Cherry_pick.cherry_pick Sys.argv.(2)
    | "reset" ->
        if argc < 3 then print_endline "Too few arguments"
        else if argc < 4 then Flux.Commands.Reset.reset Sys.argv.(2) "mixed"
        else Flux.Commands.Reset.reset Sys.argv.(3) Sys.argv.(2)
    | "revert" ->
        if argc < 3 then print_endline "Too few arguments"
        else Flux.Commands.Revert.revert Sys.argv.(2)
    | cmd -> print_endline @@ "Unknown command '" ^ cmd ^ "'. Try flux help"
