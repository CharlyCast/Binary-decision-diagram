include Parser

module DecisionTree = functor (T : Type) ->
struct
    module TParser = Parser(T)

    open TParser.TProp

    type t = 
        | Node of T.t * t * t 
        | Leaf of bool

    let print_dt (dt : t) =
        let rec aux (dt' :t) acc =
            if acc > 0
            then
                (let padding = String.make (4*(acc-1)) ' ' in
                print_string (padding ^ "|" ^ "---"));
            match dt' with
            | Node (x, l, r) ->
                print_string (" " ^ (T.type_to_string x) ^ "\n");
                aux l (acc+1);
                aux r (acc+1);
            | Leaf b ->
                if b
                then
                    print_string " True\n"
                else
                    print_string " False\n"
        in
        print_string "\n";
        aux dt 0;
        print_string "\n"

    let prop_to_dt (p : prop) : t = 
        let vars = get_variables p in
        let h = Hashtbl.create (List.length vars) in
        let rec aux (l : T.t list) : t =
            match l with
            | x::s ->
                Hashtbl.replace h x false;
                let left = aux s in
                Hashtbl.replace h x true;
                let right = aux s in
                Node (x, left, right)
            | [] ->
                Leaf (eval p h)
        in
        aux vars

    let rec compress (dt : t) : t =
        match dt with
        | Leaf b ->
            Leaf b
        | Node (x, l ,r) ->
            (let left = compress l in
            let right = compress r in
            match left with
            | Node (xl, ll, rl) ->
                Node (x, left, right)
            | Leaf bl ->
                (match right with
                | Node (xr, lr, rr) ->
                    Node (x, left, right)
                | Leaf br ->
                    if bl = br
                    then
                        Leaf bl
                    else
                        Node (x, left, right)))
end