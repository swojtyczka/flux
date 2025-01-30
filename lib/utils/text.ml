let decorate (str : string) (effects : string list) : string =
  "\027["
  ^ (List.map
       (function
         | "bold" -> "1"
         | "underline" -> "4"
         | "black" -> "30"
         | "red" -> "31"
         | "green" -> "32"
         | "yellow" -> "33"
         | "blue" -> "34"
         | "magenta" -> "35"
         | "cyan" -> "36"
         | "white" -> "37"
         | _ -> "")
       effects
    |> String.concat ";")
  ^ "m" ^ str ^ "\027[0m"
