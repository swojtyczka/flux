(* returns commit file content and its hash *)
let generate_commit (parent : string) (message : string ) : string * string =
  let json = 
    `Assoc [
      "timeStamp", `String (Utils.Timestamp.get ());
      "parent", `String parent;
      "files", Index.read ();
      "message", `String message;
    ]
  in
  let commit = Yojson.Basic.to_string json in
  let commitHash = Sha1.to_hex @@ Sha1.string commit in
  commit, commitHash

let get_commit_timeStamp_and_message (hash : string) : string * string =
  let commit = Yojson.Basic.from_file (Filename.concat ".flux/objects" hash) in
  let timeStamp = Yojson.Basic.Util.to_string @@ Yojson.Basic.Util.member "timeStamp" commit in
  let message = Yojson.Basic.Util.to_string @@ Yojson.Basic.Util.member "message" commit
  in timeStamp, message

let get_commit_parent (hash : string) : string =
  let commit = Yojson.Basic.from_file (Filename.concat ".flux/objects" hash) in
  Yojson.Basic.Util.to_string @@ Yojson.Basic.Util.member "parent" commit

let get_empty_commit_files () : Yojson.Basic.t =
  `List []

let get_commit_files (hash : string) : Yojson.Basic.t =
  if hash = "" || not (Sys.file_exists (Filename.concat ".flux/objects" hash)) then get_empty_commit_files ()
  else
  let commit = Yojson.Basic.from_file (Filename.concat ".flux/objects" hash) in
  Yojson.Basic.Util.member "files" commit
