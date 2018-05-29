include BinaryDecisionDiagram

module BDD = BinaryDecisionDiagram(StringType)
module DT = BDD.DT

let main =
    print_string "Input proposition :\n";
    let prop = DT.TParser.convert () in
    print_string "Full decision tree :\n";
    let dt = DT.prop_to_dt prop in
    DT.print_dt dt;
    print_string "Compressed decision tree :\n";
    DT.print_dt (DT.compress dt);
    print_string "Binary decision diagram :\n";
    BDD.print_bdd (BDD.dt_to_bdd dt)


