include Type

module Prop = functor (T : Type) ->
struct
    type prop = 
        | True
        | False
        | Not of prop
        | And of prop * prop
        | Or of prop * prop
        | Imply of prop * prop
        | Ioi of prop * prop
        | Val of T.t

    let print_prop (p : prop) =
        let rec aux (p' : prop) (acc : int) =
            let padding = String.make (4*acc) '-' in
            print_string padding;
            match p' with
            | True ->
                print_string " true\n"
            | False ->
                print_string " false\n"
            | Not p'' ->
                print_string " not\n";
                aux p'' (acc+1)
            | And (p1, p2) ->
                print_string " and\n";
                aux p1 (acc+1);
                aux p2 (acc+1)
            | Or (p1, p2) ->
                print_string " or\n";
                aux p1 (acc+1);
                aux p2 (acc+1)
            | Imply (p1, p2) ->
                print_string " =>\n";
                aux p1 (acc+1);
                aux p2 (acc+1)
            | Ioi (p1, p2) ->
                print_string " <=>\n";
                aux p1 (acc+1);
                aux p2 (acc+1)
            | Val x ->
                print_string (" " ^ (T.type_to_string x) ^ "\n")
        in
        aux p 0
end