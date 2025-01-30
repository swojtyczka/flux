let get () : string =
  let today = Unix.localtime (Unix.time ()) in
  let day = today.Unix.tm_mday in
  let month = today.Unix.tm_mon + 1 in
  let year = today.Unix.tm_year + 1900 in
  let hour = today.Unix.tm_hour in
  let minute = today.Unix.tm_min in
  let second = today.Unix.tm_sec in
  Printf.sprintf "%02d.%02d.%d %02d:%02d:%02d" day month year hour minute second
