include DecisionTree

module BinaryDecisionDiagram = functor (T : Type) ->
struct
    module DT = DecisionTree(T)

    type child =
        | Label of int
        | True 
        | False

    type node =
        T.t * child * child

    type bdd =
        node array

    let rev_bdd (diag : bdd) : bdd =
        let l = Array.to_list diag in
        let size = (List.length l) -1 in
        let rec aux a = 
            match a with
            | x::s ->
                let (v, l, r) = x in
                let newl =
                    match l with
                    | Label i ->
                        Label (size - i)
                    | True ->
                        True
                    | False ->
                        False
                in
                let newr =
                    match r with
                    | Label i ->
                        Label (size - i)
                    | True ->
                        True
                    | False ->
                        False
                in
                (v, newl, newr) :: aux s
            | [] ->
                []
        in
        Array.of_list (aux (List.rev l))


    let dt_to_bdd (dt : DT.t) : bdd =
        match dt with
        | DT.Leaf b ->
            if b
            then
                [|(T.default, True, True)|]
            else
                [|(T.default, False, False)|]
        | DT.Node (x, lchild, rchild) ->
            (let h = Hashtbl.create 50 in
            let acc = ref 0 in
            let rec aux (dt' : DT.t) : bdd =
                if Hashtbl.mem h dt'
                then
                    [||]
                else
                    match dt' with
                    | DT.Leaf b ->
                        if b
                        then
                            Hashtbl.add h dt' True
                        else
                            Hashtbl.add h dt' False;
                        [||]
                    | DT.Node (x, l, r) ->
                        let bddl = aux l in
                        let bddr = aux r in
                        let idl = Hashtbl.find h l in
                        let idr = Hashtbl.find h r in
                        if l = r
                        then
                            (Hashtbl.add h dt' (Hashtbl.find h l);
                            Array.concat [bddl; bddr])
                        else
                            (Hashtbl.add h dt' (Label !acc);
                            acc := !acc + 1;
                            Array.concat [bddl; bddr; [|(x, idr, idl)|]])
            in
            rev_bdd (aux (DT.compress dt)))

    let print_bdd (diag : bdd) =
        for i = 0 to (Array.length diag) -1 do
            let (x, f, t) = diag.(i) in
            let fstr = 
                match f with
                | Label fi ->
                    string_of_int fi
                | True ->
                    "@t"
                | False ->
                    "@f"
            in
            let tstr = 
                match t with
                | Label ti ->
                    string_of_int ti
                | True ->
                    "@t"
                | False ->
                    "@f"
            in
            Printf.printf "%d %s %s %s\n" i (T.type_to_string x) fstr tstr
        done
end