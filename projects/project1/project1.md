# Project 1: OCaml Warmup

Due: Tuesday, September 16, 2025 at 11:59 PM (Late: Wednesday, September 17, 2025 at 11:59 PM)

Points: 35 public/55 semipublic/10 secret. See below for definitions.

**This is an individual assignment. You must work on this project alone.**

## Introduction

The goal of this project is to get you familiar with programming using OCaml. You will have to write a number of small functions, each of which is specified in four sections below.

We recommend you get started right away, working from top to bottom. The problems will get increasingly challenging, and in some cases, later problems can take advantage of earlier solutions.

### Ground Rules

In your code, you may **only** use library functions found in the [`Stdlib` module](https://caml.inria.fr/pub/docs/manual-ocaml/libref/Stdlib.html) (including `@` and `::`). This means you may **not** use any submodules of `Stdlib`, you may **not** use modules that link away from this page, and you may **not** use the `List` module!

You may **not** use any imperative structures of OCaml such as references (`ref` keyword, `:=` sign, single semicolons, etc.), loops, or any function with type "unit" outside of testing.

### Testing & Submitting

**Check out the project here:**  

The project will include the following types of tests:

- Public: test code is included in your project so you can see the function calls and their output.
- Semipublic: test code is hidden but the Gradescope test names will specify which functions are tested.
- Secret: test code is hidden and the names will not divulge which functions are tested. However, whether you pass will still be visible on Gradescope as soon as you submit.

You should test your project *locally* in the following ways:

1. Run the public tests. These tests are the same as those on Gradescope.
2. Write student tests in `test/student/student.ml` to best predict what you think the non-public tests are. A template for this is provided.
3. Test interactively with `dune utop src`

Relying on uploading to Gradescope for testing is poor practice and not recommended. Additionally, staff cannot tell you what the semipublic and secret tests are.  

**Running All Tests:**

To run all tests locally, use

`dune runtest -f`

The command above will run both public and student tests. If you want to only test using a specific test file (say your student tests file), run `dune runtest -f test/student`, replacing the path if your testing files are located in a directory elsewhere. We recommend you write student tests in `test/student/student.ml`.

If you get stuck in an infinite loop, exit the tests using `Ctrl-C`. Do *not* use `Ctrl-Z`, as this will only suspend the process, not end it. 

**Test Output:**

Each test has a group it belongs to, an id number, and a name. After running tests, an overview of the test results will be displayed to you in a table, where each row has the result of the test ([OK] if function output matches the desired result and [FAIL] if it doesn't), the test's group, the test id number, and the name of the test. An image of the results of 4 successful tests is below:\
![test overview](assets/testoutput.png)

To find the content of the specific test you're failing, first navigate to `test/public.ml` and search for the name of the test. You should find something that says 
```ocaml
test_case <name of test> `Quick <name of function>
```
Then, search for the name of the corresponding function and you'll be able to see what is being tested.\
Pictures of the test list and corresponding functions are attached below.
![testlistwfunction](assets/p1testsimg.png)

At the bottom of the output, there will be a sentence summary of the tests. If all tests are passing, it will say "Test Successful", otherwise it will list the number of failures. So for example, if 12 tests are run, and they all pass, the output will say
```
Test Successful in 0.001s. 12 tests run
```
If 12 tests are run and 4 fail, the output will say
```
4 failures! in 0.001s. 12 tests run
```

Below the overview will be information about the first test failed, with the expected and actual output.
>[!TIP]
>By default, the tests are set to only show you the information about the first test you fail. If you would like to see the information about all tests failed, go to `test/public.ml` and uncomment the ~argv array, which contains `"--show-errors";`

**Running Individual Tests:**

To run a *single* test you need to do the following:
1. Navigate to `test/public.ml` and comment out the `~argv` array in the call to `run`
2. Build using `dune build`. This should create a `_build` folder or similar.
3. Find where the test executable is (for example, the public test executable might have this filepath):

   `_build/default/test/public/public.exe`
4. Using the group of the test you want and the id number run that test (for example, this runs the test `abs` test, which is in the group `Part I` and has an id `0`):

   `./_build/default/test/public/public.exe --compact '^Part I$' '0'`

>[!TIP]
> Note that `Part I` is wrapped in `^$`. This is a regular expression. You will learn what this means later in the semester if you are not already familiar with the topic, but for now, you can just wrap the test group in `^$`.

**Testing Interactively:**

To test your code interactively, run `dune utop src` (assuming you have `utop` installed properly). This allows you to use any of the functions located in the `src/` directory in this `utop` instance. All of your commands in `utop` must end with two semicolons (i.e. `;;`); otherwise, your terminal will appear to hang. Exit `utop` using `Ctrl-D`, `Cmd-D`, or typing `#quit;;`.

**Submitting:**

Submitting to Gradescope can be done using the exact same method used for project 0. Add your changes, commit them, push them, and then run the `submit` script. Reminders: 1) You *must* properly push to GitHub before submitting, as Gradescope takes the files from there and not from your local files. 2) Do not manually upload files to Gradescope; only use the submit command or the GitHub upload option on Gradescope.

>[!IMPORTANT]
> You have 3 24-hour extension tokens to use for the semester. *You can only use one per project*. Refer to class syllabus. This is done by modifying the contents of the LATE_TOKEN file from `false` to `true` and submitting after the deadline has passed.
>
> The LATE_TOKEN file will only be checked if you have submitted late (within 24 hours after the deadline).
> Once you use a token (submit within 24 hours after the deadline with the LATE_TOKEN contents = true), you **will not be able to change it even if you submit with contents = false later**. Once it is used, it is locked in!

### Project Files

The following are the relevant files for your code:

- OCaml Files
    - **src/basics.ml**: You will **write your code here**, in this file for **parts 1-3**. 
    - **src/basics.mli**: This file is used to describe the signatures of all the functions in the module.  *Do not modify this file*; Gradescope will use the original version.
    - **src/basics_iv.ml**: You will **write your code here**, in this file for **part 4**. 
    - **src/basics_iv.mli**: This file is used to describe the signatures of all the functions in the module.  *Do not modify this file*; Gradescope will use the original version.
    - **src/funs.ml**: This file includes implementation for some useful higher order functions. These are required for Part 4, but can be used throughout the project if you wish. *Do not modify this file*; Gradescope will use the original version.
    - **src/funs.mli**: This file is used to describe the signatures of all the functions in the funs.ml. *Do not modify this file*; Gradescope will use the original version.

### Important Notes about this Project

1. Some parts of this project are additive, meaning your solutions to earlier functions can be used to aid in writing later functions. Think about this in parts 3 and 4.
2. In sections 1, 2, and 3 (but *not* 4) you may add any helper functions you wish for, and these helper functions may be recursive. If you create a recursive helper function, the main function that calls the recursive helper does not also require the `rec` keyword in its function header.
3. In section 4, you *may* create helper functions, but they **cannot be recursive**: nor can the helpers themselves use recursive helpers.
4. You may move the function definitions around. In OCaml, in order to use one function inside of another, you need to define the inner function before it is called in the outer function. For example, if you think that a function from Part 2 can be used to help you implement a function in Part 1, you can move your implementation of the function from the Part 2 section to before the function in Part 1. As long as you still pass the tests and you haven't created a syntax error, you are fine.
5. Pay special notice to a function's type. Often times, you can lose sight of what you're trying to do if you don't remind yourself of the types of the arguments and the type of what you're trying to return.
6. You may rename arguments however you would like, but **do not modify function's name**, and **do not change the amount and order of arguments**. Doing so will cause you to fail the function's tests.
7. Double-check the Ground Rules at the top of the ReadMe about what OCaml features you are allowed to use for this project.

# Part 1: Non-Recursive Functions

Implement the following functions that do not require recursion. Accordingly, these functions are defined without the `rec` keyword, but **you MAY add the `rec` keyword to any of the following functions or write a recursive helper function**. Just remember that if you write a helper function, it must be defined before it is called.

#### `abs x`

- **Type**: `int -> int`
- **Description**: Returns the absolute value of `x`.
- **Restrictions**: Do not use the `abs` function from stdlib.
- **Examples**:
   ```ocaml
   abs 1 = 1
   abs (-2) = 2
   ```

#### `rev_tup tup`

- **Type**: `'a * 'b * 'c -> 'c * 'b * 'a`
- **Description**: Returns a 3-tuple in the reverse order of `tup`.
- **Examples**:
   ```ocaml
   rev_tup (1, 2, 3) = (3, 2, 1)
   rev_tup (1, 1, 1) = (1, 1, 1)
   rev_tup ("a", 1, "c") = ("c", 1, "a")
   ```

#### `is_even x`

- **Type**: `int -> bool`
- **Description**: Returns whether or not `x` is even.
- **Examples**:
  ```ocaml
  is_even 1 = false
  is_even 4 = true
  is_even (-5) = false
  ```

#### `area p q`

- **Type**: `int * int -> int * int -> int`
- **Description**: Takes in the Cartesian coordinates (2-dimensional) of any pair of opposite corners of a rectangle and returns the area of the rectangle. The sides of the rectangle are parallel to the axes.
- **Examples**:
  ```ocaml
  area (1, 1) (2, 2) = 1
  area (2, 2) (1, 1) = 1
  area (2, 1) (1, 2) = 1
  area (0, 1) (2, 3) = 4
  area (1, 1) (1, 1) = 0
  area ((-1), (-1)) (1, 1) = 4
  ```

# Part 2: Recursive Functions

Implement the following functions **using recursion**. You will lose points if this rule is not followed.
If you create a recursive helper function, the main function that calls the recursive helper does not have to have the `rec` keyword in its function header.

#### `fibonacci n`

- **Type**: `int -> int`
- **Description**: Returns the `n`th term of the fibonacci sequence.
- **Assumptions**: `n` is non-negative, and we will **not** test your code for integer overflow cases.
- **Examples**:
  ```ocaml
  fibonacci 0 = 0
  fibonacci 1 = 1
  fibonacci 3 = 2
  fibonacci 6 = 8
  ```

#### `pow x p`

- **Type**: `int -> int -> int`
- **Description**: Returns `x` raised to the power `p`.
- **Assumptions**: `p` is non-negative, and we will **not** test your code for integer overflow cases.
- **Examples**:
  ```ocaml
  pow 3 1 = 3
  pow 3 2 = 9
  pow (-3) 3 = -27
  ```

#### `log x y`
- **Type**: `int -> int -> int`
- **Description**: Returns the log of `y` with base `x` rounded-down to an integer.
- **Assumptions**: You may assume the answer is non-negative, `x` >= 2, and `y` >= 1.
- **Examples**:
  ``` ocaml
  log 4 4 = 1
  log 4 16 = 2
  log 4 15 = 1
  log 4 64 = 3
  ```

#### `gcf x y`
- **Type**: `int -> int -> int`
- **Description**: Returns the greatest common factor of `x` and `y`.
- **Assumptions**: You may assume `x` >= `y` >= 0.
- **Examples**:
  ``` ocaml
  gcf 0 0 = 0
  gcf 3 0 = 3
  gcf 12 8 = 4
  gcf 24 6 = 6
  gcf 27 10 = 1
  gcf 13 13 = 13
  gcf 128 96 = 32
  ```

# Part 3: Lists

For the following functions, creating helper functions and/or using recursion is allowed but not required.

#### `reverse lst`

- **Type**: `'a list -> 'a list`
- **Description**: Returns a list with the elements of `lst` but in reverse order.
- **Examples**:
  ```ocaml
  reverse [] = []
  reverse [1] = [1]
  reverse [1; 2; 3] = [3; 2; 1]
  reverse ["a"; "b"; "c"] = ["c"; "b"; "a"]
  ```
  
#### `zip lst1 lst2`

- **Type**: `('a * 'b) list -> ('c * 'd) list -> ('a * 'b * 'c * 'd) list`
- **Description**: Merge two tuple lists, `lst1` and `lst2`, and return the result as one tuple list. Tuples will only contain two elements. The final answer will have a length equivalent to the minimum of the input lengths.
- **Examples**:
  ```ocaml
  zip [(1, 2); (3, 4); (5, 6)] [(7, 8); (9, 10); (11, 12)] = [(1, 2, 7, 8); (3, 4, 9, 10); (5, 6, 11, 12)]
  zip [] [] = []
  zip [(1, 4)] [] = []
  zip [(1, 2); (3, 4)] [(7, 8)] = [(1, 2, 7, 8)]
  ```

#### `merge lst1 lst2`

- **Type**: `'a list -> 'a list -> 'a list`
- **Description**: Merge two sorted lists, `lst1` and `lst2`, and return the result as a sorted list. 
- **Examples**:
  ```ocaml
  merge [1] [2] = [1;2]
  merge [] [] = []
  merge [1; 4] [2; 3] = [1; 2; 3; 4]
  merge [1; 4; 5] [2; 3; 6; 7; 8; 9] = [1; 2; 3; 4; 5; 6; 7; 8; 9]
  merge [1] [0] = [0; 1]
  ```

#### `is_present lst x`

- **Type**: `'a list -> 'a -> bool`
- **Description**: Returns if `x` is in `lst`
- **Examples**:
  ```ocaml
  is_present [1;2;3] 1 = true
  is_present [1;1;0] 0 = true
  is_present [2;0;2] 3 = false
  ```

#### `every_nth n lst`

- **Type**: `int -> 'a list -> 'a list`
- **Description**: Returns a list of every `n`th value from `lst`
- **Assumptions**: `n` is a positive number >= 1.
- **Examples**:
  ```ocaml
  every_nth 2 [1;2;3;4] = [2;4]
  every_nth 1 [1;2;3;4] = [1;2;3;4]
  every_nth 3 [1;2;3;4] = [3]
  ```

#### `jumping_tuples lst1 lst2`

- **Type**: `('a * 'b) list -> ('c * 'a) list -> 'a list`
- **Description**: Given two lists of equal length of two-element tuples, `lst1` and `lst2`, return a list based on the following conditions:
  + The first half of the list should be the first element of every odd-indexed tuple in `lst1`, and the second element of every even-indexed tuple in `lst2`, interwoven together (starting from index 0). 
  + The second half of the list should be the the first element of every even-indexed tuple in `lst1`, and the second element of every odd-indexed tuple in `lst2`, interwoven together (starting from index 0). 
- **Assumptions**: `lst1` and `lst2` are the same length.

Consider using functions you have written above as helpers.

- **Examples**:
  ```ocaml
  jumping_tuples [(1, 2); (3, 4); (5, 6)] [(7, 8); (9, 10); (11, 12)] = [8; 3; 12; 1; 10; 5]
  jumping_tuples [(true,"a"); (false,"b")] [(100, false); (428, true)] = [false; false; true; true]
  jumping_tuples [("first", "second"); ("third", "fourth")] [("fifth", "sixth"); ("seventh", "eighth")] = ["sixth"; "third"; "first"; "eighth"]
  jumping_tuples [] [] = []
  ```

Here's an image that shows the jumping logic for the first example from above:
![jumping tuples example](./assets/jumping_tuples.png)

#### `max_func_chain init funcs`
- **Type**: `'a -> ('a -> 'a) list -> 'a`
- **Description**: This function takes in an initial value and a list of functions, and decides to either apply each function or not to maximize the final return value. For example, if we have a list of functions:
`[funcA; funcB; funcC]` and an initial value `x`, then we take the maximum value
of
   + `x`
   + `funcA(x)`
   + `funcB(funcA(x))`
   + `funcC(funcB(funcA(x)))`
   + `funcC(funcA(x))`
   + `funcB(x)`
   + `funcC(funcB(x))`
   + `funcC(x)`
- **Examples**:
  ```ocaml
  max_func_chain 2 [(fun x -> x + 6)] = 8
  max_func_chain 2 [(fun x -> x + 4); (fun x -> x * 4)] = 24
  max_func_chain 4 [(fun x -> x - 2); (fun x -> x + 10)] = 14
  max_func_chain 0 [(fun x -> x - 1); (fun x -> x * -500); (fun x -> x + 1)] = 501
  max_func_chain "hello" [(fun x -> x ^ "1"); (fun x -> x ^ "2"); (fun x -> x ^ "3")] = "hello3"
  ```

# Part 4: Higher Order Functions

Write the following functions using `map`, `fold`, or `fold_right` as defined in the file `funs.ml`. You **must** use `map`, `fold`, or `fold_right` to complete these functions, so *none of the functions in Part 4 may be defined using the `rec` keyword*. 
- You also **may not** create recursive helper functions, You will lose points if this rule is not followed. 
- You **may** create *non-recursive* helper functions as you see fit for all of part 4.
- You **may** use functions created in previous parts, as long as they **do not use recursion**, not even in their own helpers.

#### `is_there lst x`

- **Type**: `'a list -> 'a -> bool`
- **Description**: returns a bool of `x` is in `lst`
- **Examples**:
  ```ocaml
  is_there [1;2;3] 1 = true
  is_there [1;1;0] 0 = true
  is_there [2;0;2] 3 = false
  ```

#### `count_occ lst target`

- **Type**: `'a list -> 'a -> int`
- **Description**: Returns how many elements in `lst` are equal to `target`.
- **Examples**:
  ```ocaml
  count_occ [] 1 = 0
  count_occ [1] 1 = 1
  count_occ [1; 2; 2; 1; 3] 1 = 2
  ```

#### `uniq lst`

- **Type**: `'a list -> 'a list`
- **Description**: Given a list, returns a list with all duplicate elements removed. *Order does not matter in the output list.*
- **Examples**:
  ```ocaml
  uniq [] = []
  uniq [1] = [1]
  uniq [1; 2; 2; 1; 3] = [2; 1; 3]
  ```

#### `every_xth x lst`

- **Type**: `int -> 'a list -> 'a list`
- **Description**: Returns a list of every `x`th value from `lst`
- **Assumptions**: `x` is a positive number >= 1.
- **Examples**:
  ```ocaml
  every_xth 2 [1;2;3;4] = [2;4]
  every_xth 1 [1;2;3;4] = [1;2;3;4]
  every_xth 3 [1;2;3;4] = [3]
  ```

## Academic Integrity

Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. This includes posting this project to GitHub after the course is over. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.
