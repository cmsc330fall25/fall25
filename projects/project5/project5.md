# Project 5: Type Inferencing and Checking
Due: Tuesday November 25, 2025 at 11:59 PM (Late: Wednesday, November 26, 2025 at 11:59 PM)

Points: 20 public, 60 semipublic, 20 secret.

## Introduction

In this project, you will implement a inferencer for a modified version of the MicroCaml language you worked with in project 4, as well as a type checker for a new language called SmallC. 

### Ground Rules and Extra Info

In addition to all of the built in OCaml features and feature we've taught about in class **besides imperative OCaml**, you may also use library functions found in the Stdlib module, and List module.


## Part (A): SmallC Type Checker

In this portion of the project, you will implement a type checker for a new language called SmallC - a version of the language C with a subset of the features. You do not need to worry about lexing and parsing SmallC - a 'lexer_c.mll' and 'parser_c.mly' file have been provided for you. You can create an AST be using `parse_c_expr` in utop, as in some examples given later.

>NOTE! You **MUST** test with `dune utop` rather than `dune utop src` for this project, as the parser helpers are defined outside of src. In previous projects, you may have used `dune utop src` to test in utop, but here you must use `dune utop` instead.

The relevant variant types, ASTs, and CFGs are below:

```ocaml
type c_exptype =
  | Int_Type
  | Bool_Type
  | Unknown_Type of int  (* represents "user inputted" values *)
```

`c_expr` type:
```ocaml
type op =
  | Add
  | Sub
  | Mult
  | Div
  | Greater
  | Less
  | GreaterEqual
  | LessEqual
  | Equal
  | NotEqual
  | Or
  | And

type c_expr =
  | Integer of int
  | Boolean of bool
  | VarID of var
  | OpBin of op * c_expr * c_expr
  | OpNot of c_expr
  | Value  (* represents "user inputted" values *)
```
\
Here is the CFG that the provided parser is based off of. It will not be super important to your work, but may be relevant when you are thinking up student test cases.

`c_expr` CFG:
- Expr -> OrExpr
- OrExpr -> AndExpr `||` OrExpr | AndExpr
- AndExpr -> EqualityExpr `&&` AndExpr | EqualityExpr
- EqualityExpr -> RelationalExpr EqualityOperator EqualityExpr | RelationalExpr
  - EqualityOperator -> `==` | `!=`
- RelationalExpr -> AdditiveExpr RelationalOperator RelationalExpr | AdditiveExpr
  - RelationalOperator -> `<` | `>` | `<=` | `>=`
- AdditiveExpr -> MultiplicativeExpr AdditiveOperator AdditiveExpr | MultiplicativeExpr
  - AdditiveOperator -> `+` | `-`
- MultiplicativeExpr -> UnaryExpr MultiplicativeOperator MultiplicativeExpr | UnaryExpr
  - MultiplicativeOperator -> `*` | `/`
- UnaryExpr -> `!` UnaryExpr | PrimaryExpr
- PrimaryExpr -> *`Tok_Int`* | *`Tok_Bool`* | *`Tok_ID`* | `read()` | `(` Expr `)`

`stmt` CFG:
- Stmt -> StmtOptions Stmt | ε
  - StmtOptions -> AssignStmt | PrintStmt | IfStmt | ForStmt | WhileStmt
    - AssignStmt -> ID `=` Expr `;`
    - PrintStmt -> `printf` `(` Expr `)` `;`
    - IfStmt -> `if` `(` Expr `)` `{` Stmt `}` ElseBranch
      - ElseBranch -> `else` `{` Stmt `}` | ε
    - ForStmt -> `for` `(` ID `from` Expr `to` Expr `)` `{` Stmt `}`
    - WhileStmt -> `while` `(` Expr `)` `{` Stmt `}`

`stmt` type:
```ocaml
type stmt =
  | NoOp  
  (* to represent a missing 'else' branch: *)
  | Seq of stmt * stmt  (* `x = 4; y = 3;` is a Sequence of two assignments *)
  | Assign of string * c_exptype * c_expr
  | If of c_expr * stmt * stmt              
  | For of string * c_expr * c_expr * stmt  (* for string starting at c_expr ending at other c_expr, do stmt* )
  | While of c_expr * stmt  (* while c_expr, do stmt *)
  | Print of c_expr (* Print the result of an expression *)
```

Examples of SmallC being parsed (not yet typechecked)
```ocaml
parse_c_expr "
  int main(){
    if (4 == 5){
      x = 2;
    } 
    else {
      y = 3;
    }
  }"
=
If (
  OpBin (Equal, Integer 4, Integer 5),
  Assign ("x", Unknown_Type 1, Integer 2),
  Assign ("y", Unknown_Type 2, Integer 3)
)

parse_c_expr "
  int main(){
    if (4 == 5){
      x = 2;
      z = 4;
    }
  }"
=
If (
  OpBin (Equal, Integer 4, Integer 5),
  Seq (
    Assign ("x", Unknown_Type 3, Integer 2),
    Assign ("z", Unknown_Type 4, Integer 4)
  ),
  NoOp
)

parse_c_expr "
  int main(){
    for(a from 4 to 12){
      printf(x);
    }
  }"
= 
For ("a", Integer 4, Integer 12, Print (VarID "x"))
```

### Type Checker

> [!IMPORTANT]
> All typechecking rules for SmallC can be found in **[smallc_typecheck.pdf](smallc_typecheck.pdf)**
> You will be very confused and get things wrong if you do not reference [smallc_typecheck.pdf](smallc_typecheck.pdf) while doing this project.
> As such, please reference [smallc_typecheck.pdf](smallc_typecheck.pdf) regularly.

It may be helpful to reference your evaluator from project 4 when working in this section - just like opsem and typechecking proofs are similar, eval code and typechecking code will have similar structure.

#### `typecheck : stmt -> bool`

* **Description:** Takes in an AST `stmt`, type checks it, returning `true` if the expression passes the type checker, else throws an error.

* **Exception:** Throws a `TypeError` if the expression does not type check. 
* **Exception:** Throws a `DeclareError` if there is an unbound variable. 
* **Assumptions:**
  - Every variable name will be unique (no shadowing).
  - The given type in the Ast for any variable will be consistent throughout the same program. 

Important note: we give you the assumption that there is *no shadowing* and that you can be sure that *all* test cases will have the *same* declared type for an assignment on the same variable. 

So you will *never* see this: 

`Seq (Assign ("x", Bool_Type, ...), Assign ("x", Int_Type, ...))` 

You will only ever see this:

`Seq (Assign ("x", Bool_Type, ...), Assign ("x", Bool_Type, ...))`

#### In other words:

We are going to give you an AST. This AST will have various assignments, which as above take the form:

```
Assign of string * c_exptype * c_expr
aka
Assign of variable_name * declared_type * value_to_be_bound
```

Later, these variables will be used in various places, like perhaps being added to something, used in a for loop, or compared to something. 

Your goal is to tell us: yes, the assignment and usage all match the declared type of all variables used, or no, the assignment and usage do *not* all match the declared type of all variables used.

Examples:
```ocaml
typecheck (Assign("x",Int_Type,Binop(Add,Int(3),Int(5)))) => true
typecheck (Assign("y",Bool_Type,Binop(Equal,Int(5),Int(3)))) => true
typecheck (Assign("z",Bool_Type,Int(4))) => (* TypeError *)
typecheck (Assign("x",Int_Type,Binop(Add,Int(3),Bool(true)))) => (* TypeError *)
typecheck (Assign("y",Int_Type,Binop(Add,Int(3),ID("x")))) => (* DeclareError *)

typecheck (Seq(Assign("x",Int_Type,Int(3)),Assign("x",Int_Type,Bool(true)))) => (* Type Error *)
typecheck (Seq(Assign("x",Bool_Type,Int(3)),Assign("x",Bool_Type,Bool(true)))) => (* Type Error *)
typecheck (Seq(Assign("x",Unknown_Type(0),Int(3)),Assign("x",Unknown_Type(0),Bool(true)))) => true (* see below about Unknown_Type *)
typecheck (Seq(Assign("x",Int_Type,Int(3)),Assign("x",Bool_Type,Bool(true)))) => (* Will never occur due to second assumption *)
```

#### Unknown_Type

When you use the provided helper `parse_c_expr` in `dune utop` to make your own test cases, all assignments will have a declared type of "unknown" due to how this parser is written.

***Important Note***: As in the examples above, in most test cases we test you on, we have replaced the default declared type with either `Bool_Type` or `Int_Type`, and you have to figure out if assignments and usages match those. For instance:

```ocaml
(* 
  // x is declared as 'Int_Type' in the AST
  int main(){
    x = 3; // ok
    x = true; // causes failure - attempt to assign bool type to int-declared x
  }
*)
typecheck (Seq (Assign ("x", Int_Type, Integer 4), Assign ("x", Int_Type, Boolean true))) = (*failure*)

(* 
  // x is declared as 'Bool_Type' in the AST
  int main(){
    x = 3; // causes failure - attempt to assign int type to bool-declared x
    x = true; // ok
  }
*)
typecheck (Seq (Assign ("x", Bool_Type, Integer 4), Assign ("x", Bool_Type, Boolean true))) = (*failure*)
```

However, in some, it is left as `Unknown_Type`, which is a subtype of both Int and Bool - since this is a *typechecker* that does *no inference*, even if that variable is used in conflicting ways, the typechecker will not catch it:

```ocaml
(* 
  // assume x is declared as 'Unknown_Type(1)' in the AST
  int main(){
    x = 3; // ok to assign int type to an unknown-declared x
    x = true; // ok to assign bool type to an unknown-declared x
  }
*)
typecheck (Seq (Assign ("x", Unknown_Type(1), Integer 4), Assign ("x", Unknown_Type(1), Boolean true))) = true
```

The result type of `read() -> Value` will be an `Unknown_Type`. This is a crude representation of "user input" which you don't know the type of.
```ocaml
(* int main(){
    x = read();
  } *)
typecheck (Assign("x",Int_Type,Value)) = true (* ok b/c the read in Value has Unknown_Type, a subtype of Int_Type *)
typecheck (Assign("x",Bool_Type,Value)) = true (* ok b/c the read in Value has Unknown_Type, a subtype of Bool_Type *)
typecheck (Assign("x",Unknown_Type(0),Value)) = true (* ok *)

(* int main(){
    x = read();
    y = x && (x < 3)
}*)
typecheck (Seq(Assign("x",Unknown_Type(0),Value),Assign("y",Bool_Type,Binop(And,ID("x"),Binop(Less,ID("x"),Int(3)))))) = true (* ok b/c the declared type was Unknown_Type, so as far as the typechecker knows, the read() assignment is valid, the usage of x as a boolean is valid, and the usage of x as an integer is also valid*)
```

You can see these more formally as part of the "subtyping rules" in the PDF with the typechecking rules. 

**Again, you *must* look at the PDF to know how to approach this project.**


## Part (B): MicroCaml Type Inferencer

In Part (A), we wrote a type checker for SmallC. If we saw a variable that was some unknown type, our typechecker never tried to infer what types it could be, and never attempted to find contradictions in its usage. Now, we will write a type inferencer for MicroCaml - this *will* try to infer unknown types when it can. 

> Again, you *must* reference the **[microcaml_typeinference.pdf](microcaml_typeinference.pdf)** PDF as you start coding this section of the project. If you do not, you will have a hard time re-deriving the rules we expect from you.

Part (B) will be fairly similar in structure to Part (A), but more complex. As such, we provide you with descriptions for helpers that you will need. There are no public tests regarding these helpers explicitly, but if you do not implement them you will have a hard, if not impossible, time writing the inferencer.

### AST

Below is the AST type `o_expr`, which is returned by the parser for OCaml `parse_o_expr`. We provided the lexer and parser generators (ocamllex, ocamlyacc) for this project. 

If you want, you could use your own parser from Project 4, but you will have to update it according to the new AST. Most notably we removed `string` support and added a new type: `TTick of int`. However, we recommend using the provided `parse_o_expr` for simplicity.
```ocaml
(* Binary operators *)
type op =
  | Add
  | Sub
  | Mult
  | Div
  | Greater
  | Less
  | GreaterEqual
  | LessEqual
  | Equal
  | NotEqual
  | Or
  | And

type var = string  (* for variable names *)
type label = Lab of var  (* for labels in a record *)

(* Types in MicroCaml *)
type o_exptype =
  | TInt
  | TBool
  | TTick of int (* this represents a polymorphic type: 'a, 'b, ... *)
  | TArrow of exptype * exptype  (* this represents a function: 'a -> 'b *)
  | TRec of (label * exptype) list  (* this represents a record type *)
  | TScheme of (int list * exptype) (* allows for let polymorphism - more on this later *)


(* MicroCaml AST *)
type o_expr =
  | Int of int
  | Bool of bool
  | ID of var
  | Binop of op * o_expr * o_expr
  | Not of o_expr
  | If of o_expr * o_expr * o_expr
  | Fun of var * o_expr
  | App of o_expr * o_expr
  | Record of (label * o_expr) list
  | Select of label * o_expr
  | Let of var * bool * o_expr * o_expr

type context = (string * o_exptype) list  (* context (i.e. environment) usef in typeinference *)
type constraints = (o_exptype * o_exptype) list  (* constraints produced by typeinference *)
```

### Type Inferencer Preview

When we performed opsem in class, the proofs utilized an *environment* to reduce an expression to some *value*. There were two cases:

1) We couldn't perform the proof, and we fail to evaluate.
2) We found a value.

When we performed type checking in class, the proofs utilized a *context* to reduce an expression to some *type*. If that type was, say, `int`, then that expression has type `int`. There were two cases:

1) We couldn't perform the proof, and we fail to typecheck.
2) We found a type.

When we perfomed type inference in class, the proofs utilized a *context* to reduce an expression to some *type* and some *set of constraints*. There were 2 (and a half, sort of) cases:

1) We found a type and a set of constraints, but that set of constraints didn't unify properly, and we fail to infer.
2) We found a type and a set of valid constraints, and so we found what might be the type. 

After we do the proof and then confirm the constraints are valid, we have a step two: what is the actual type?

The type we found was either a non-polymorphic type (like `int` or `bool`), in which case that's the final type. Or, it's a polymorphic type (like `'a`), in which case we need to look at the constraint list and see if we know anything about it. 

If the constraints don't say anything about `'a`, then we're done, that's the final type. If they do say something about `'a`, ex. `{'a:'b, 'b:bool}`, the final type can be inferred to be something else: in this example `bool`.

As such, the type inferencer you are writing here will have to keep track of a context and produce a type and a set of constraints. Then, it must verify that the constraints are valid, and substitute any useful ones into the final type to be returned.

## Type Inferencer Helpers

Type inference for MicroCaml will require a few helpers that type checking and evaluation did not. These are not tested directly in the publics, so we recommend testing them in `dune utop` with the cases provided here in the readme plus any of your own. You *will* need these helpers to properly write your inferencer.

>Note: This project will *not* implement let polymorphism. This means you will not need to implement 'generalize' or 'instantiate', which you may have seen referenced in some class notes.

Inference takes in an expression and produces a tentative type and a set of constraints. We need to confirm that there are no contradictions in the constraints (`unify`), then possibly later apply those constraints to the tentative type (`substitute`) to get our final type.

### Unify

Goal: `unify` will 1) check for contradictions, and possibly 2) if there are none, return a more easily-usable set of constraints for the later substitution.

#### `unify : constraints -> constraints`
* **Description:** Given a set of constraints, either fail using a `failwith` if there is a contradiction in the constraints or else return an equivalent (possibly simplified by the rules given below) list of constraints.

* **Exceptions:** Do a `failwith` with any message if your constraints cannot be unified.

Example:

```ocaml
(* original constraint list *)
let const = [(TTick(1), TBool); (TInt, TInt); (TTick(2), TTick(1)); (TArrow(TTick(1), TInt), TTick(3)); (TTick(3), TArrow(TTick(4), TInt))];;

(* unify and get simplified list *)
let simple = unify const;;
simple = [(TTick 4, TBool); (TTick 3, TArrow (TBool, TInt)); (TTick 2, TBool); (TTick 1, TBool)];;
```

**How do we actually perform unification?**

Here is a suggested set of steps to follow:

Note: You do not have to *exactly* follow the rules given below to do unification - the idea of this is just to 1) find out if the constraints fail, then 2) if not, be able to later use those constraints to substitute in and find out the actual type. The method described below is just one way to do (1) and set yourself up for an easier time doing (2).

So, any time where we say "you may want to...", this is a suggestion based on what might be useful to you when writing the next helper, `substitute`.

Recall: A polymorphic type is something like `'a`, `'b` which in this project is `TTick(1)`, `TTick(2)`.

Suggested rules: Given a constraint `t1:t2`:

1) If the constraint *cannot* be true (ex. `bool:int` or `(bool -> 'a):'a`), fail.

2) If the constraint is plainly true (ex. `'a:'a`), it's not super useful, so you can remove it from the final list if you want.

3) If the constraint is possible and involves two functions (ex: `('a -> 'b):(int -> bool)`), you may want to save the inputs and output constraints separately (ex: `'a:int, 'b:bool`).

4) If the constraint is possible, you may want to 1) propagate the information forward, and 2) keep the constraint in the final simplified list.

One full example that follows these suggestions:
```ocaml
(* original constraint list *)
let const = [(TTick(1), TBool); (TInt, TInt); (TTick(2), TTick(1)); (TArrow(TTick(1), TInt), TTick(3)); (TTick(3), TArrow(TTick(4), TInt))];;

(* unify and get simplified list *)
let simple = unify const;;
simple = [(TTick 4, TBool); (TTick 3, TArrow (TBool, TInt)); (TTick 2, TBool); (TTick 1, TBool)];;
```
^ in more readable terms and step by step:
```
['a:bool, int:int, 'b:'a, ('a -> int):'c, 'c:('d -> int)]

1) 'a:bool is useful, so save it and propagate it:
saved: ['a:bool]
todo: [int:int, 'b:bool, (bool -> int):'c, 'c:('d -> int)]

2) int:int is not useful, discard it:
saved: ['a:bool]
todo: ['b:bool, (bool -> int):'c, 'c:('d -> int)]

3) 'b:bool is useful, so save it an propagate it:
saved: ['a:bool, 'b:bool]
todo: [(bool -> int):'c, 'c:('d -> int)]

4) (bool -> int):'c is useful, so save it an propagate it:
saved: ['a:bool, 'b:bool, 'c:(bool -> int)]
todo: [(bool -> int):('d -> int)]

5) (bool -> int):('d -> int) might be possible depending on what 'd is, so we'll want to check if its component parts are possible:
saved: ['a:bool, 'b:bool, 'c:(bool -> int)]
todo: [bool:'d, int:int]

6) bool:'d is useful, so save it an propagate it:
saved: ['a:bool, 'b:bool, 'c:(bool -> int), 'd:bool]
todo: [int:int]

7) int:int is not useful, discard it:
saved: ['a:bool, 'b:bool, 'c:(bool -> int), 'd:bool]
todo: []

8) We have nothing more to check, so we succeed and return the simplified list!
```

Great! Now we have `unify`, a helper that makes sure unification of the constraints is possible (by failing if it's not) and ideally gives us a simpler, more usable list with which to substitute!


### Substitute

Goal: Type inference has produced a tentative type and a set of constraints. We have presumably performed unification to check that the constraint set is valid. Now, we need to `substitute` those constraints into the tentative type.

For instance, if inference produced a tentative type `int` and a constraint set `{'a:'b, 'b:int}`, when we apply those constraints to the tentative type, no changes occur, and our final type is `int`. 

However, if we had the same constraint set with a tentatitive type `'a -> ('b -> bool)`, the final type of the expression should be `int -> (int -> bool)`.

#### `substitute : constraints -> o_exptype -> o_exptype`
* **Description:** Given a constraint list (perhaps a simplified one) and a type, substitute any information gained from the constraint list into the type to get a final type.

Note: We're saying "perhaps" because it's up to you how you use/don't use these helpers. Our suggested method is to use `unify` to check the validitiy of your constraints and produce a simpler list in some expected format which you can then pass to `substitute`, but you can combine these two or make substitute expect the original constraint list if you prefer.

Example:

```ocaml
(* some constraint list *)
let simple_constraints = [(TTick 4, TBool); (TTick 3, TArrow (TBool, TInt)); (TTick 2, TBool); (TTick 1, TBool)];;

(* get some type we want to substitute into *)
let maybe_type = TArrow(TTick(3), TTick(4));;

(* do the substitution *)
let result = substitute simple_constraints maybe_type;;
result = TArrow(TArrow (TBool, TInt), TBool);;
```

#### Recap:

Our goal is to take in an expression, produce a tentative type and list of constraints, confirm the constraints are valid, and substitute the constraints into the tentative type for a final answer.

To help with this, we have helpers `unify`, `substitute`, `fresh`, plus any helpers you may want to write.


## Type Inferencer

This is the part you're actually required to write - all the rest of those above are technically optional helpers.

> REMINDER: Reference the type inference PDF while you are writing this code, otherwise you might have a much harder time succeeding at this project.

#### `infer: o_expr -> o_exptype`
* **Description:** Take in an expression and either fail or return the type of the expression.

* **Exceptions:** A `failwith` is called if the constraint set is impossible to unify.

Examples:

```ocaml
infer (parse_o_expr "1") = TInt

infer (parse_o_expr "1 + 5") = TInt

infer (parse_o_expr "fun x -> 1") = TArrow (TTick 1, TInt)

infer (parse_o_expr "let x = fun x -> x && true in x false") = TBool

infer (parse_o_expr "fun x -> if true then x + 1 else x") = TArrow (TInt, TInt)

infer (parse_o_expr "1 && false") = failure

infer (parse_o_expr "fun x -> if true then x + 1 else x && 1") = failure

```

> REMINDER: Reference the type inference PDF while you are writing this code, otherwise you might have a much harder time succeeding at this project.

### Testing & Submitting

Submit by running `submit` after pushing your code to GitHub. 

All tests will be run on direct calls to your code, comparing your return values/failure to the expected return values/failure. Any other output (e.g., for your own debugging) will be ignored. We recommend using relevant error messages when raising exceptions in order to make debugging easier. We are not requiring intelligent messages that pinpoint an error to help a programmer debug, but as you do this project you might find you see where you could add those.

To test from the toplevel, run `dune utop`. The necessary functions and types will automatically be imported for you. For this project, use `dune utop` instead of `dune utop src` to be able to use the provided parsers.

## Academic Integrity

Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. This includes posting this project to GitHub after the course is over. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

## Checkout

If you have read the ground rules and project spec, you can check out your project repository [here](https://classroom.github.com/a/48ZEHAKc)
