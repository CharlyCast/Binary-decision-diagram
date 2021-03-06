include BinaryDecisionDiagram

module BDD = BinaryDecisionDiagram(StringType)
(*module DT = BDD.DT *)

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

let valuation () =
    BDD.print_valuation (BDD.read_valuation ())

let eval () =
    let diag = BDD.read_bdd () in
    if BDD.evaluate diag (BDD.read_valuation ())
    then
        print_string "@t\n"
    else
        print_string "@f\n"

let main = 
    if Array.length Sys.argv > 1 
    then
        (let str = Sys.argv.(1) in
        if String.equal str "dump"
        then
            dump ()
        else if String.equal str "valid"
        then
            valid ()
        else if String.equal str "satisfiable"
        then
            satisfiable ()
        else if String.equal str "valuation"
        then
            valuation ()
        else if String.equal str "eval"
        then
            eval ()
        else
            print_string ("Unknown option : " ^ str ^ "\n"))