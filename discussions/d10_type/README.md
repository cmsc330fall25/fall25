# Discussion 10 - Friday, November 7th

## Reminders

1. Quiz Today!
2. Project 4 is released, due **November 11th @ 11:59PM**.
3. Exam 2 on **November 18th**


## Type Inference
There is 2 parts of type inference that we care about: 
 - constraint construction
 - constraint solving
 
### Constraint construction problems
<!--- data values--->
$\Huge 
\frac{}{G\ \vdash\ \text{true}\ :\ bool\ \dashv\ \\{\\}} 
\quad
\frac{}{G\ \vdash\ \text{false}\ :\ bool\ \dashv\ \\{\\}} 
\quad
\frac{}{G\ \vdash\ n\ :\ int\ \dashv\ \\{\\}}$

<!--- plus --->
$\Huge \frac{G\ \vdash\ e_1\ :\ t_1\ \dashv\ C_1\quad G\ \vdash\ e_2\ :\ t_2\ \dashv\ C_2}{G\ \vdash e_1\ +\ e_2\ :\ int\ \dashv\ \\{t_1:t_2,\ t_1: int\\}\ \cup\ C_1\ \cup\ C_2}$

<!--- and --->
$\Huge \frac{G\ \vdash\ e_1\ :\ t_1\ \dashv\ C_1\quad G\ \vdash\ e_2\ :\ t_2\ \dashv\ C_2}{G\ \vdash e_1\ \\&\\& \ e_2\ :\ bool\ \dashv\ \\{t_1:t_2,\ t_1: bool\\}\ \cup\ C_1\ \cup\ C_2}$

<!-- eq0 -->
$\Huge \frac{G\ \vdash\ e\ :\ t_1\ \dashv\ C}{G\ \vdash\ \text{eq0}\ e\ :\ bool\ \dashv\ \\{t_1:int\\}\ \cup\ C}$

<!-- if --> 
$\Huge \frac{G\ \vdash\ e_1\ :\ t_1\ \dashv\ C_1 \quad G\ \vdash\ e_2\ :\ t_2\ \dashv\ C_2 \quad G\ \vdash\ e_3\ :\ t_3\ \dashv\ C_3}{G\ \vdash\ \text{if}\ e_1\ \text{then}\ e_2\ \text{else}\ e_3\ :\ t_2\ \dashv\ \\{t_1:bool,\ t_2:t_3\\}\ \cup\ C_1\ \cup\ C_2\ \cup\ C_3}$


#### Example Walk Through
We are going to go over one example of constructing a proof step-by-step, using these rules:

`true && eq0 5` 

Much like Operational Semantics, the first step for a type inference proof is writing the expression that we are trying to prove.

$\frac{}{true\ \\&\\&\ eq0\ 5}$

Then, we identify which rule the outermost expression matches. In this case, that is our "and" rule, so we have to fill in the areas that the "and" rule requires. This includes:
- the context (or environment) (G)
- the expression's final type (bool, in this case. Obtained from the rule directly)
- the constraints (Obtained from the rule directly and unioned with constraints from the premises)
- The constraints will be filled in as we learn them - for now, $t_1$, $t_2$, $C_1$, and $C_2$ are placeholders.

$\frac{}{G\ \vdash\ true\ \\&\\&\ eq0\ 5\ :\ bool\ \dashv\ \\{t_1: t_2, t_1:bool\\}\ \cup \ C_1 \ \cup \ C_2}$

Then, we fill in the premises, just like we do with opsem. Again, $C_2$ is a placeholder, as we don't know what it is yet.

$\frac{\cfrac{}{G\ \vdash\ true\ :\ bool\ \dashv\ \\{\\}}\ \ \ \cfrac{}{G\ \vdash\ eq0\ 5\ :\ bool\ \dashv\ C_2}}{G\ \vdash\ true\ \\&\\&\ eq0\ 5\ :\ bool\ \dashv\ \\{t_1: t_2, t_1:bool\\}\ \cup \ C_1 \ \cup \ C_2}$

And since we have learned what $t_1$, $t_2$, and $C_1$ are, we can fill those in:

$\frac{\cfrac{}{G\ \vdash\ true\ :\ bool\ \dashv\ \\{\\}}\ \ \ \cfrac{}{G\ \vdash\ eq0\ 5\ :\ bool\ \dashv\ C_2}}{G\ \vdash\ true\ \\&\\&\ eq0\ 5\ :\ bool\ \dashv\ \\{bool: bool, bool:bool\\}\ \cup \ \\{\\} \ \cup \ C_2}$

Next, we need to continue the proof by proving the eq0 expression, then filling in the $t_1$ and $C$ we find from the axiom.

$\frac{\cfrac{}{G\ \vdash\ true\ :\ bool\ \dashv\ \\{\\}}\ \ \ \cfrac{\cfrac{}{G\ \vdash\ 5\ :\ int\ \dashv\ \\{\\}}}{G\ \vdash\ eq0\ 5\ :\ bool\ \dashv\ \\{t_1\ :\ int\\} \cup C}}{G\ \vdash\ true\ \\&\\&\ eq0\ 5\ :\ bool\ \dashv\ \\{bool: bool, bool:bool\\}\ \cup \ \\{\\} \ \cup \ C_2}$

$\frac{\cfrac{}{G\ \vdash\ true\ :\ bool\ \dashv\ \\{\\}}\ \ \ \cfrac{\cfrac{}{G\ \vdash\ 5\ :\ int\ \dashv\ \\{\\}}}{G\ \vdash\ eq0\ 5\ :\ bool\ \dashv\ \\{int\ :\ int\\} \cup \\{\\}}}{G\ \vdash\ true\ \\&\\&\ eq0\ 5\ :\ bool\ \dashv\ \\{bool: bool, bool:bool\\}\ \cup \ \\{\\} \ \cup \ C_2}$


Now we've found how to fill in $C_2$ for the bottom constraints:

$\frac{\cfrac{}{G\ \vdash\ true\ :\ bool\ \dashv\ \\{\\}}\ \ \ \cfrac{\cfrac{}{G\ \vdash\ 5\ :\ int\ \dashv\ \\{\\}}}{G\ \vdash\ eq0\ 5\ :\ bool\ \dashv\ \\{int\ :\ int\\} \cup \\{\\}}}{G\ \vdash\ true\ \\&\\&\ eq0\ 5\ :\ bool\ \dashv\ \\{bool: bool, bool:bool\\}\ \cup \ \\{\\} \ \cup \ \\{int\ :\ int\\} \cup \\{\\}}$

We have filled in everything now, so we can clean up this proof doing the unions and writing our final constraint list.

$\cfrac{\cfrac{}{G\ \vdash\ true\ :\ bool\ \dashv\ \\{\\}}
                \quad \cfrac{\cfrac{}{G\ \vdash\ 5\ :\ int\ \dashv \\{\\}}}{G\ \vdash\ \text{eq0}\ 5\ : bool\ \dashv \\{int:int\\}}}{G\ \dashv\ true\ \\&\\&\ \text{eq0}\ 5\ :\ bool \dashv\ \\{bool: bool,\  bool:bool,\ int : int\\}}$


All of these line up (no contradictions in our constraint list, more on that later) so we have formed a valid type inference proof!

#### More Examples:

Use the above rules to show the type inference proof for the following:
1. `true + 4`
2. `if true then 1 + 2 else 5`
3. `if true && false then 1 + 2 else eq0 0`

<details>
  <summary>Solutions!</summary>
    
1. INVALID proof:

    proof: $\cfrac{\cfrac{}{G\ \vdash\ true\ :\ bool \dashv \\{\\}}\quad \cfrac{}{G\ \vdash\ 4\ :\ int \dashv\ \\{\\}} }{G\ \vdash true\ + 4\ :\ bool \dashv \\{bool:int,bool:int\\}}$

    - $\\{bool:int,bool:int\\}$ has a contradiction, hence invalid.

2. proof: $\cfrac{\cfrac{}{G\ \  \vdash\ true\ : bool\ \dashv\ \\{\\}}\quad \cfrac{\cfrac{}{G\ \  \vdash\ 1\ : int\ \dashv\ \\{\\}}\quad \cfrac{}{G\ \  \vdash\ 2\ : int\ \dashv\ \\{\\}}}{G\ \  \vdash\ 1\ +\ 2\ :\ int\dashv\ \\{int:int,int:int\\}}\quad\cfrac{}{G\ \  \vdash\ 5\ : int\ \dashv\ \\{\\}}}{G\ \  \vdash\ \text{if}\ true\ \text{then}\ 1\ +\ 2\ \text{else}\ 5\ :\ int\dashv\ \\{bool:bool,int:int,int:int,int:int\\}}$
    
    - No contradictions in constraints, hence valid.

3. INVALID proof: $\tiny \cfrac{\cfrac{\cfrac{}{G\ \  \vdash\ true\ : bool\ \dashv\ \\{\\}}\quad \cfrac{}{G\ \  \vdash\ false\ : bool\ \dashv\ \\{\\}}}{G\ \  \vdash\ true\ \\&\\&\ false\ :\ bool\dashv\ \\{bool:bool,bool:bool\\}}\quad \cfrac{\cfrac{}{G\ \  \vdash\ 1\ : int\ \dashv\ \\{\\}}\quad \cfrac{}{G\ \  \vdash\ 2\ : int\ \dashv\ \\{\\}}}{G\ \  \vdash\ 1\ +\ 2\ :\ int\dashv\ \\{int:int,int:int\\}}\quad\cfrac{\cfrac{}{G\ \  \vdash\ 0\ : int\ \dashv\ \\{\\}}}{G\ \  \vdash\ eq0\ 0\ :\ bool\dashv\ \\{int:int\\}}}{G\ \  \vdash\ \text{if}\ true\ \\&\\&\ false\ \text{then}\ 1\ +\ 2\ \text{else}\ eq0\ 0\ :\ int\dashv\ \\{bool:bool,\ int:bool,\ bool:bool,bool:bool,int:int,int:int,int:int\\}}$

    - Constraints contain $int:bool$ which is a contradiction
</details> 



Now let's add variables and an unknown type:

$\huge \frac{}{G\ \vdash\ read\ ()\ :\ UT(fresh())\ \dashv\ \\{\\}}$ 


(read returns some fresh unknown type - consider $UT(1)$, $UT(2)$, etc. as equivalent to $'a$, $'b$, etc. in the following problems/solutions)

$\huge \frac{}{G\ \vdash\ x\ :\ G(x)}
\quad
\frac{G\ \vdash\ e_1\ : t_1\ \dashv\ C_1
      \quad
      G,x:t_1\ \vdash\ e_2\ : t_2\ \dashv\ C_2}
      {G\ \vdash\ \text{let}\ x\ =\ e_1\ \text{in}\ e_2\ :\ t_2\ \dashv\ C_1\ \cup\ C_2}$


Note: this does not quite follow what OCaml does for bindings.

1. `let x = read () in x + 1`
2. `let x = read () in let y = read () in x && y`
3. `let x = read () in if x then x else eq0 x`
<details>
  <summary>Solutions!</summary>
    
1.  proof: $\cfrac{\cfrac{}{G\ \  \vdash\ read\ ()\ :\ \text{'a}\ \dashv\ \\{\\}}\quad \cfrac{\cfrac{}{G\ ,\ x:\text{'a}\vdash\ x\ :\ \text{'a}\ \dashv\ \\{\\}}\quad \cfrac{}{G\ ,\ x:\text{'a}\vdash\ 1\ : int\ \dashv\ \\{\\}}}{G\ ,\ x:\text{'a}\vdash\ x\ +\ 1\ :\ int\dashv\ \\{\text{'a}:int,\ int:int\\}}}{G\ \  \vdash\ \text{let}\ x\ =\ read ()\ \text{in}\ x\ +\ 1\ :\ int\dashv\ \\{\text{'a}:int,\ int:int\\}}$

    - notice our constraints let us show that $'a$ = int! 
    - no contradictions, valid!

2.  proof $\tiny \cfrac{\cfrac{}{G\ \  \vdash\ read\ ()\ :\ \text{'a}\ \dashv\ \\{\\}}\quad \cfrac{\cfrac{}{G\ ,\ x:\text{'a}\vdash\ read\ ()\ :\ \text{'b}\ \dashv\ \\{\\}}\quad \cfrac{\cfrac{}{G\,\ x:\text{'a} ,\ y:\text{'b}\vdash\ x\ :\ \text{'a}\ \dashv\ \\{\\}}\quad \cfrac{}{G\,\ x:\text{'a} ,\ y:\text{'b}\vdash\ y\ :\ \text{'b}\ \dashv\ \\{\\}}}{G\,\ x:\text{'a} ,\ y:\text{'b}\vdash\ x\ \\&\\&\ y\ :\ bool\dashv\ \\{\text{'a}:bool,\ \text{'b}:bool\\}}}{G\ ,\ x:\text{'a}\vdash\ \text{let}\ y\ =\ read ()\ \text{in}\ x\ \\&\\&\ y\ :\ bool\dashv\ \\{\text{'a}:bool,\ \text{'b}:bool\\}}}{G\ \  \vdash\ \text{let}\ x\ =\ read ()\ \text{in}\ \text{let}\ y\ =\ read ()\ \text{in}\ x\ \\&\\&\ y\ :\ bool\dashv\ \\{\text{'a}:bool,\ \text{'b}:bool\\}}$

    - notice our constraints let us show that 'a = bool, and 'b = bool! 
    - no contradictions, valid!
    
3. INVALID 

    proof: $\tiny \cfrac{\cfrac{}{G\ \  \vdash\ read\ ()\ :\ \text{'a}\ \dashv\ \\{\\}}\quad \cfrac{\cfrac{}{G\ ,\ x:\text{'a}\vdash\ x\ :\ \text{'a}\ \dashv\ \\{\\}}\quad \cfrac{}{G\ ,\ x:\text{'a}\vdash\ x\ :\ \text{'a}\ \dashv\ \\{\\}}\quad\cfrac{\cfrac{}{G\ ,\ x:\text{'a}\vdash\ x\ :\ \text{'a}\ \dashv\ \\{\\}}}{G\ ,\ x:\text{'a}\vdash\ eq0\ x\ :\ bool\dashv\ \\{\text{'a}:int\\}}}{G\ ,\ x:t\vdash\ \text{if}\ x\ \text{then}\ x\ \text{else}\ eq0\ x\ :\ \text{'a}\dashv\ \\{\text{'a}:bool,\text{'a}:bool,\text{'a}:int\\}}}{G\ \  \vdash\ \text{let}\ x\ =\ read ()\ \text{in}\ \text{if}\ x\ \text{then}\ x\ \text{else}\ eq0\ x\ :\ \text{'a}\dashv\ \\{\text{'a}:bool,\text{'a}:bool,\text{'a}:int\\}}$

    - Notice our constraints show a contradiction: $'a:bool \land 'a:int \Rightarrow bool:int$
</details>

### Constraint Solving
Indicate if each of the following constraint sets contain any contradictions.
1. {Int:Int}
2. {Bool:Int}
3. {Int:Int, Bool:Bool, Int:Int}
4. {Bool:Bool, Int:Bool}
5. {'a:Int}
6. {'a:Bool, 'a:'a}
7. {'a:'b, 'a:bool, 'b:bool}
8. {'a:'b, 'a:bool, 'b:'c}
9. {'a:'b, 'b:'c, 'a:'d}
10. {'a:'b, 'a: int, 'b:int', 'c:'b, 'c:bool}
11. {'a:'b, 'b:int, 'a:'c, 'c:'a, 'c:'d, 'd:bool, 'c:int}


#### Unification steps

Go through the contraints, and take a contraint pair $c$ and do the following
- if $c$ is $x:x$ (like int:int, or 'a:'a), remove from constraints
- if $c$ is $x:type$ or $type:x$ (like 'a:int or int:'a), remove from constraints and edit all the other constraints in the set by replacing x with type
- if $c$ is $type_1:type_2$ (like int:bool), then stop and say contradiction, inference fails

Do the above until the set is empty or error occurs

<details>
  <summary>Solutions!</summary>

1. No contradictions
2. Yes, Bool $\ne$ Int
3. No contradictions
4. Yes, Bool $\ne$ Int
5. No contradictions
6. No contradictions
7. No contradictions
8. No contradictions
9. No contradictions
10. Yes, $'a = int = 'b = 'c = bool \Rightarrow Bool = Int$ 
11. Yes

</details>


## Subtyping

#### Definition:

If `S` is a subtype of `T`, written S <: T,then an `S` can be used anywhere a `T` is expected.

`int` <: `int`
`int` is not a subtype of `bool`

In the context of subtyping records, we can take a more liberal view of record types, seeing a record as "the set of all records with *at least* a field [name] of type [type]". This means that the "smaller" subtype is actually the one with more fields in the record.

`{x:int, y:int, z:bool}` <: `{x:int, y:int}`
`{y:int}` <: `{}`
`{x:int}` is not a subtype of `{y:int}`

Also, the types within the records can contain subtypes. A record `A` is a subtype of record `B` if all of the variables within `A` are subtypes of equivalently named variables in `B`.

`{x:{a:int, b:int}, y:{m:int}}` <: `{x:{a:int}, y}`

#### Properties of subtyping:

- Reflexivity: for any type `A`, `A` <: `A`
- Transitivity: if `A` <: `B` <: `C`, then `A` <: `C`
- Permutation: components of a record are not ordered
    - `{x:a, y:b}` <: `{x:b, y:a}`
    - `{x:b, y:a}` <: `{x:a, y:b}`

For more information about subtyping, take a look at the subtyping information from this [past 330 type checking project](https://github.com/cmsc330spring24/cmsc330spring24/blob/main/projects/project5.md).


## Type Checking

$\Huge \frac{}{G\ \vdash\ \text{x}\ :\ G(\text{x})} \quad \frac{}{G\ \vdash\ \text{true}\ :\ \text{bool}} \quad \frac{}{G\ \vdash\ \text{false}\ :\ \text{bool}} \quad \frac{}{G\ \vdash\ \text{n}\ :\ \text{int}} \quad$

$\Huge \frac{G\ \vdash\ e1\ :\ \text{t1} \quad G,\ x\ :\ \text{t1}\ \vdash\ e2\ :\ \text{t2}}{G\ \vdash\ \text{let}\ x\ =\ e1\ \text{in}\ e2\ :\ t2} \quad
\frac{G\ \vdash\ e1\ :\ \text{bool} \quad G\ \vdash\ e2\ :\ \text{bool}}{G\ \vdash\ e1\ \text{and}\ e2\ :\ \text{bool}} \quad$

$\Huge \frac{G\ \vdash\ e\ :\ \text{int}}{G\ \vdash\ \text{eq0}\ e\ :\ \text{bool}} \quad
\frac{G\ \vdash\ e1\ :\ \text{bool} \quad G\ \vdash\ e2\ :\ \text{t}\quad G\ \vdash\ e3\ :\ \text{t}}{G\ \vdash\ \text{if}\ e1\ \text{then}\ e2\ \text{else}\ e3\ :\ \text{t}} \quad$

Using the rules given above, show that the following statements are **well typed**:
1. `eq0 if true then 0 else 1`
2. `let x = 5 in eq0 x and false`

<details>
  <summary>Solutions!</summary>

1. ![image](https://hackmd.io/_uploads/BJDX-6B61g.png)

2. ![image](https://hackmd.io/_uploads/SyGEZTSa1l.png)

</details>

## Additional Readings & Resources

- [Professor Mamat's Type Checking Slides](https://bakalian.cs.umd.edu/assets/slides/19-Typechecking.pdf)
- [Cliff's Type Checking and Type Inference Notes](https://bakalian.cs.umd.edu/assets/notes/typing.pdf)
- [Type Checker Problem Generator](https://bakalian.cs.umd.edu/330/practice/typechecker)
- [Subtyping Reference from TAPL](https://www.cs.umd.edu/class/spring2024/cmsc330-030X-040X/assets/slides/TAPL_Ch._15.pdf)
