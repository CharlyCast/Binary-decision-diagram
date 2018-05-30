include Parser

module P = Parser(StringType)

let values () =
    print_string "Input proposition :\n";
    let prop = P.convert () in
    print_string "Variables values :\n";
    let h = Hashtbl.create 10 in 
    let rec aux ()=
        let str = read_line () in
        if not (String.equal str "")
        then
            (let s = String.split_on_char ' ' str in
            let var = StringType.string_to_type (List.hd s) in
            let value = List.hd (List.tl s) in
            if (String.equal value "false") || (String.equal value "f") || (String.equal value "@f")
            then 
                Hashtbl.add h var false
            else
                Hashtbl.add h var true;
            aux ())
    in
    aux ();
    P.TProp.eval prop h

let main =
    (*P.TProp.print_prop (P.convert ())*)
    if values ()
    then
        print_string "Evaluated to : True\n"
    else
        print_string "Evaluated to : False\n"
