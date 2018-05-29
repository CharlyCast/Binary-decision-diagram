module type Type = sig
    type t
    val default : t
    val string_to_type : string -> t
    val type_to_string : t -> string
end

module StringType =
(struct
    type t = string
    let default = "none"
    let string_to_type s = s
    let type_to_string s = s
end: Type)