# Discussion 6 - Friday, October, 10th

## Reminders

- Project 3 due **Sunday October 26th @ 11:59 PM**
- Quiz 2 **Friday October 17th**
- Fall Break October 13th-14th No Class
   
## NFAs and DFAs Review
Know the following:
- Properties of and differences between NFAs and DFAs

### NFA Acceptance
![image](https://hackmd.io/_uploads/BkVkM8Gikx.png)

Does the following accept:
```
a) ""
b) bcb
c) bbab
d) b
e) a
```
<details>
  <summary>Solutions!</summary>
a) yes: 0-&#x03B5 -> 3<br>
b) yes: 0 -b-> 3 -c-> 3 -b-> 2 -&#x03B5-> 1<br> 
c) yes: 0 -b-> 3 -c-> 3 -b-> 2 -a-> 1 -b-> 0 -&#x03B5-> 3<br>  
d) yes: 0 -b-> 3<br>
e) no: 0 -a-> Trash state
</details>

### Regex to NFA
Convert the following regular expressions to an equivalent NFA
```
a) [a-c]+d{1,2}
b) ab?a|bc*
c) a*(c*b)?
d) (ab*|cd*)*
```
### NFA to DFA Introduction

Converting a NFA to a DFA is as simple as converting a non-deterministic system to a deterministic one. First the terms:
- Determinism: The future is set in stone
- Non-determinism: The future is not set in stone

In other words, how do we go from a unknown future to a known future? Simple: reframe what parts of the future we care about.

For example: If I flip a coin, the future is unknown: maybe it's heads, maybe it's tails. Future here is not set in stone. Our goal however is to be 100% certain about the future. So let's consider what we know will 100% happen: I will get a result. 

So we can reframe the the model: If I flip a coin, I will get either heads or tails. We now went from 2 possible futures to one absolute future. That's what we want to do when we convert NFA to DFA. 

Let's take the following example:

![image](https://hackmd.io/_uploads/BkFd7WIpgg.png)
Here we have 2 possible outcomes if we see an 'a' and are in state $S_0$: $S_1$ and $S_2$. So instead of saying we have 2 possible outcomes, we can reframe:

![image](https://hackmd.io/_uploads/Bkx0mWIpgl.png)
Now we have 1 absolute outcome if we see an 'a' and are in state $S_0$.
In this case, we want to say "Where are all the possible places I can end up after I see symbol $x$ in state $s$"? Let's call this idea `move`. 
```
move "a" s0 = [s1;s2]
```

However, there is a special case we are missing/something we are missing. 
![image](https://hackmd.io/_uploads/SkJDSZ8Tlx.png)
If I am in $S_3$ and see an 'a', we would say we would end up in state $S_4$. However, it would also be accurate to say that we could also end up in state $S_5$. If this does not make sense let's rephrase the question and change some values around:
![image](https://hackmd.io/_uploads/HkVILbIplg.png)
The new question becomes: "If you are in state $S_3$ and have $1 in your pocket, where are all the places you can afford to go?". In this case, you could afford to go to $S_4$ and $S_5$. In this case, a `move` is not sufficient. 
```
move "a" s3 = [s4]
```
We know for a fact we could end up in $S_4$. But now we need to ask ourselves, if we are in $S_4$, is there anywhere else we could be (for free)? In this case, we could go to $S_4$ or $S_5$. (Recall that there is an implicit epsilon transition from any state to itself.). Let's call this idea e-closure:
```
eclosure [s4] = [s4;s5]
```
These two ideas will be used to reduce NFAs to DFAs. Let's see this in action. We will convert the following NFA to a DFA:

![image](https://hackmd.io/_uploads/r1Gq_W8pxl.png)

Let's consider that if we are going to be combining states: then we have a maximum number of combined states that could exist. Namely the powerset of the states:
```
[]
[S0] [S1] [S2]
[S0;S1] [S0;S2] [S1;S2]
[S0;S1;S2]
```
Now technically there is the implicit trash state $T$ to consider. So the powerset really is
```
[]
[T] [S0] [S1] [S2]
[T;S0] [T;S1] [T;S2] [S0;S1] [S0;S2] [S1;S2]
[T;S0;S1] [T;S0;S2] [T;S1;S2] [S0;S1;S2]
[T;S0;S1;S2]
```
Now for simplicity we will leave out the Trash state since it is implicit. 

Since these are all possible states that could exist, we could fill out the following Table to keep track of which states point to which other states:

| State      | eclosure | move a | move b |
| ---------- | -------- | ------ | ------ |
| []         |          |        |        |
| [S0]       |          |        |        |
| [S1]       |          |        |        |
| [S2]       |          |        |        |
| [S0;S1]    |          |        |        |
| [S0;S2]    |          |        |        |
| [S1;S2]    |          |        |        |
| [S0;S1;S2] |          |        |        |

Let's consider our goal: we want to make a DFA. In this case, we want to be certain about where we are, and where we go on each symbol. The best place to start is the begining. So let's ask ourselves: "Where could I start the traversal?"

In this case, we just need to call `eclosure` on the starting state.
```
eclosure s0 = [s0;s1]
```

![image](https://hackmd.io/_uploads/BJ_KY-Upge.png)
This is our start state of the DFA. We then need to consider what the next steps are: "a" and "b". Let's start with "a". So we should ask ourselves: "If I am in $S_0$ or $S_1$ and I see an 'a', where do I end up?" In this case, if I am in $S_0$ and see an "a" I end up in the trash state $T$. If I am in $S_1$ and see an "a" I could end up in the state $S_0$ or $S_2$. Logically we can conclude the following:
```
S0 => T           // If I am in S0 then I end up in T
S1 => S0 v S2     // If I am in S1, then I end up in S0 or S2
S0 v S1           // I am either in S0 or S1
-------
∴ T v S0 v S2     // I end up in either T or S0 or S2
```
Then, if I could get to $T$, $S_0$, or $S_2$, we need to consider where else we could be for free? In this case, if we are in $S_0$, we could end up in $S_1$ for free. 
Notice this is the same as asking:
```
eclosure ((move "a" s0) @ (move "a" s1))
```
We can now take this result and add it to our DFA:

![image](https://hackmd.io/_uploads/HJVnfGLpgx.png)


(Again, we are leaving out $T$ because it is implicit)

Now we should consider the other next step is: "b". So we can now ask the question: "If I am in $S_0$ or $S_1$ and I see an 'b', where do I end up"? In this case, if I am $S_0$, I end up in $S_2$. If I am in $S_1$, I end up in the trash state $T$. So calculating
```
eclosure ((move "b" s0) @ (move "b" s1))
```
gives us the following:

![image](https://hackmd.io/_uploads/H16AMGIagg.png)



Our DFA now has a starting state that then has a deterministic futures on each action (symbol). But wait, now we have the new states [$S_1;S_2;S_0$] and [$S_0;S_1$]. We need to make sure we know what their futures are after each action (symbol). So now we just do what we did above:
```
eclosure ((move "a" S1) @ (move "a" S2) @ (move "a" s0))
```

![image](https://hackmd.io/_uploads/S1_bXfLpxl.png)


```
eclosure ((move "b" S1) @ (move "b" S2) @ (move "b" s0))
```

![image](https://hackmd.io/_uploads/Bkiz7zUTgg.png)


Now [$S_1;S_2;S_0$] also has deterministic features on each action (symbol). So now we just have to make [$S_2$] deterministic.
```
eclosure (move "a" S2)
```
(Nothing changes because trash state is implicit)
```
eclosure (move "b" S2)
```
![image](https://hackmd.io/_uploads/B1-8mGLaxl.png)


Congrats, we now have a fully deterministic FSM that is equivalent to the initial NFA.

Our table would end up looking like the following:
| State      |  eclosure  |   move a   | move b |
| ---------- | ---------- | ---------- | ------ |
| []         |            |            |        |
| [S0]       |  [S0;S1]   |            |        |
| [S1]       |            |            |        |
| [S2]       |    [S2]    |     []     |  [S2]  |
| [S0;S1]    |  [S0;S2]   | [S1;S2]    |  [S2]  |
| [S0;S2]    | [S1;S2;S0] |            |        |
| [S1;S2]    |            |            |        |
| [S0;S1;S2] | [S1;S2;S0] | [S1;S2;S0] |  [S2]  |

### Resources and Extra Practice
- [NFA to DFA Practice Problems](https://bakalian.cs.umd.edu/330/practice/nfa2dfa)
- [Fall 2024 Discussion 5](https://github.com/cmsc330fall24/fall2024/blob/main/discussions/d5_nfa_dfa/README.md)
- [Slides - Reducing NFA to DFA](https://bakalian.cs.umd.edu/assets/slides/14-automata3.pdf)
- [NFA to DFA Conversion Examples](https://github.com/anwarmamat/cmsc330spring2024/blob/main/nfa2dfa/nfa2dfa.md)
- [Cliff's FSM notes](https://bakalian.cs.umd.edu/assets/notes/fa.pdf)
