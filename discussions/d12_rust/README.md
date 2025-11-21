# Discussion 12 - Friday, November 21st

## Reminders

- Project 5 due **Tuesday, November 25th @ 11:59pm** (Late Token deadline *Wednesday*)

## Rust
### Rust References
- [Rust Book](https://doc.rust-lang.org/book/)
- [Simple Version of Rust Book](https://www.cs.brandeis.edu/~cs146a/rust/doc-02-21-2015/book/README.html)
- [Rust Standard Library](https://doc.rust-lang.org/std/index.html)
- [Online Rust Playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021)
- [Anwar's Rust Intro](https://bakalian.cs.umd.edu/assets/slides/00-rust-introduct.pdf)

### Studying Suggestion:

Read the Rust book. This is a *very* good resource to learn Rust from, and for this class we touch on the same topics that it does up to and including chapter 15, as well as chapter 19.

This discussion, for instance, roughly corresponds to chapters 3 and 4.

Chapter 3: (general intro to syntax) https://doc.rust-lang.org/book/ch03-00-common-programming-concepts.html

Chapter 4: (ownwership and borrowing) https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html

You can also take a look at "Rust by Example" for extra code examples: https://doc.rust-lang.org/rust-by-example/index.html

Try your code out in the Rust Playground: https://play.rust-lang.org/?version=stable&mode=debug&edition=2024

### Properties of Rust

Rust is type-safe, meaning a well-typed program has a defined behavior and does not get "stuck", (unless you actively use the `unsafe` keyword, which is disallowed in this class and heavily discouraged for general use even outside of this class).

C is an example of a language that is not type-safe. In C, pointers might be used to access garbage memory, meaning there might be a correctly-typed program that still has undefined behavior due to access of freed or uninitialized memory.

Rust limits some of its capabilities for the sake of type safety. In addition, it makes some decisions to help guarantee memory safety while still not using a garbage collector which may seem unusual at first. We'll talk about this more in a bit.

### Rust Syntax Overview

#### Main

```rust
fn main() {
    // comment
}
```

The main function is where every Rust program starts. When we give you some code, we will often omit the `main` wrapper for brevity, however code in Rust will in general be contained in some code block like `main`.


#### Variables and Bindings

```rust
let x = true;  // bool type
let y = 5;  // defaults to i32 type for integers unless inference implies otherwise
let z = 5.5;  // defaults to f64 type for floats unless inference implies otherwise

// shadowing will happen
let b = 1;
let b = 2;
let c = a + b;  // evaluates to 7, not 6.

// delayed instantiation is possible
let a;
a = 5;

// so far these are all *immutable* assignments
```

See that statements in Rust will end in a semicolon, similar to Java or C.

##### Explicit/Implicit typing

Like OCaml, Rust is statically typed and does do type inference when it can, so we don't need to explicitly state the types of many let bindings (compare to C, where bindings might look like `int x = 5;`).

However, we *can* still explicitly give the type, and sometimes we *need* to (if the type cannot be inferred). For instance:

```rust
// May want to put a type for readability reasons
let a: bool;
// ... lots and lots of code
a = true;

// May want something different to the defaults
let x: f32 = 5.0;
let x: u64 = 5;
let x: usize = 5;  // usize is the integer type used for most indexing operations
// Rust is statically typed, so note that the above is an example of
// shadowing - not reassignment of the same variable

// Inference may not be possible
let y;  // error
// ^ unless we later instantiate y we cannot infer its type
```

[Here](https://doc.rust-lang.org/book/ch03-02-data-types.html) is some more information about Rust's primitive types. 

One quick thing to note is that, like in OCaml, floats must have a `.` to be considered floats rather than integers. For instance, `let x: f64 = 5;` is invalid and `let x: u32 = 5.0` is invalid.

As with OCaml, bindings are effectively a type of pattern matching. Recall that in OCaml we could do things like this:

```ocaml
let (a, b) = (1, 2) in a  (* evaluates to 1 *)
```

Similarly, in Rust, we can do things like this:

```rust
let (x, y) = (1, 2);
let z = x;  // z has value 1
```

#### Mutable Variables

In Rust, bindings are not mutable by default. This following code is wrong:

```rust
let x = 5;
x = 6;
```

Attempting to compile it will give this error:

```
error: re-assignment of immutable variable `x`
     x = 6;
     ^~~~~~
```

If you want to make a variable mutable, you must use the **mut** keyword.

```rust
let mut x = 5; // x is now mutable
x = 6; // this is a valid statement
```

#### Blocks

A sequence of expressions surrounded by `{}` is called a **block**. 
- The curly braces enclose the scope of that block.
- If the final expression does *not* end with a `;`, the final expression in the block determines the type and value of that block.
- If the final expression *does* end with a `;`, the block has value `()` and type `()` (similar to OCaml's `unit` type which has value `()`).

Example 1:

```rust
{
    let x = true;
    x
}
```

This block's final expression is the variable `x`, so the block has value `true` and type `bool`.

Example 2:

```rust
{
    let x = 4;
    let y = 5;
}
```

This block's final expression is terminated by a `;`, so it has value `()` and type `()`.

You can do things like this:

```rust
let z = {let x = true;};  // z has type and value `()`
let q = {let x = true; x};  // q has type `bool` and value `true`
```

Since the braces imply scope, things declared in a block cannot be used outside of that block:

```rust
{
    let x = true;
}
let y = x; // error: cannot find value `x` in this scope
```

#### Functions

Similar to most languages you've seen before, functions in Rust are denoted using parentheses for their input parameters and curly braces wrapping the body. Notably, these curly braces form a block.

```rust
// the body is a block, so it evaluates based on the last line!
fn addv1(x: i32, y: i32) -> i32 {
    x + y
}

// if you want, you can instead use the `return` keyword inside a function body
// this is more useful if you want an "early" return that is not the last thing in the body
fn addv2(x: i32, y: i32) -> i32 {
    return x + y;
}

fn main() {
    addv1(1, 2);  // evaluates to 3
    addv2(1, 2);  // evaluates to 3
}
```

Notice that parameters of functions have explicit types: `x: i32` says "an argument passed into this parameter must have the `i32` type, i.e. be a 32 bit signed integer". These are required. We will talk about how to write generic functions later.

Similarly, notice that after the `fn add(...)` there is an `-> i32`. This indicates that this function will return an `i32` type. If this `-> type` is ommited, that is the same as having written `-> ()`, where the `()` type is similar to the `unit` type in OCaml.

#### Printing and Macros

This is how you print a string followed by a newline in Rust:

```rust
println!("Hehe");
```

Notice that that there is an '!' symbol placed after the `println`. This indicates that `println` is is not a normal function call, but rather a **macro** call. This means the code will be replaced at compile time - you are using a shorthand rather than writing out a bunch of steps of code. 

All you need to realistically understand for now is that when you print, you should call the `println!()` macro and not try and call a nonexistent `println()` function.

As with most languages, string literals are wrapped with quotation marks. We will talk more about strings in Rust soon, as they are not simple.

To print a variable, syntax like this is needed:

```rust
let x = 5;
let y = "hi";
println!("Just one: {}", x);  // prints `Just one: 5`
println!("Both: {} {}", x, y);  // prints `Both: 5 hi`
```

And sometimes, debug print might be preferable or required - this is indicated by using `{:?}` rather than `{}`.

```rust
let x = 5.0;
println!("Regular: {}", x);  // prints `Regular: 5`
println!("Debug: {:?}", x); // prints `Debug: 5.0`

let z = {let y = 5;};  // recall that this has value () and type ()
// println!("Regular: {}", z);  // error - cannot use regular print on () types
println!("Debug: {:?}", z); // prints `Debug: ()`
```

#### Conditionals and Loops

##### Conditionals

`if` is an expression and can be used similar to how it was in OCaml. It takes the form `if <guard> <then_block> else <else_block>`.

```rust
let x = true;

let y = if x {
    5
} else {
    4
};

// can be on one line
let y = if !x {5} else {4};

// can be missing an else case
let z = if x {let q = 5;};  // recall that this block will have type () and value ()
```

Things to note:

See `!x` meaning not x. x and y is `x && y`, x or y is `x || y`. 

If expressions in Rust do not have to have parentheses around the guard clause, and the Rust compiler will throw a warning if you add them. 

Conditional branches *must* evaluate to the same type as each other, like in OCaml. If there is no `else` case, it is assumed to have type/value `()`, and so the `then` case *must* also evaluate to `()`.

For example, trying to compile this wrong program:

```rust
let x = true;
let y = if x && false {5};
```

gives the following error message:

```rust
error[E0317]: `if` may be missing an `else` clause
 --> src/main.rs:7:13
  |
7 |     let y = if x && false {5};
  |             ^^^^^^^^^^^^^^^-^
  |             |              |
  |             |              found here
  |             expected integer, found `()`
  |
  = note: `if` expressions without `else` evaluate to `()`
  = help: consider adding an `else` block that evaluates to the expected type
```

##### Loops

`loop`
```rust
let mut x = 10;
loop {
    if x <= 0 {
        break;
    }
    println!("This statement is printed 10 times.");
    x = x - 1;
}
```

Using the generic `loop` keyword is an infinite loop, which can only be exited using break. Similar to other languages, `break;` exits from the loop and `continue;` jumps to the next loop iteration.

`while`
```rust
let mut x = 10;
while x > 0 {
    println!("This statement is printed 10 times.");
    x = x - 1;
}
```

Similar to if statements, `while` loops don't have parentheses around the guard. Observe that iterating using `loop {}` is the same as iterating with `while true {}`.

`for`
```rust
for x in 0..10 { 
    println!("{}", x); // prints numbers 0, 1, 2, ..., 8, 9
}
```

Note that `0..10` is a range - a list-like struct that is **inclusive** of the first number and **exclusive** of the last number.

Abstractly, `for` loops follow the structure:

```rust
for var in thing {
    // code
}
```

where the `thing` "implements the `Iterator` trait", which we'll talk about more, but not in this discussion.

For example:

```rust
let x = vec![1, 2, 3];
for var in x.iter() {
    println!("{}", var);
}
```

A few things are happening here. For now, note two things:

1) One way to declare a list-like thing is with the `vec!` macro.
2) You might need to use `.iter()` or a similar function to produce something you can iterate over - a vec alone does not implement the needed `Iterator` trait.

Instead of using a `for` loop, you can use a function: For instance, you can loop through an iterable object in the following way:

```rust
let some_list = vec![1,2,3];
some_list.iter().for_each(|x| println!("{}", x))
```

The syntax `|param1(: type), param2(: type), ...| <body>` is used. This syntax is called a closure, and (for our purposes) is equivalent to ocaml's anonymous function `(fun param1 param2 -> //do something)`.

We can also call map/fold:

```rust
let x = vec![1,2,3];

let y: Vec<i32> = x.iter().map(|x| x + 1).collect(); 
// collect() is called to turn it from a map object type
// to the type we declared for `y` (Vec<i32>, a vec which stores values of type i32)

let z: i32 = x.iter().fold(0, |acc, ele| acc + ele);
// Here, 0 is the init value for the accumulator

println!("{:?}", y); // [2, 3, 4]
println!("{:?}", z); // 6
```


#### Pattern Matching

Match expressions work similarly to those in OCaml, but the syntax is slightly different:

```rust
let x = 5;

match x {
    1 => println!("one"),
    2 => println!("two"),
    3 => println!("three"),
    4 => println!("four"),
    5 => println!("five"),
    _ => println!("something else"),
}
```

In Rust, match expressions enforce **exhaustive** checking.
If the matches are not exhaustive, it will give the following error:

```
error: non-exhaustive patterns: `_` not covered
```

Okay, that was a not-so-quick overview of simple Rust syntax. 

### Ownership and Borrowing

Now, let's get into what makes Rust special: it is able to be memory safe *without* needing a Garbage collector.

C is very fast! One of the things that make it very fast is that it does *not* do garbage collection - it relies on *you*, the programmer, to correctly allocate and free memory when you need to. However, C is not memory-safe, and also the programmer might not do this correctly and have memory leaks and segfaults.

Java and Python are slower. They are (generally) memory-safe, but rather than having you allocate memory and you free memory, every once in a while they will pause a running program, check what memory can be freed, free it, and then restart the program. This is called "garbage collection" and it is slow.

Rust does *not* rely on you to free unused memory, but it *also* does not need to pause to do garbage collection. How?

#### Step 1: Copy, Clone, and Ownership

In Rust, types can implement **traits** (like implementing interfaces in java). One trait we breifly discussed earlier was the `Iterator` trait. Another is the `Copy` trait.

Types which implement `Copy` (ex. primitives like bool, i32) create copies of values when a variable is set to another variable:

```rust
let x = 5; // x owns 5
let y = x; // y owns 5 (a different 5 than x)

println!("{} = 5!", y); //ok
println!("{} = 5!", x); //ok
```
Types which do *not* implement `Copy` do *not* do this. Setting to a variable with a value that does not implement `Copy` **transfers ownership**:

```rust
let x = String::from("hello");
let y = x; // x transfers ownership of that String value to y

println!("{}, world!", y); // ok
println!("{}, world!", x); // ERROR!
```

Sample error message:

```rust
error[E0382]: borrow of moved value: `x`
  --> src/main.rs:10:28
   |
 6 |     let x = String::from("hello");
   |         - move occurs because `x` has type `String`, which does not implement the `Copy` trait
 7 |     let y = x; // x transfers ownership of that String value to y
   |             - value moved here
...
10 |     println!("{}, world!", x); // error!
   |                            ^ value borrowed here after move
   |
   = note: this error originates in the macro `$crate::format_args_nl` which comes from the expansion of the macro `println` (in Nightly builds, run with -Z macro-backtrace for more info)
help: consider cloning the value if the performance cost is acceptable
   |
 7 |     let y = x.clone(); // x transfers ownership of that String value to y
   |              ++++++++
```

If we want a copy, one thing that might work is if the value implements the `Clone` trait and we can clone the value explicitly:

```rust
let x = String::from("hello");
let y = x.clone();  // x now owns a different version of "hello"

println!("{}, world!", y); // ok
println!("{}, world!", x); // ok
```

The idea is: If we can keep track of a single variable who owns a single value, once that variable goes out of scope, that value can be *dropped* and its associated memory freed instantly! This removes the need to pause the program and track down what memory needs to be garbage collected.



#### Step 2: References

(References/Borrowing have not been covered in lecture yet, but are here for your reference :) )

We don't always want to either clone or take ownership of a value. Instead, we can create a reference to that value with `&`:

```rust
let x = String::from("hello");
let y = &x;  // x now owns a reference to the value "hello", not "hello" itself

println!("{}, world!", y); // ok
println!("{}, world!", x); // ok
```

When defining variables, take note of the following keywords:
- **mut**: an object/primitive has the ability to update (ex. Array or Integer)
- **&**: Borrowing a reference for a variable, useful when you want to pass a variable to a function without updating it
- **&mut**: A mutable reference to a variable (must be defined mut). Comes particularly handy when you want to pass a variable to another function and have it updated.

```rust
let mut x = String::from("hello");  // mutable variable x
x.push_str("hi");  // can be mutated - is now "hellohi"

let y = &x;  // immutable variable y, an `immutable reference` to x
let y = &mut x;  // immutable variable y, a `mutable reference` to x

let mut y = &x;  // mutable variable y, an `immutable reference` to x
let mut y = &mut x;  // mutable variable y, a `mutable reference` to x

```
```rust
let z = String::from("hello");  // immutable variable z
// cannot be mutated

let y = &z;  // immutable variable y, an `immutable reference` to z
let mut y = &z;  // mutable variable y, an `immutable reference` to z

// the below cause errors - cannot have a mutable reference to an immutable value
let y = &mut z;  // immutable variable y, a `mutable reference` to z
let mut y = &mut z;  // mutable variable y, a `mutable reference` to z

```

Refer to [here](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html) for more information!

Without references, functions will *take ownership* of non-copyable things:

```rust
// ERROR!
fn main() {
     let s1 = String::from("hello");
     let len = calc_len(s1); // passes s1 directly, not reference
     println!("the length of {} is {}",s1,len);  // ERROR! s1 no longer has ownership of any value.
}

// will take ownership of the value passed in to `s`
fn calc_len(s: String) -> usize {
     s.len()
    // value of s is dropped since it is now out of scope
}
```

Sample error message:

```rust
error[E0382]: borrow of moved value: `s1`
 --> src/main.rs:4:40
  |
2 |      let s1 = String::from("hello");
  |          -- move occurs because `s1` has type `String`, which does not implement the `Copy` trait
3 |      let len = calc_len(s1); // passes s1 directly, not reference
  |                         -- value moved here
4 |      println!("the length of {} is {}",s1,len);  // ERROR! s1 no longer has ownership of any value.
  |                                        ^^ value borrowed here after move
  |
note: consider changing this parameter type in function `calc_len` to borrow instead if owning the value isn't necessary
 --> src/main.rs:8:16
  |
8 | fn calc_len(s: String) -> usize {
  |    --------    ^^^^^^ this parameter takes ownership of the value
  |    |
  |    in this function
  = note: this error originates in the macro `$crate::format_args_nl` which comes from the expansion of the macro `println` (in Nightly builds, run with -Z macro-backtrace for more info)
help: consider cloning the value if the performance cost is acceptable
  |
3 |      let len = calc_len(s1.clone()); // passes s1 directly, not reference
  |                           ++++++++
```

We *could* have the function always return a tuple - one value being the parameter as to pass ownership back out of the function. However, it would be very inconvenient to have to constantly pass ownership back out of the function. References are better!

An example of borrowing an immutable reference:
```rust
fn main() {
     let s1 = String::from("hello");
     let len = calc_len(&s1); // lends reference
     println!("the length of {} is {}",s1,len);
}

fn calc_len(s: &String) -> usize {
     s.len() 
    // s is dropped, but that's okay! It's just a reference, not the original string.
}
```

An example of borrowing a mutable reference:
```rust
fn main() {
    let mut s1 = String::from("hello");
    append_world(&mut s1); // lends mutable reference, note s1 must be mutable
    println!("s1 is now {}", s1);
}

fn append_world(s: &mut String) {
    s.push_str(" world!");
    // s is dropped, but that's okay! It's just a reference, not the original string.
}
```

#### Step 3: Scope and Lifetime

The **scope** of a variable extends as far as defined/freed (between curly braces). 

The **Lifetime** of a variable spans as long as the variable is being used. A variable's lifetime ends the line **after the last time it is used**.

```rust=
{
    let x = 3; 
    // x lifetime has ended
    {
        let y = 4;
        println!("{}", y);
    } 
    // y scope has ended, y lifetime has ended
    
    let z = 5;
    // z lifetime ends
    
    println!("Hello World!");
} 
// scope of x, z has ended
```

#### Rules of References
1) At any given time, you can have either ***but not both*** of the following at the same time:
    a) **one mutable reference** 
    b) **any number of immutable references**.
2) References must always be valid (no dangling references - will cover later).

In other words, we cannot have an immutable/mutable reference with overlapping lifetimes. 

Example:
```rust=
fn main() {
    let mut s1 = String::from("hello");

    let s2 = &s1;  //ok since no mutable references are alive right now
    // s2 lifetime ends
    let s3 = &mut s1; //ok since no references are alive right now

    // let s4 = &s1; //NOT OK, s3 has mutable borrow still alive
    // let s5 = &mut s1; //NOT OK, s3 has mutable borrow still alive
    println!("String is {}", s3); //ok; 
    // s3 lifetime ends
    
    let s4 = &s1; //ok since s3's lifetime ended
    let s5 = &s1; //ok since you can have many immutable borrows at the same time
    // let s6 = &mut s1; //NOT OK, cannot have mutable borrows at same time as immutable borrows
    
    println!("String is {} = {}", s4, s5); //ok; 
    // s4, s5 lifetimes end
}
```

Each use of the original variable works as if it is a use of a reference whose lifetime ends at that usage. It is easier to see this by example.

Example:
```rust=
fn main() {
    let mut x = String::from("Hello");
    
    x.push_str(", I am an alien!");  // ok! mutable use of mutable variable x while no references exist

    let y = &x;  // immutable reference exists now
    
    // x.push_str(", I am an alien!"); // error! mutable use of x cannot overlap lifetime of immutable reference y
    
    println!("using x {}", x);  // ok! immutable use of x is fine since any number of immutable refs can exist at once
    
    println!("using y {}", y);
    // y lifetime has ended
    
    x.push_str(", I am an alien!");  // ok! mutable use of x is occuring after end of y's lifetime
}
```

### Compiling Rust

#### Using Rustc

Rust files are compiled in the command line using **rustc**, a compiler that was built in Rust.

```
$ rustc main.rs
```

Similar to compiling C with gcc, this creates an executable file.

```
$ ls
main  main.rs
```

To execute the file, simply run `./main`.

#### Using Cargo

Cargo is a Rust package manager. It can download Rust crates and invoke the compiler (rustc) on them.

Basic Cargo commands:
- `cargo check` runs a syntax check on the code
- `cargo build` compiles the code
- `cargo test` will run tests
- `cargo run` will run the code directly
    - If your code has changed since last time it was compiled, `cargo run` will recompile the code and then run it.


## Exercise

Write a function `is_prime` that given an integer, returns true if the integer is prime and false if the integer is composite.

Then, wite a `main` function that tests your `is_prime` function by printing `i is prime!` or `i is composite!` for integers `1 <= i <= 500`. 

Then, print the number of integers `i` we found to be prime in the format `We found [answer] primes from 1 to 500!`. 

Finally, compile and run your code!

You can do this in a cargo project or in the [rust playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2024).

Some expressions that might be useful:
- `(n as f64).sqrt() as u32` will find the square root of n and floor it
- `%` is the modulus operator

[Click here for a solution! (I would highly encourage you to try this problem first!! :D)](https://github.com/cmsc330spring25/spring25/blob/main/discussions/d11_rust_basics/solution.rs)

### Additional Resources
- [Online Interactive Rust Environment](https://play.rust-lang.org/)
- [Cliff's Rust Notes](https://bakalian.cs.umd.edu/assets/notes/rust.pdf)
- [Anwar's Rust Notes](https://github.com/anwarmamat/cmsc330spring2024/blob/main/rust.md)