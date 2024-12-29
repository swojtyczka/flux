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
        if argc < 3 then Flux.Commands.Log.log ()
        else Flux.Commands.Log.log_from Sys.argv.(2)
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
        if argc < 3 then
          Flux.Commands.Delta.delta
          @@ Flux.Internals.Head.get_current_commit_hash ()
        else Flux.Commands.Delta.delta Sys.argv.(2)
    | cmd -> print_endline @@ "Unknown command '" ^ cmd ^ "'. Try flux help"
