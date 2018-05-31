include Type

module type PropType = functor (T : Type) ->
sig
    type prop =
        | True
        | False
        | Not of prop
        | And of prop * prop
        | Or of prop * prop
        | Imply of prop * prop
        | Ioi of prop * prop
        | Val of T.t
        
    val print_prop : prop -> unit
    val get_variables : prop -> T.t list
    val eval : prop -> (T.t, bool) Hashtbl.t -> bool
end

module Prop : PropType = functor (T : Type) ->
struct

    module S = Set.Make(String)

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
            if acc > 0
            then
                (let padding = String.make (4*(acc-1)) ' ' in
                print_string (padding ^ "|" ^ "---"));
            match p' with
            | True ->
                print_string " true\n"
            | False ->
                print_string " false\n"
            | Not p1 ->
                print_string " not\n";
                aux p1 (acc+1)
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
        print_string "\n";
        aux p 0;
        print_string "\n"

    let get_variables (p : prop) : T.t list =
        let h = ref S.empty in
        let rec aux (p' : prop) =
            match p' with
            | Val x ->
                h := S.add (T.type_to_string x) !h
            | True | False ->
                ()
            | Not p1 ->
                aux p1
            | And (p1, p2) | Or (p1, p2) | Imply (p1, p2) | Ioi (p1, p2) ->
                aux p1;
                aux p2
        in
        aux p;
        List.map T.string_to_type (S.elements !h)

    let eval (p : prop) (h : (T.t, bool) Hashtbl.t) : bool =
        let rec aux (p' : prop) : bool =
            match p' with
            | True ->
                true
            | False ->
                false
            | Not p1 ->
                not (aux p1)
            | And (p1, p2) ->
                (aux p1) && (aux p2)
            | Or (p1, p2) ->
                (aux p1) || (aux p2)
            | Imply (p1, p2) ->
                let a1 = aux p1 in
                let a2 = aux p2 in
                (not a1) || a2
            | Ioi (p1, p2) ->
                let a1 = aux p1 in
                let a2 = aux p2 in
                ((not a1) || a2) && ((not a2) || a1)
            | Val x ->
                Hashtbl.find h x
        in 
        aux p
end