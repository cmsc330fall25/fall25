# Discussion 9 - Friday, October 31st

## Reminders

1. Happy Halloween!!
2. Project 4 released, due **Tuesday, November 11th @ 11:59pm**.
3. Quiz 3 is a week from today **(Friday, November 7th) in discussion!** Remember to go to your own section & that today is last day to schedule with ADS if needed. See [@590](https://piazza.com/class/mbjy6l6wnge4f2/post/590)

![alt text](image.png)

## Operational Semantics

#### Problem 1:

Using the rules below, show: $\large 1 + (2 + 3) \implies 6$

$\Huge \frac{}{n \implies n} \quad \frac{e_1 \implies n_1 \quad e_2 \implies n_2 \quad n_3\ \text{is}\ n_1+n_2}{e_1+e_2 \implies n_3}$

#### Bonus problem (boo!)
Using the rules below, show: $WITCH\ and\ GHOST\ and\ BAT! \implies 6$

$\Huge \frac{}{WITCH \implies 1} \quad \frac{}{BAT \implies 2} \quad \frac{}{GHOST \implies 3} \quad \frac{e_1 \implies v_1 \quad e_2 \implies v_2 
\quad e_3 \implies v_3 \quad v_4\ \text{is}\ v_1+v_2+v_3}{e_1\ and\ e_2\ and\ e_3! \implies v_4}$


#### Problem 2:

Using the rules given below, show: $\large A;\textbf{let}\ y = 1\ \textbf{in}\ \textbf{let}\ x = 2\ \textbf{in}\ x \implies 2$

$\Huge \frac{}{A;\ n \implies n} \quad \frac{A(x)\ =\ v}{A;\ x \implies v} \quad \frac{A;\ e_1 \implies v_1 \quad A,\ x\ :\ v_1;\ e_2 \implies v_2}{A;\ \textbf{let}\ x = e_1\ \textbf{in}\ e_2 \implies v_2} \quad \frac{A;\ e_1 \implies n_1 \quad A;\ e_2 \implies n_2 \quad n_3\ \text{is}\ n_1+n_2}{A;\ e_1+e_2 \implies n_3}$

#### Problem 3:

Using the rules given below, show: $\large A;\textbf{let}\ x = 3\ \textbf{in}\ \textbf{let}\ x = x + 6 \ \textbf{in}\ x \implies 9$

$\Huge \frac{}{A;\ n \implies n} \quad \frac{A(x)\ =\ v}{A;\ x \implies v} \quad \frac{A;\ e_1 \implies v_1 \quad A,\ x\ :\ v_1;\ e_2 \implies v_2}{A;\ \textbf{let}\ x = e_1\ \textbf{in}\ e_2 \implies v_2} \quad \frac{A;\ e_1 \implies n_1 \quad A;\ e_2 \implies n_2 \quad n_3\ \text{is}\ n_1+n_2}{A;\ e_1+e_2 \implies n_3}$

#### Problem 4:

**Note:** This problem takes a long time, I recommend completing in your own time!

Using the rules given below, show: $\large A;\textbf{let}\ x = 2\ \textbf{in}\ \textbf{let}\ y = 3\ \textbf{in}\ \textbf{let}\ x = x + 2 \ \textbf{in}\ x + y \implies 7$

$\Huge \frac{}{A;\ n \implies n} \quad \frac{A(x)\ =\ v}{A;\ x \implies v} \quad \frac{A;\ e_1 \implies v_1 \quad A,\ x\ :\ v_1;\ e_2 \implies v_2}{A;\ \textbf{let}\ x = e_1\ \textbf{in}\ e_2 \implies v_2} \quad \frac{A;\ e_1 \implies n_1 \quad A;\ e_2 \implies n_2 \quad n_3\ \text{is}\ n_1+n_2}{A;\ e_1+e_2 \implies n_3}$

<details>
  <summary>Solutions!</summary>

1.
    
![image](https://hackmd.io/_uploads/rkGQ1UEayx.png)


2.

![image](https://hackmd.io/_uploads/SJ3b18NTyx.png)

3.
    
![image](https://hackmd.io/_uploads/HJx-JLE61x.png)

4.
    
![image](https://hackmd.io/_uploads/BJYl1UVake.png)

</details>

### Opsem Translations

Another one like this is available on [Exam 2 Spring 2024](https://bakalian.cs.umd.edu/assets/past_assignments/spring24exam2solns.pdf), the one below is taken from [Exam 2 Fall 2024](https://bakalian.cs.umd.edu/assets/past_assignments/fall24exam2solns.pdf).

You are given two sets of rules for two different langauges.

<!--- values --->
These rules are valid for both languages:

$\cfrac{}{\text{true} \rightarrow \text{true}}\quad \cfrac{}{\text{false} \rightarrow \text{false}}\quad \cfrac{A(x) = v}{A; x \rightarrow v}$

These two rules are valid *only for language **1***:

$\cfrac{A;e_1 \rightarrow v_1 \qquad A;e_2 \rightarrow v_2 \qquad v_3 = \text{if }\ v_1\ \text{ then not }\ v_2\ \text{ else }\ v_2}{A; e_1\ e_2 \ \text{op1} \rightarrow v_3}$

$\cfrac{A;e_1 \rightarrow v_1 \qquad A,x:v_1; e_2 \rightarrow v_2}{A;\text{let }x = e_1\ \text{in}\ e_2 \rightarrow v_2}$

These two rules are valid *only for language **2***:

$\cfrac{A;e_1 \rightarrow v_1 \qquad A;e_2 \rightarrow v_2 \qquad v_3 = \text{if }\ v_1\ \text{ then not }\ v_2\ \text{ else }\ v_2}{A; \text{op2} \ e_2\ e_1 \rightarrow v_3}$

$\cfrac{A;e_2 \rightarrow v_1 \qquad A,x:v_1; e_1 \rightarrow v_2}{A;(\text{fun } x \rightarrow e_1)\ e_2 \rightarrow v_2}$

Convert the following Language 1 sentence to its language 2 counterpart

    A; let x = true in (true x op1)

______

How do we approach this sort of problem? 

First, figure out what the sentence *means* - what is it actually doing?

In this case, Language 1 says that $A;\ let\ x\ =\ true\ in\ true\ x\ \text{op1}$ tells us to use this rule first, with $x\ =\ x$, $e1\ = true$, and $e2\ =\ true\ x\ \text{op1}$:

$\cfrac{A;e_1 \rightarrow v_1 \qquad A,x:v_1; e_2 \rightarrow v_2}{A;\text{let }x = e_1\ \text{in}\ e_2 \rightarrow v_2}$

Recall that the bottom half of this is just a representation of what the sentence looks like in the language. The top half is what the language *means*.

Which rule in lanugage 2 has the same *meaning* as that one? This one looks very similar...

$\cfrac{A;e_2 \rightarrow v_1 \qquad A,x:v_1; e_1 \rightarrow v_2}{A;(\text{fun } x \rightarrow e_1)\ e_2 \rightarrow v_2}$

<details>
  <summary>So, can we just plug in e1 for e1 and e2 for e2?</summary>

NO! The meaning is different! 
    
The first rule evaluates **e1** to a value, then updates the environment with that, and evaluates **e2**.
    
The second rule evaluates **e2** to a value, then updates the environment with that, and evaluetes **e1**.

</details>

\
Given that, we can convert like this:

$A;\ let\ x\ =\ true\ in\ true\ x\ \text{op1}$

to

$A;\ (\text{fun } x \rightarrow true\ x\ \text{op1})\ true \rightarrow v_2$

Okay, now we're closer, but $true\ x\ \text{op1}$ is still a Language 1 construct, so we need convert that part as well.

What does $true\ x\ \text{op1}$ mean in Language 1?

$\cfrac{A;e_1 \rightarrow v_1 \qquad A;e_2 \rightarrow v_2 \qquad v_3 = \text{if }\ v_1\ \text{ then not }\ v_2\ \text{ else }\ v_2}{A; e_1\ e_2 \ \text{op1} \rightarrow v_3}$

With $e1\ = true$, $e2 = x$. 
What's the matching Language 2 rule?

$\cfrac{A;e_1 \rightarrow v_1 \qquad A;e_2 \rightarrow v_2 \qquad v_3 = \text{if }\ v_1\ \text{ then not }\ v_2\ \text{ else }\ v_2}{A; \text{op2} \ e_2\ e_1 \rightarrow v_3}$

<details>
  <summary>Here, can we just plug in e1 for e1 and e2 for e2?</summary>

Yes! Here the meaning is the same, unlike before.
    
The first rule evaluates **e1** to a value v1, then evaluates **e2** to a value v2, then gets the value v3 from the metalanguage "if v1 then not v2 else v2".
    
The second rule evaluates **e1** to a value v1, then evaluates **e2** to a value v2, then gets the value v3 from the metalanguage "if v1 then not v2 else v2".
    
They are the same.

</details>


So Language 1's  $true\ x\ \text{op1}$ becomes Language 2's $\text{op2}\ x\ true$

Let's put it all together!
    
<details>
  <summary>Solution!</summary>

    A; (fun x -> op2 x true) true

</details>

### Halloween Translation Exercise!

Language 1: 

$\cfrac{}{\text{TRICK} \rightarrow \text{false}}\quad \cfrac{}{\text{TREAT} \rightarrow \text{true}}\quad \cfrac{A; e_1 \rightarrow v_1\ \ \ \ A, x:v_1;\ e_2 \rightarrow v_2}{A; x\ is\ e_1 ... e_2 \rightarrow v_2}$

$\quad \cfrac{A; e_1 \rightarrow v_1\ \ \ \ A;\ e_2 \rightarrow v_2\ \ \ v_3\ is\ v_1 || v_2}{A;e_1\ or\ e_2! \rightarrow v_3}$

Language 2: 


$\cfrac{}{\text{WEREWOLF} \rightarrow \text{true}}\quad \cfrac{}{\text{VAMPIRE} \rightarrow \text{false}}\quad \cfrac{A; e_1 \rightarrow v_1\ \ \ \ A, x:v_1;\ e_2 \rightarrow v_2}{A; x\ is\ e_1 ... e_2 \rightarrow v_2}$

$\quad \cfrac{A; e_1 \rightarrow v_1\ \ \ \ A;\ e_2 \rightarrow v_2\ \ \ v_3\ is\ v_1 || v_2}{A;e_1\ and\ e_2! \rightarrow v_3}$

Translate the following language 1 sentence to language 2: 
  
- x is TREAT... TRICK or TREAT!

<details>
  <summary>Solution</summary>

    x is WEREWOLF...VAMPIRE and WEREWOLF!

</details>

## Additional Readings & Resources

- [Professor Mamat's Operational Semantics Slides](https://bakalian.cs.umd.edu/assets/slides/17-semantics.pdf)
- [Fall 2022 - Discussion 10 (Operational Semantics)](https://github.com/umd-cmsc330/fall2022/tree/main/discussions/discussion10#operational-semantics)
- [OpSem Problem Generator](https://bakalian.cs.umd.edu/cmsc330/practice/opsem/330)
