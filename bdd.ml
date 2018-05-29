include BinaryDecisionDiagram

module BDD = BinaryDecisionDiagram(StringType)
module DT = BDD.DT

let test () =
    print_string "Input proposition :\n";
    let prop = DT.TParser.convert () in
    print_string "Full decision tree :\n";
    let dt = DT.prop_to_dt prop in
    DT.print_dt dt;
    print_string "Compressed decision tree :\n";
    DT.print_dt (DT.compress dt);
    print_string "Binary decision diagram :\n";
    BDD.print_bdd (BDD.dt_to_bdd dt)

let dump () =
    BDD.print_bdd (BDD.read_bdd ())

let valid () =
    if BDD.is_valid (BDD.read_bdd ())
    then
        exit 0
    else
        exit 1

let satisfiable () =
    BDD.print_valuation (BDD.satisfiable (BDD.read_bdd ()))

let main = 
    if Array.length Sys.argv > 1 
    then
        (let str = Sys.argv.(1) in
        if String.equal str "test"
        then
            test ()
        else if String.equal str "dump"
        then
            dump ()
        else if String.equal str "valid"
        then
            valid ()
        else if String.equal str "satisfiable"
        then
            satisfiable ()
        else
            print_string ("Unknown option : " ^ str ^ "\n"))