include DecisionTree

module type Bdd = functor (T : Type) ->
sig
    type bdd
    type valuation

    val print_bdd : bdd -> unit
    val read_bdd : unit -> bdd
    val evaluate : bdd -> valuation -> bool
    val is_valid : bdd -> bool
    val satisfiable : bdd -> valuation
    val read_valuation : unit -> valuation
    val print_valuation : valuation -> unit
end

module BinaryDecisionDiagram : Bdd = functor (T : Type) -> 
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

    type value =
        (T.t * bool)

    type valuation = 
        value list

    exception MissingValue

    (* bdd are created in the reverse order *)
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

    (* Convert the input decision tree to a binary decision diagram*)
    let dt_to_bdd (dt : DT.t) : bdd =
        let dt = DT.compress dt in
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
    
    let read_bdd () =
        let prop = DT.TParser.convert () in
        let dt = DT.prop_to_dt prop in
        dt_to_bdd dt

    let is_valid (diag : bdd) : bool =
        let (x, l, r) = diag.(0) in
        if x = T.default && l = True && r = True
        then
            true
        else
            false

    let satisfiable (diag : bdd) : valuation =
        let size = Array.length diag - 1 in
        let rec aux (c : child) =
            if c = Label 0
            then
                []
            else
                let k = ref (-1) in 
                let b = ref true in
                let v = ref T.default in
                for i = 0 to size do
                    let (x, l, r) = diag.(i) in
                    if l = c
                    then
                        (k := i;
                        b := true;
                        v := x)
                    else if r = c
                    then
                        (k := i;
                        b := false;
                        v := x)
                done;
                if !k >= 0
                then
                    (!v, !b) :: (aux (Label !k))
                else
                    []
        in 
        List.rev (aux True)

    let rec print_valuation (valu : valuation) =
        match valu with
        | [] ->
            ()
        | (x, b)::s ->
            if b
            then
                (Printf.printf "%s %s\n" (T.type_to_string x) "@t";
                print_valuation s)
            else
                (Printf.printf "%s %s\n" (T.type_to_string x) "@f";
                print_valuation s)

    let rec read_valuation () : valuation =
        let str = read_line () in
        if not (String.equal str "")
        then
            (let s = String.split_on_char ' ' str in
            let var = T.string_to_type (List.hd s) in
            let value = List.hd (List.tl s) in
            if (String.equal value "false") || (String.equal value "f" || (String.equal value "@f"))
            then 
                (var, false) :: (read_valuation ())
            else
                (var, true) :: (read_valuation ()))
        else
            []

    (* Return the value of a variable in the valuation *)
    let get_value (x : T.t) (values : valuation) : bool =
        let rec aux (v : valuation) : bool =
            match v with
            | (x', b)::s ->
                if x' = x
                then
                    b
                else 
                    aux s
            | [] ->
                raise MissingValue
        in
        aux values

    let evaluate (diag : bdd) (values : valuation) : bool =
        let rec aux (i : int) : bool =
            let (x, t, f) = diag.(i) in
            let b = get_value x values in
            if b
            then
                (match t with
                | Label k ->
                    aux k
                | True ->
                    true
                | False ->
                    false)
            else
                (match f with
                | Label k ->
                    aux k
                | True ->
                    true
                | False ->
                    false)
        in
        aux 0
end