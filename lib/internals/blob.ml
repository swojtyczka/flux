(* returns blob content and its hash *)
let generate (contents : string) : string * string =
  let blobJson = `Assoc ["type", `String "blob"; "content", `String contents] in
  let blob = Yojson.to_string blobJson in
  let blobFileName = Sha1.to_hex @@ Sha1.string blob in
  blob, blobFileName