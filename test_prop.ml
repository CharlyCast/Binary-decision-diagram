include Parser

module P = Parser(StringType)

let main =
    P.TProp.print_prop (P.convert ())
