# Project 67: Rust 
**Due**:  Friday, December 12th, 11:59PM (Late: Saturday, December 13th, 11:59 PM) \
**Points**: 50 public, 50 semipublic

### Ground Rules

This is an individual assignment. You may use functions found in Rust's standard
library. You may write any helper functions that you wish. 
You may not use `unsafe` or any external crates other than the `regex` crate.


# Checkout link
[https://classroom.github.com/a/PnKOOu43](https://classroom.github.com/a/PnKOOu43)

## Part I: Intro

In this project, we will implement some common (and some uncommon) functions in
Rust in order to get used to the language. Rust has an emphasis on safety, which
will change functionality. By the end of this project, you will be familiar with
this.

> [!NOTE]
> For some functions, you will see `impl IntoIterator`, or other `impl` statements.
> These act similarly to implementing an interface in Java, as you saw in
> 131/132. They just refer to any type that has certain properties, in the `intoIterator` case, types that be iterated over. See the
> documentation of [`IntoIterator`](https://doc.rust-lang.org/stable/core/iter/trait.IntoIterator.html)
> and [`Iterator`](https://doc.rust-lang.org/stable/core/iter/trait.Iterator.html)
> for more details.

### Ground Rules 

This is an individual assignment. You may use functions found in Rust's standard
library. You may write any helper functions that you wish. You may also use the [`regex` crate](https://docs.rs/regex/latest/regex/).
You may not use `unsafe`.

With the help of the standard library, many of these functions will become easier. Consider looking through [the docs](https://doc.rust-lang.org/std/index.html). However, you will get more practice with Rust if you implement them manually. Either is fine for this project, it is up to you. 

### Testing and Submitting

Like OCaml, Rust uses the `build` and `test` commands. However, rather than
`dune`, we use `cargo`.



 - To build your project, run `cargo build`.
 - To run the public tests, run `cargo test`.
 - To get suggestions on various ways to improve your code, run `cargo clippy`.
 - To format your code, run `cargo fmt`.

When running tests, you will see a list of tests, and whether or not you passed: 
```rust 
test test_gauss ... FAILED
test test_in_range1 ... ok
test test_gauss2 ... FAILED
test test_in_range2 ... ok
```

`ok` means you passed. Good job! `FAILED` means that there is an issue. If this
is the case, you will see an output beneath the failed test: 

```rust
---- test_gauss stdout ----
thread 'test_gauss' panicked at tests/public.rs:9:5:
assertion `left == right` failed
  left: Some(2)
 right: Some(1)
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

`left` is YOUR output. `right` is the EXPECTED output.

For this project, the public tests are in the public/mod.rs file.

Rust also supports documentation tests. We have included one example above `gauss()`. These are tests within the comments above functions.
The Rust Book is a great resource if you would like more information about [how document/unit tests work](https://doc.rust-lang.org/stable/cargo/commands/cargo-test.html).

You may add additional unit and documentation tests as you wish, the autograder uses a copy of the original publics. 
You can use the doctest example in `gauss()` or the example `student_test1()` function to see the syntax.

`cargo test` automatically runs **all** documentation *and* unit tests


Rust does not have a toplevel repl similar to `utop`, but you can try your Rust code online at <https://play.rust-lang.org/>.


Remember that Rust has print statements that will appear in the console.
You may wish to take advantage of these for debugging:

- [`println!`](https://doc.rust-lang.org/std/macro.println.html)/[`eprintln!`](https://doc.rust-lang.org/std/macro.eprintln.html)
- [`dbg!`](https://doc.rust-lang.org/std/macro.dbg.html)'

If you liked using `gdb` or `lldb` with C code in CMSC216, those also work with Rust.
Follow [this guide](https://blog.logrocket.com/debugging-rust-apps-with-gdb/#rustgdbexample).


### Rust Analyzer
Rust Analyzer is a very helpful tool that you may wish to use.

If you use VS Code, do Ctrl+P (Windows/Linux) or ⌘P (Mac), paste in `ext install rust-lang.rust-analyzer`, and press Enter. If you don’t use VS Code, find instructions for your editor [here](https://rust-analyzer.github.io/manual.html).

VSCode supports syntax highlighting for Rust like it does for OCaml. In your extensions tab, search Rust and pick your favorite (or the top one). 

## Part (A): Basic Functions

To get familiar with the syntax, we will start with some basic functions.
Implement the following:

### `pub fn gauss(n: i32) -> Option<i32>`

This function sums the numbers from 1 to n, where n is an arbitrary positive
integer. It will return the integer given by 1 + 2 + 3 + ... + `n`. If `n` ≤ 0,
return `None`.

We will not test your code with numbers large enough to risk overflow.

#### Examples

```rust
assert_eq!(gauss(10), Some(55));
assert_eq!(gauss(-2), None);
assert_eq!(gauss(1), Some(1));
assert_eq!(gauss(0), None);
assert_eq!(gauss(19), Some(190));
```

### `pub fn double_up_and_dance(slice: &[i32]) -> Vec<i32>`

This function takes in a reference to a [slice](https://doc.rust-lang.org/std/primitive.slice.html)
of integers as input. A slice resembles arrays in other languages; its a homogenous list of fixed size.

You should perform the following operations:

- Create a new [`Vec`](https://doc.rust-lang.org/std/vec/struct.Vec.html) with
  the same elements as the slice, but repeated twice. For example, `[1, 3, 2]`
  should become `[1, 1, 3, 3, 2, 2]`.
- If the vector ends up having 5 or more entries, take the second number in the **slice** and add it to the fifth number in the **vec**. Thus, our previous example `[1, 1, 3, 3, 2, 2]` becomes `[1, 1, 3, 3, 5, 2]`

#### Examples

```rust
assert_eq!(double_up_and_dance(&[1, 2, 3]), [1, 1, 2, 2, 5, 3]); // 2 (the second element of original slice) is added to the the 3 that was in the 5th element of the vector, yeilding 5

assert_eq!(double_up_and_dance(&[-9, 7]), [-9, -9, 7, 7]);
assert_eq!(double_up_and_dance(&[42, 42]), [42, 42, 42, 42]);
assert_eq!(double_up_and_dance(&[]), []);
assert_eq!(double_up_and_dance(&[3, 2, 3, 7, 8]), [3, 3, 2, 2, 5, 3, 7, 7, 8, 8]);
```

### `pub fn to_binstring(num: u32) -> String`

This function takes in an unsigned integer (i.e. a positive integer) and
converts it to the equivalent binary string. You should not pad with leading
zeros, except for `0` which should become the string `"0"`.


#### Examples

```rust
assert_eq!(to_binstring(0), "0");
assert_eq!(to_binstring(2), "10");
assert_eq!(to_binstring(9), "1001");
assert_eq!(to_binstring(32), "100000");
assert_eq!(to_binstring(510), "111111110");
assert_eq!(to_binstring(0b1101), "1101");
```

### `pub fn in_range(itemlist: impl IntoIterator<Item = i32>, range: Range<i32>) -> usize`


This function takes in a value that can be converted into an iterator of
integers (slice, vector, etc.), and counts how many elements in the iterator are within the given
range **in terms of value**. That is, given the range 2-6, how many of the entries are numbers between 2 and 6? The list you are given is
not necessarily sorted.

[`Range`](https://doc.rust-lang.org/stable/std/ops/struct.Range.html)
is a range of values. It is created using `start..end` syntax. `start` is
included in the range, but `end` is not. For example, `2..6` denotes a range from 2 (inclusive) to 6 (exclusive).


<!-- There are two approaches to implementing this function.

- Imperative/C style: use a `for` loop to iterate over the `items`.
- Functional/OCaml style: use the [`into_iter()`](https://doc.rust-lang.org/std/iter/trait.IntoIterator.html#tymethod.into_iter)
method to convert `items` into an [`Iterator`](https://doc.rust-lang.org/std/iter/trait.Iterator.html),
and then use that trait's methods. -->

#### Examples

```rust
assert_eq!(in_range([5, 2, 1, 3, 9, 6], 2..6), 3);
assert_eq!(in_range(vec![5, 2, 1, 3, 9], 3..5), 1); //vector, rather than a slice. Can still be iterated over!
assert_eq!(in_range([5, 2, 1, 3, 9], 2..11), 4);
assert_eq!(in_range([], 2..11), 0);
```

## Part (B): Complex Functions

### `pub fn capitalize_words<'a>(wordlist: impl IntoIterator<Item = &'a mut String>)`

This function takes in a value that can be converted into an iterator of mutable references to strings. It will capitalize the
**first letter** of each word in the iterator. Note that this function returns a
unit type - you must modify the `String`s referenced by `wordlist`, and so should not return anything new. You may assume that you
will not be asked to capitalize numbers or special characters; inputs are
guaranteed to start with an ASCII letter.

#### Examples

```rust
let mut list = ["hello".to_owned(), "world".to_owned()];
capitalize_words(&mut list);
assert_eq!(list, ["Hello", "World"]);

let mut list = ["cmsc330".to_owned(), "is".to_owned(), "great".to_owned()];
capitalize_words(&mut list);
assert_eq!(list, ["Cmsc330", "Is", "Great"]);
```

### `pub fn read_prices(filename: &str) -> Option<HashMap<String, u32>>`

Given a txt file, parse and return the items sold by a vending machine, along
with their prices. Alternatively, return `None` if the file has an invalid
format.

Each line of the the file must either be a price listing or a comment.

- Price listings consist of the following in the order shown:
  - an item name (starts with an uppercase (`A`-`Z`) or
  lowercase (`a`-`z`) letter, followed by any number of such letters or space characters)
  - a semi-colon `;`
  - a price in cents (any integer)
  - `c` or `cents`.
  - **Each of these can be separated by an arbitrary number of spaces. That
    includes 0 spaces. These should not be included in your hashmap.** (You may assume no spaces at the very beginning of a line.)
- Comment lines start with `;` and can contain any characters after that. They should be ignored.


#### Validity: 
An item's price must be between 1 and 50 cents (inclusive). An
item must appear at most once in the file, duplicates are not allowed.
If any of these rules are violated, or if any line has an invalid format,
you must return `None`.

You can use the [`regex` crate](https://docs.rs/regex/latest/regex/) to implement the rules above.

#### Example Files

```text
;file1.txt
; sweet
ice cream; 10 cents
; savory
sandwich;49c
hot dog ; 49 c
```

```text
;file2.txt
;icecream;10cents
ice cream; 10     cents

; lines below are invalid
goldfish; 100c
sandwich;  49c cents
```

```text
;file3.txt
cat   ; cats are not snacks
chips ; 20c
```

```text
;meow.txt (this is a valid file)
here  kittykitty; 1c
```

Given this file, your function will read through the information and create a
`HashMap`. In this, you will store the string representing the item's name, as
well as the integer representing its price. If a file is empty, or contains just
comments, just return an empty `HashMap`, not `None`.


In addition to the regex crate, a helpful resource for this is [BufReader](https://doc.rust-lang.org/std/io/struct.BufReader.html)
which can be used read the file input into lines.
You can assume that I/O operations succeed, so feel free to `.unwrap()`
any `io::Result`s.

#### Example

```rust
assert_eq!(
    read_prices("inputs/file1.txt"),
    Some(HashMap::from([
        ("ice cream".to_owned(), 10),
        ("sandwich".to_owned(), 49),
        ("hot dog".to_owned(), 49)
    ]))
);
assert_eq!(read_prices("inputs/file2.txt"), None);
assert_eq!(read_prices("inputs/file3.txt"), None);
```


## Part II: Garbage Collector
In this project, we will be implementing versions of the *reference counting*, *mark and sweep*, and *stop and copy* garbage collection algorithms. See [Cliff's notes](https://bakalian.cs.umd.edu/assets/notes/gc.pdf) for more details about these forms of garbage collection.


> [!NOTE]
> In this project, we represent the stack and heap using vecs, with the semantics changing slightly for each strategy.\
> **Please read [About Memory](#about-representation-of-data-in-this-project) BEFORE you begin!**


**Implement the following functions in `src/garbage_coll.rs`**

## Reference Counting

`pub fn reference_counting(string_vec: Vec<String>) -> RefCountMem`

This function inputs a `Vec` with a list of actions taken by a program and outputs the memory layout after the program fully executes.\
**You Will**: Build a heap with reference counts for all the data in the file, as well as the corresponding stack. 

In `utils.rs`, we give you a `int_of_string` function that takes in a `String` and turns that string into an integer. 

>[!IMPORTANT]
> For `reference_counting` *only*, we are going to say that the heap you should create is a set size of 10. In every other function, you may be given heaps of any size, and they will remain that size.
>  
> Note the main difference between RefCountMem and Memory is that RefCountMem has a place for the reference count rather than the name of the memory address.

There are 2 possible actions that can be done.  

We can `Ref`(erence) memory from the stack or heap or `Pop` to remove the most recent stack frame.

In order to determine which action to take, you're encouraged to use regex. You can assume all inputs will follow the format below (i.e. all inputs will be syntactically valid). You may also assume we will not give you indices that go out of bounds.

The possible instructions are:
- `Ref Heap <integer1> <0 or more integers>` allocates memory in the heap in index integer1. In this memory, there should be an option that contains a list with each of the subsequent integers. This is creating references between integer1 and all subsequent integers.
- `Ref Stack <0 or more integers>` Should add an element to the stack, which references the data on the heap represented by the integer(s)
- `Pop` Removes the most recent stack frame.


If memory is allocated to somewhere on the heap that is not referenced by anything, you can safely "ignore" that line
(It's reference count would be 0, so it would be immediately deallocated). You may also ignore lines that `Pop` after all 
stack frames have been removed. Neither of these will result in errors, though.

You will return the `RefCountMem` struct representing the state of memory after all of the program actions have been taken. See [About Memory](#about-representation-of-data-in-this-project) for more info on this struct and what it represents. If the reference count ever reaches 0, deallocate that memory (change it to None).

If an index on the heap is referenced, but never references anything itself, it will be `Some([], <rfcount>)`. 

If there are multiple Heap Refs to the same heap index, the latter instruction will take precedence and overwrite what was previously stored in that index. 

Examples: 

basic.txt:
```txt
Ref Stack 2
Ref Heap 2 0 3 4
Ref Stack 0
Ref Stack 8 9
Ref Heap 0 5 2
Pop
Pop
```

Diagram of each step:

- Before any step

![alt text](imgs/image-3.png)

- Ref Stack 2

![alt text](imgs/image-4.png)

- Ref Heap 2 0 3 4

![alt text](imgs/image-5.png)

- Ref Stack 0

![alt text](imgs/image-6.png)

- Ref Stack 8 9

![alt text](imgs/fixedgc.png)

- Ref Heap 0 5 2

![alt text](imgs/image-7.png)

- Pop

![alt text](imgs/image-8.png)

- Pop

![alt text](imgs/image-10.png)



```rust
// reference_counting("basic.txt") returns 
RefCountMem {
        stack: vec![vec![2]],
        heap: vec![(Some(vec![5, 2]), 1), (None, 0), (Some(vec![0,3,4]), 2), 
            (Some(vec![]), 1), (Some(vec![]), 1), (Some(vec![]), 1), (None, 0), 
            (None, 0), (None, 0), (None, 0)],
}
```

example2.txt:

```txt
Ref Stack 0 1
Ref Heap 1 3 2 5
Pop 
```

- Ref Stack 0 1

![alt text](imgs/i-4.png)

- Ref Heap 1 3 2 5

![alt text](imgs/i-5.png)

- Pop (including each free step)

![alt text](imgs/i-6.png)

This will return: 


```rust
// reference_counting("basic.txt") returns 
RefCountMem {
        stack: vec![],
        heap: vec![(None, 0), (None, 0), (None, 0), 
            (None, 0), (None, 0), (None, 0), (None, 0), 
            (None, 0), (None, 0), (None, 0)],
}
```

## Mark and Sweep

`pub fn mark_and_sweep(mem: &mut Memory) -> ()`

**For this function, we have given you a stub for a helper function called `reachable`. Though it is not directly tested, we HIGHLY recommend you implement this or something similar. It will also help you with Stop and Copy.**

Given a Memory struct, your job is to perform the Mark and Sweep garbage collection on the Heap. Your function will modify the Memory that is passed in rather than creating and returning a new one.


Examples:
```rust
let input_heap: Vec<Option<(String, Vec<u32>)>> = vec![Some(("A".to_string(), vec![1])), Some(("B".to_string(), vec![])), Some(("C".to_string(), vec![])), Some(("D".to_string(), vec![0]))];

let expected = vec![Some(("A".to_string(), vec![1])), Some(("B".to_string(), vec![])), None, Some(("D".to_string(), vec![0]))];

let mut mem = Memory {
    stack : vec![vec! [3]],
    heap: input_heap,
};

mark_and_sweep(&mut mem);
assert_eq!(expected, mem.heap); 
```

Diagram: 

- Before Mark and Sweep

![alt text](imgs/i-10.png)


- After Mark and Sweep

![alt text](imgs/i-1.png)



```rust
let input_heap: Vec<Option<(String, Vec<u32>)>> = vec![Some(("A".to_string(), vec![1, 2])), Some(("B".to_string(), vec![3])), Some(("C".to_string(), vec![3])), Some(("D".to_string(), vec![2]))];

let expected = vec![None, None,  Some(("C".to_string(), vec![3])), Some(("D".to_string(), vec![2]))];

let mut mem = Memory {
    stack : vec![vec! [3]],
    heap: input_heap,
};

mark_and_sweep(&mut mem);
assert_eq!(expected, mem.heap); 
```

Diagrams: 

- Before Mark and Sweep: 

![alt text](imgs/i-3.png)

- After Mark and Sweep: 

![alt text](imgs/i-2.png)


## Stop and Copy

`pub fn stop_and_copy<'a>(mem: &mut Memory<'a>, alive: u32) -> ()`

Stop and Copy tries to solve the problem of fragmentation. In this function, you are given a Memory struct representing the memory at the time the program stops, as well as an integer called `alive`. You may assume all heaps given to you have an even length.  

Meaning of the `alive` flag:
- 0 represents a heap where the left half is `alive` and the right half is `dead`.
- 1 represents a heap where the left half is `dead` and the right half is `alive`.
  
The goal of this function is to copy referenced data from the currently `alive`/active half into the new currently `dead` half. Once the data is copied, the runtime would switch the `alive` flag, activating the new (formerly `dead`) side, resulting in a much more compact active heap. You will not need to switch the flag, you are only responsible for updating the memory to be *ready* for switching.
Both sides of the heap may have memory inside them since *stop and copy* **does not clear** `alive` memory after copying.

**You will**: Copy all reachable memory from the `alive` half into `dead` half. Do not clear the original `alive` half.\
**The data copied into the `dead` half must be contiguous**, starting from the left of the `dead` section.

Remember, data in both the stack and heap can reference other data (represented by the option type). It is guarenteed that entries in the `alive` section of the heap will never reference entries in the `dead` sections and vice versa. When you move data, you must maintain that all of its references are updated to the **new** location in the `dead` half, ensuring that they point to the same data after the copy. You can use the "names" of the heap data to ensure this. This means you will likely have to update references in both the stack and the heap.

The data in the `dead` half of the heap can be in any order, as long as the above conditions are met.

The stack and heap are represented the same way that they are in mark and sweep. You will again have to modify `mem` in place. This function does not return anything.

Please note that the public tests for stop and copy are very limited. You will have to do a lot of your own testing to ensure that you function is working as expected. The named data is there to help you debug. Make sure that everything that should be reachable from the stack is by using the names of the data. 

Examples:
```rust
    let mut mem = Memory {
        stack : vec! [vec! [3]],
        heap : vec! [Some(("A".to_string(), vec![1])), Some(("B".to_string(), vec![0])), Some(("C".to_string(), vec![])), Some(("D".to_string(), vec![0])),  Some(("E".to_string(), vec![7])), Some(("F".to_string(), vec![])), Some(("G".to_string(), vec![5, 4])), Some(("H".to_string(), vec![]))]
    };

    stop_and_copy(&mut mem, 0);

    let expected = Memory {
        stack : vec! [vec! [6]],
        heap :  vec! [Some(("A".to_string(), vec![1])), Some(("B".to_string(), vec![0])), Some(("C".to_string(), vec![])), Some(("D".to_string(), vec![0])), Some(("A".to_string(), vec![5])), Some(("B".to_string(), vec![4])), Some(("D".to_string(), vec![4])), None]
    }; // or equivalent

    assert_eq!(mem, expected);
```

Diagram of above example: 

- Initially:

![alt text](imgs/image-00.png)

- After Stop and Copy: 

![alt text](imgs/i-9.png)

```rust
    let mut mem = Memory {
        stack: vec![vec![6]], 
        heap : vec! [Some(("A".to_string(), vec![1])), Some(("B".to_string(), vec![0])), Some(("C".to_string(), vec![])), Some(("D".to_string(), vec![2])), //dead 
        Some(("E".to_string(), vec![])), None, Some(("F".to_string(), vec![4])), None] // alive
    };
    
    let expected = Memory {
        stack: vec![ vec![1]], 
        heap : vec! [Some(("E".to_string(), vec![])), Some(("F".to_string(), vec![0])), None, None, // alive 
        
        Some(("E".to_string(), vec![])), None, Some(("F".to_string(), vec![4])), None] // dead
    }; // or equivalent
    
    stop_and_copy(&mut mem, 1);
    assert_eq!(mem, expected);
```

Diagram of above example: 

- Initially then after stop and copy

![alt text](imgs/i-8.png)




## About Representation of data in this project: 

Note about representations of memory diagrams: 

First, we are representing the stack frame as programs that are pushed onto and popped from the stack rather than individual references within a program. So, items on the stack may reference multiple pieces of data or none at all, since a program may or may not reference data on the heap.

In Mark and Sweep and Stop and Copy, the stack and heap are represented by Vecs with each index (a `Vec<u32>` for stack and a `Option<(String,Vec<u32>)>` type for the heap) representing a memory address. These slices live inside the Memory struct. For example:

```rust 
Memory {
    stack: vec![vec![3], vec![2,0], vec![]],
    heap: vec![Some("A".to_string(), vec![3, 2]), Some("B".to_string(), vec![]), Some("C".to_string(), vec![]), Some("D".to_string(), vec![4]), Some("E".to_string(), vec![])],
}
```

Represents a memory diagram that appears as follows: ![alt text](imgs/image-1.png)


For reference counting, we modify this slightly, removing the names of memory addresses and replacing that with a space for their reference count. For example:

```rust
pub struct RefCountMem {
    pub stack: vec![vec![3], vec![2,0], vec![]],
    pub heap: Vec<(Option<Vec<u32>>, u32)> 
    vec![(Some(vec![3,2]), 1), (Some(vec![]), 0), (Some(vec![]), 2), (Some(vec![4]), 2), (Some(vec![]), 1)],
}
```

Represents this memory diagram: ![alt text](imgs/image-2.png)

(We included the indicies here to help understanding, but RefCountMem heap entries are unnamed).

**Important Note**: The stack will always be the length of however many programs there are (Hence why the stack is not represented by Option types). However, the stack **may** contain empty lists (some programs don't reference data on the heap at all).

Any pointers to the heap are labeled by their indices in the vec. The information inside the stack and heap entries is the memory that they point to on the heap. The names are for debugging/helper purposes, but are not used for pointers. Memory won't point to itself.

`None` indicates that there is no memory present there in the heap. Freed memory will appear as None. `[]` represents memory that is used, but doesn't point to any other pieces of memory. You may assume nothing in the stack or heap will point to freed memory (None).

Another example of the memory diagrams:

```rust 
Memory {
    stack: vec![vec![0,1], vec![0]],
    heap: [Some("A".to_string(), vec![]), Some("B".to_string(), vec![2, 0]), Some("C".to_string(), vec! [3]), Some("D".to_string(), vec![0]), Some("E".to_string(), vec![]), None, Some("G".to_string(), vec![4]), None]
}
```

Diagram of above: 

![alt text](imgs/i-7.png)
