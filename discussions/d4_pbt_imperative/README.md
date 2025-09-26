# Discussion 4 - Friday, September 26th

## Reminders

1. Project 2 released, due **Thursday October 2nd @ 11:59 PM**
2. Exam 1 will be Tuesday October 7th

## Topic List

- Records
- Imperative OCaml
- Property-Based Testing

## Records

Consider the following custom record type, which is similar to the return tuple of `list_sum_product` (from last week):

```ocaml
type results = {
  sum_even: int;
  product_odd: int;
  num_elements: int;
}
```

#### `record_sum_product lst`

- **Type**: `int list -> results`
- **Description**: Similar to the `list_sum_product` function above, but returns a `results` record with the following fields:
  - `sum_even` is the **sum** of the **even indexed** elements
  - `product_odd` is the **product** of the **odd indexed** elements.
  - `num_elements` is the number of elements in `lst`
- **Note:** The list is 0 indexed, and 0 is an even index.
- **Examples**:

```ocaml
record_sum_product [] = {sum_even = 0; product_odd = 1; num_elements = 0}
record_sum_product [1;2;3;4] = {sum_even = 4; product_odd = 8; num_elements = 4}
record_sum_product [1;5;4;1] = {sum_even = 5; product_odd = 5; num_elements = 4}
record_sum_product [1;-2;-3;4] = {sum_even = -2; product_odd = -8; num_elements = 4}
```

<details>
  <summary>Solution!</summary>
  
```ocaml
let record_sum_product lst = 
  fold (fun {sum_even; product_odd; num_elements} num -> 
    if num_elements mod 2 = 0 
      then {
        sum_even = sum_even + num; 
        product_odd; 
        num_elements = num_elements + 1 } 
      else {
        sum_even; 
        product_odd = product_odd * num; 
        num_elements = num_elements + 1 })
  {sum_even = 0; product_odd = 1; num_elements = 0} lst;;
```
</details>


#### Another exercise! Consider the following custom record types:

```ocaml
type weather_data = {
    temperature: float;
    precipitation: float;
    wind_speed: int;
}

type cp_weather_report = {
    days: weather_data list;
    num_of_days: float;
}
```

#### `average_temperature report`

- **Type:** `cp_weather_report -> float`
- **Description:** This function takes a `cp_weather_report` record, containing a list of `weather_data` records from College Park and returns the average temperature of College Park.
- **Note:** If the `num_of_days` within `cp_weather_report` is 0 then return 0.0
- **Examples:**
 
```ocaml
let ex1 = {
  days = [
    { temperature = 70.0; precipitation = 0.2; wind_speed = 10 };
    { temperature = 68.0; precipitation = 0.1; wind_speed = 12 };
    { temperature = 72.0; precipitation = 0.0; wind_speed = 8 };
    { temperature = 75.0; precipitation = 0.3; wind_speed = 15 }
  ];
  num_of_days = 4.0
}
average_temperature ex1 = 71.25

let ex2 = {
    days = [];
    num_of_days = 0.0
}
average_temperature ex2 = 0.0

let ex3 = {
    days = [
    { temperature = 30.0; precipitation = 0.0; wind_speed = 3 };
    { temperature = 35.0; precipitation = 0.0; wind_speed = 4 }
  ];
  num_of_days = 2.0
}
average_temperature ex3 = 32.5
```

<details>
  <summary>Solution!</summary>
  
```ocaml

let average_temperature reports =
  if reports.num_of_days = 0.0 
    then 0.0
  else
    let total_temp =
      List.fold_left (fun sum day -> sum +. day.temperature) 0.0 reports.days
    in total_temp /. reports.num_of_days
```
</details>

## Imperative OCaml

```ocaml
# let z = 3;;
  val z : int = 3
# let x = ref z;;
  val x : int ref = {contents = 3}
# let y = x;;
  val y : int ref = {contents = 3}
```
Here, `z` is bound to 3. It is immutable.  `x` and `y` are bound to a reference. The `contents` of the reference is mutable. 
```ocaml
x := 4;;
```
will update the `contents` to 4. `x` and `y` now point to the value 4. 
```ocaml
!y;;
  - : int = 4
```
Here, variables y and x are aliases. In `let y = x`, variable `x` evaluates to a location, and `y` is bound to the same location. So, changing the contents of that location will cause both `!x` and `!y` to change.

## Exercises

### Imperative OCaml Counter

**Recall:** The `unit` type means that no input parameters are required for the function.

Implement a counter called `counter`, which keeps track of a value starting at 0. Then, write a function called `next: unit -> int`, which returns a new integer every time it is called.

#### Example
```ocaml
(* First call of next () *)
# next ();;
 : int = 1

(* First call of next () *)
# next ();;
 : int = 2
```

#### Solution:
<details>
  <summary><b>Click here!</b></summary>
  
```ocaml
# let counter = ref 0 ;;
val counter : int ref = { contents=0 }

# let next = 
    fun () -> counter := !counter + 1; !counter ;;
val next : unit -> int = <fun>
```
</details>
<br>
</br
    
This version of counter does NOT work: can you guess why?
<details>
  <summary><b>Click here!</b></summary>
  
```ocaml
# let next () = 
    let counter = ref 0 in
    counter := !counter + 1; !counter;;
val next : unit -> int = <fun>
```
</details>
    <details>
  <summary><b>Why?</b></summary>
    You are defining a function next that takes in 1 parameter, then what it does is: step 1) set a reference to 0, then step 2) increment that reference.
         
So, every time you run this function, the reference gets set to 0!
</details>
    
This version of counter DOES work: can you guess why? (HARD QUESTION)
<details>
  <summary><b>Click here!</b></summary>
  
```ocaml
# let next = 
    let counter = ref 0 in
    fun () -> counter := !counter + 1; !counter;;
val next : unit -> int = <fun>
```
</details>
<details>
  <summary><b>Why?</b></summary>
    You are defining a value `next` that is not defined as being a function yet. Then you set a reference to 0. Finally, you write out a function that takes in 1 parameter, and what it does is just "step 2" from the previous version: increment that reference.
    
When you run next (), OCaml doesn't go back and re-run all that code. It just knows that `next` is a function that just increments the value in that memory location. The code which sets the counter originally only gets evaluated once!
</details>

### Function argument evaluation order 

What happens when we run this code?
```ocaml
let x = ref 0;;
let f _ r = r;;
f (x:=2) (!x)
```
#### Solution:
<details>
  <summary><b>Click here!</b></summary>
Ocaml's order of argument evaluation is not defined. On some systems it's left to right on others it's right to left.
    
On my system, <b>f</b> evaluates to <b>0</b>, but on your system it may evaluate to <b>2</b>!   
</details>

## Property-Based Testing

Why do we even care about property-based testing and what do we need to know about them?

Suppose you write a function `square` to calculate the square of a number.

```ocaml
let square x = (* square an integer*)
```

Now you want to test whether your implementation is correct. One way to go about this is creating unit tests

```ocaml
square 3 = 9
square 4 = 16
square (-1) = 1
```

Writing unit tests can get tedious, though. This is where property-based testing comes in; the purpose of PBTs is to test whether some property of a function behaves as expected, *independent of input*. Now, where can PBTs go wrong?

Consider the following attempt at a property-based test for a `length` function:

```ocaml
let length lst = (* calculate length of a list *)

let delete x lst = (* return a list without x *)

length(delete x lst) < length lst 
```

This property says that if you delete an item from a list, the size of the list should be smaller than when it started. This sounds right, but *is false if the item to be deleted was not actually in the list*. In this case, the list size stays the same so this is not a valid property.

**So we can ask: given a property $p$, is $p$ actually valid?**


Now suppose we have a valid property. For example, we know that reversing a list twice should return the original list, for any list. If we translated this into code as:

```ocaml
let rev lst = (*reverse a list*)
rev (lst) = lst
```
then we did not accurately translate the property, since this code doesn't actually do what we want!

**So we can ask: given a property $p$ and a function $f$ encoding $p$, does $f$ actually represent $p$?**

Finally, while the property could be valid, and while the property we write could be a correct encoding, it is possible the property does not catch bugs in our code. Consider the following:

```ocaml
rev (rev lst) = lst
```
This is clearly a valid property from our discussion earlier, and a valid encoding of the property. However, imagine we wrote `rev` like

```ocaml
let rev lst = lst
```
Then this property will not actually detect the bug in my code (namely the fact that `rev` is completely incorrect).\
This shows the importance of combining multiple properties + unit tests for ensuring program correctness.

**So we can ask, given a valid property $p$, and a buggy implementation of this function $f$, will the property $p$ catch any bugs in $f$?**

## Exercises - Property-Based Testing

1. Consider the following linked list type:
    ```ocaml
    type 'a linked = Node of 'a * 'a linked | Nil
    ```
    and the following function that is supposed to insert the element `x` after each instance of `targ`:
    ```ocaml
    let rec insert_x lst targ x = match lst with
       | Nil -> Nil
       | Node(ele, rest) -> if ele = targ then Node(x, insert_x rest targ x) else insert_x rest targ x
    ```
    Sample call if the function worked correctly:
    ```ocaml
    let lst = Node(1, Node(2, Node(3, Nil)));;
    insert_xc lst 2 7 = Node (1, Node (2, Node (7, Node (3, Nil))));;
    ```
    Next, consider the property:
    > The result of running `insert_x` on any `linked` type will always have a length greater or equal to that of the original list.
    
    and its implementation (assuming the `length` function is valid for `linked` types, and `lst`, `input1`, and `input2` are valid random inputs):
    ```ocaml
    let test_prop lst input1 input2 = length (insert_x lst input1 input2) >= length lst
    ```
    - Is the property valid?
        #### Solution:
        <details>
        <summary><b>Click here!</b></summary>
        Yes, all elements of the original list are all preserved.
        </details>
    - Is `test_prop` a valid encoding of the property?
        #### Solution:
        <details>
        <summary><b>Click here!</b></summary>
        Yes, accurately compares the length of list with the function applied and without.
        </details>
    - If we test this property on the provided implementation of `insert_x`, will it always assert true?
        #### Solution:
        <details>
        <summary><b>Click here!</b></summary>
        No, the second match case has an error. It should be:
            
        ```ocaml
        if ele = targ then Node(ele, Node(x, insert_x rest targ x) else Node(ele, insert_x rest targ x)
        ```
            
        The current implementation fails to re-add the current element, resulting in a list of just `x`s that has length of the amount of `targ` (less than the original list):
            
        ```ocaml
        let ll = Node(3, 
                  Node(4, 
                   Node(5,
                    Node(3, 
                     Node(7, 
                      Node(3, 
                       Node(10, 
                        Nil
                      ))))))) in
        insert_x ll 3 11 (* evals to  Node(11, Node (11, Node (11, Nil))) *)
        ```
            
        </details>
    
2. Consider the following Tree datatype:
    ```ocaml
    type bintree = Node of bintree * int * bintree | Leaf of int
    ```
   Now consider the 2 following incorrectly written functions, `mirror` and `contains`:
   ```ocaml
    (* mirror takes a bintree and should return a mirrored version of the binary tree*)
    (* this code may or may not have bugs! *)
    let rec mirror tree = match tree with
    | Leaf(x) -> Leaf(x)
    | Node(l, v, r) -> Node((mirror l), v, (mirror r))
   ```
   ```ocaml
    (* contains takes a bintree and int, and should return true if the int is in the bintree, and false otherwise*)
    (* this code may or may not have bugs! *)
    let rec contains tree value = match tree with
    | Leaf(x) -> false
    | Node(l, v, r) -> (contains l value) || (v = value) || (contains r value)
   ```
    Given the below property and implementation, answer the questions:
    **Property:** Mirroring a tree should not change the result of `contains`
    **Implementation:** 
    ```ocaml
    let prop tree item = (contains (mirror tree) item) = (contains tree item)
    ```
    
- Is this a valid encoding of the property?
    #### Solution:
    <details>
      <summary><b>Click here!</b></summary>
          Yes
        </details>
    
- If we test this property on a ***correct*** implementation of `contains` but with ***our*** implementation of `mirror`, will it ever return false?
    #### Solution:
    <details>
      <summary><b>Click here!</b></summary>
          No, even though our mirror implementation has a bug, that bug does not change which values are present in the tree, and so will not violate this property.
        </details>
    
- If we test this property on ***our*** implementation of `contains` and a ***correct*** implementation of `mirror`, will it ever return false?
    #### Solution:
    <details>
      <summary><b>Click here!</b></summary>
          No, even though our contains implementation has a bug, it would still return true on all instances of this property
        (In this case, that means that this property would not help us identify the bug)
        </details>

    
- What was wrong with `contains`?
    <details>
        <summary><b>Click here!</b></summary>
          The contains function doesn't ever check leaves, if you call contains Leaf(5) 5, it will return false
        </details>
    
- What was wrong with `mirror`?
    <details>
        <summary><b>Click here!</b></summary>
          Didn't actually mirror the children - left subtree stays on the left and right subtree stays on the right.
        </details>



## Resources & Additional Readings

- [Fall 2023 Python HOF + Regex discussion](https://github.com/cmsc330fall23/cmsc330fall23/tree/main/discussions/d2_hof_regex)
- [Anwar's Property Based Testing Notes](https://github.com/anwarmamat/cmsc330spring2024/blob/main/pbt.md)
- [Anwar's Imperative OCaml Notes](https://github.com/anwarmamat/cmsc330spring2024/blob/main/imperative.md)
