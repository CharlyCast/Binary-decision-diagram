include Prop

module Parser = functor (T : Type) ->
struct
    module TProp = Prop(T)

    type token_value =
        | True
        | False
        | Not
        | And
        | Or
        | Imply
        | Ioi
        | Val
        | LeftParenthesis
        | RightParenthesis

    type priority = int

    type associativity = Left | Right | Null

    type symbol = string * token_value * priority * associativity

    (* Match a string to a symbol *)
    let token_type (t : string) : symbol =
        if String.equal t "true"
        then 
            (t, True, 1, Null)
        else if String.equal t "false"
        then 
            (t, False, 1, Null)
        else if String.equal t "~"
        then
            (t, Not, 2, Left)
        else if String.equal t "&&"
        then
            (t, And, 3, Left)
        else if String.equal t "||"
        then
            (t, Or, 4, Left)
        else if String.equal t "->"
        then
            (t, Imply, 5, Right)
        else if String.equal t "<->"
        then
            (t, Ioi, 6, Null)
        else if String.equal t "("
        then
            (t, LeftParenthesis, 15, Null)
        else if String.equal t ")"
        then
            (t, RightParenthesis, 15, Null)
        else 
            (t, Val, 1, Null)

    (* Transform the input list of token separated with space *)
    (* into a queue and handle the case of symbol without space between *)
    (* such as parenthesis or not : ~a *)
    let token_list_to_queue (tokens : string list) =
        let tkq = Queue.create () in
        let rec aux (tk : string list) =
            match tk with
            | [] ->
                ()
            | x::s ->
                if String.length x = 0
                then 
                    aux s
                else
                    (let firstChar = x.[0] in
                    let lastChar = x.[String.length x -1] in
                    if firstChar = '(' || firstChar = '~'
                    then
                        (Queue.push (String.make 1 firstChar) tkq;
                        if String.length x > 1
                        then
                            aux ((String.sub x 1 (String.length x -1))::s)
                        else
                            aux s)
                    else if lastChar = ')'
                    then
                        (let lastString = String.make 1 lastChar in
                        if String.length x > 1
                        then
                            Queue.push (String.sub x 0 (String.length x -1)) tkq;
                        Queue.push lastString tkq;
                        aux s)
                    else
                        (Queue.push x tkq;
                        aux s))
        in
        aux tokens;
        tkq

    exception MissingParenthesis

    (* Parse the input string using the shunting-yard alogirthm *)
    (* The output Reverse Polish notation can be easily converted *)
    (* to a proposition tree *)
    let parse () = 
        let tokens = String.split_on_char ' ' (read_line ()) in
        let tkq = token_list_to_queue tokens in (* Input stack that contains the tokens to be parsed *)
        let opst = Stack.create () in (* Operator stack *)
        let outst = Stack.create () in (* Output stack *)
        while not (Queue.is_empty tkq) do
            let (str, t, p, a) = token_type (Queue.take tkq) in
            match t with
            | True | False | Val->
                Stack.push (str, t, p, a) outst
            | Not -> 
                Stack.push (str, t, p, a) opst
            | And | Or | Imply | Ioi ->
                let continue = ref (not (Stack.is_empty opst)) in
                while !continue do
                    let (str', t', p', a') = Stack.top opst in
                    if ((a = Right || a = Left) && p >= p') || (a = Right && p > p')
                    then (
                        Stack.push (Stack.pop opst) outst;
                        if Stack.is_empty opst
                        then
                            continue := false)
                    else
                        continue := false
                done;
                Stack.push (str, t, p, a) opst
            | LeftParenthesis ->
                Stack.push (str, t, p, a) opst
            | RightParenthesis ->
                let continue = ref (not (Stack.is_empty opst)) in
                while !continue do
                    let (str', t', p', a') = Stack.top opst in
                    if t' != LeftParenthesis
                    then
                        Stack.push (Stack.pop opst) outst
                    else
                        continue := false;
                    if Stack.is_empty opst
                    then
                        continue := false 
                done;
                if Stack.is_empty opst
                then
                    raise MissingParenthesis
                else
                    ignore (Stack.pop opst)
        done;
        while not (Stack.is_empty opst) do
            let (str, t, p, a) = Stack.pop opst in
            if t = LeftParenthesis
            then
                raise MissingParenthesis
            else
                Stack.push (str, t, p, a) outst
        done;
        outst

    exception RPNError

    (* Reverse Polish notation to proposition tree *)
    let rpn_to_prop (st : symbol Stack.t) : TProp.prop = 
        let rec aux () = 
            let (str, t, p, a) = Stack.pop st in
            match t with
            | True ->
                TProp.True
            | False ->
                TProp.False
            | Not ->
                TProp.Not (aux ())
            | And ->
                TProp.And (aux (), aux ())
            | Or ->
                TProp.Or (aux (), aux ())
            | Imply ->
                TProp.Imply (aux (), aux ())
            | Ioi ->
                TProp.Ioi (aux (), aux ())
            | Val ->
                TProp.Val (T.string_to_type str)
            | LeftParenthesis | RightParenthesis ->
                raise RPNError
        in
        aux ()


    (* Can be use for debugging *)
    let print_stack (st : symbol Stack.t) =
        print_string "\n";
        let f (str, t, p, a) =
            print_string str;
            print_string "\n"
        in
        Stack.iter f st

    (* Can be used for debugging *)
    let read () = 
        print_stack (parse ())

    let convert () =
        rpn_to_prop (parse ())
end