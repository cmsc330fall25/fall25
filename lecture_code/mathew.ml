(*
  E -> P - E | P + E | P
  P -> T * P | T / P | T
  T -> N ^ 2 | N
  N -> numbers | (E)

*)

type token = Dash | Plus | Star | Slash 
            | Number of int | Lparen | Rparen 
            | Carot

(* string -> token list *)
let rec lexer input =      
  let dash_re   = Re.compile (Re.Perl.re "^-") in 
  let plus_re   = Re.compile (Re.Perl.re "^\\+") in 
  let star_re   = Re.compile (Re.Perl.re "^\\*") in 
  let slash_re  = Re.compile (Re.Perl.re "^/") in 
  let lparen_re = Re.compile (Re.Perl.re "^\\(") in 
  let rparen_re = Re.compile (Re.Perl.re "^\\)") in 
  let number_re = Re.compile (Re.Perl.re "^(-?[0-9]+)") in 
  let carot_re  = Re.compile (Re.Perl.re "^\\^") in 
  let ws_re     = Re.compile (Re.Perl.re "^ ") in 
  if input = ""
    then []
  else if Re.execp number_re input then 
    let number = Re.Group.get (Re.exec number_re input) 1 in
    let number_len = String.length number in 
    Number(int_of_string number)::(lexer (String.sub input number_len ((String.length input) - number_len)))
  else if Re.execp dash_re input then
    Dash::(lexer (String.sub input 1 ((String.length input) - 1)))
  else if Re.execp plus_re input then
    Plus::(lexer (String.sub input 1 ((String.length input) - 1)))
  else if Re.execp star_re input then
    Star::(lexer (String.sub input 1 ((String.length input) - 1)))
  else if Re.execp slash_re input then
    Slash::(lexer (String.sub input 1 ((String.length input) - 1)))
  else if Re.execp lparen_re input then
    Lparen::(lexer (String.sub input 1 ((String.length input) - 1)))
  else if Re.execp rparen_re input then
    Rparen::(lexer (String.sub input 1 ((String.length input) - 1)))
  else if Re.execp carot_re input then
    Carot::(lexer (String.sub input 1 ((String.length input) - 1)))
  else if Re.execp ws_re input then
    (lexer (String.sub input 1 ((String.length input) - 1)))
  else
    raise (Failure "not a valid word")

type ast = Add of ast * ast
          |Sub of ast * ast
          |Mult of ast * ast
          |Div of ast * ast
          |Square of ast
          |Int of int

(*   deals with n sentences*)
  let rec parse_n tokens = match tokens with
    Number(num)::rest -> (Int(num),rest)
   |Lparen::rest -> 
        let e_tree,e_remain = parse_e rest in 
        (match e_remain with
          Rparen::rest -> (e_tree,rest)
          |_ -> raise (Failure "mismatched parens")
        )
   |_ -> raise (Failure "Not grammatically correct")

(*   deals with t sentences*)
  and parse_t tokens = 
    let n_tree,n_remain = parse_n tokens in
      match n_remain with
      |Carot::Number(2)::rest -> 
            (Square(n_tree),rest)
      |Carot::_ -> raise (Failure "not squared")
      |_ -> (n_tree,n_remain)

(*   deals with p sentences*)
  and parse_p tokens = 
    let t_tree,t_remain = parse_t tokens in
      match t_remain with
      |Star::rest -> 
            let p_tree,p_remain = parse_p rest
            in (Mult(t_tree,p_tree),p_remain)
      |Slash::rest -> 
            let p_tree,p_remain = parse_p rest
            in (Div(t_tree,p_tree),p_remain)
      |_ -> (t_tree,t_remain)

(*   deals with e sentences*)
  and parse_e tokens = 
    let p_tree,p_remain = parse_p tokens in
      match p_remain with
      |Dash::rest -> 
            let e_tree,e_remain = parse_e rest
            in (Sub(p_tree,e_tree),e_remain)
      |Plus::rest -> 
            let e_tree,e_remain = parse_e rest
            in (Add(p_tree,e_tree),e_remain)
      |_ -> (p_tree,p_remain)

(* token list -> ast *)
let parse tokens  = 
  let e_tree,e_remain = parse_e tokens
  in match e_remain with
    [] -> e_tree
    |_ -> raise (Failure "Left over tokens")

(* ast -> int *)
let rec eval tree = match tree with
  |Int(num) -> num
  |Mult(t1,t2) -> let left = eval t1 in
                  let right = eval t2 in 
                  left * right
  |Div(t1,t2) ->  let left = eval t1 in
                  let right = eval t2 in 
                  left / right
  |Square(t1) ->  let value = eval t1 in 
                  value * value
  |Sub(t1,t2) ->  let left = eval t1 in
                  let right = eval t2 in 
                  left - right
  |Add(t1,t2) ->  let left = eval t1 in
                  let right = eval t2 in 
                  left + right
