# TacO
A 2D Tac-It Language.

## Basics

TacO is a strange approach to language design, combining a 2D Language with a Taccing one, the code runs as interconnected chains.

The firsts and most important character is the `@`. It designates where the program should "Start".

From here, the code repeatedly branches out, chaining together all the functions in adjecency, before eventually running it.
```
@p1
```
The above program is very simply, it just prints a 1. And as can be seen, the order of actions may be backwards to what many programmers are used to.
Firstly, the IP starts at `@`, then it moves directly to the `p`, but doesn't do anything yet. Afterwards, it moves to the `1`, which will act as `p`'s arguments. Anything past the `1` would be one of `1`'s arguments. And so on.

Arguments do have an order, in particular, Left, Up, Right, then Down. When the IP reaches a branch, it will stretch out each of these paths in this order, and use each of these branches as arguments.
```
 2
1p3
 @
```
Prints `1	2	3`

Branches can also intercect with eachother, but not themselves. Take the following example.
```
@p#
 #1
```
Now things have started getting a bit confusing, but just hold on tight.

This program prints `1	1`

The `#` doesn't do anything, and that's intentional.

When the program gets to the `p`, there's a branching, but the program won't just do loops, instead, it cuts off if it's "explored" before. So the two branches look like the following to the program, when unwrapped.
```
p#1#
#
1
#
```
Note that both the 1 and the trailing no-op are used by both program. So this might cause unexpected behaviour.





## Arithmatic

Positive Arithmatic, That is, `+, *, ^` and so on, can generally be implemented by a combination of `+` and amounts of `*`.

Adding any amount of numbers is done through the `+` command. So 1+1 can be written as:
```
@+1
 1
```
But because of how Branches work, you can also pipe together a bunch of arguments, like:
```
@+##########
 1 1 1 1 1 1
```
Which would give 6.

The `*` command, runs the second branch the first input times. So:
```
@*6
 p
 1
```
Will print 6 1s, followed by newlines.

To multiply two numbers, we need a combination of `+` and `*`.
```
*5
3
```
Gives 3 fives on the branch. We sum that up, and we get 3*5=15. So
```
+*5
 3
```
Gives `sum(repeat(5,3))`, or 15.

To raise a number to the power another, things get a bit more complicated. However, squaring is relatively simple.
```
@+**2
   5

@+*#
  #5
```
These two programs both square `5`. The first does so by first repeating `5`, `2` times. Putting `5 5` on the branch. Then, the next `*` repeats `5`, `5` times. Putting `5, 5, 5, 5, 5` on the branch. Then, the `+` sums it.

## Strings and Lists.

In TacO, a string is just a list of UTF-8 bytes. _(There is no char construct)_.
Constructing a list of numbers will make it implicitly print as a string of characters. For example.
```
@l#########
  1 1 1 1 7
  1 0 0 0 2
  1 8 8 1
```
The above script places the numbers 72, 101, 108, 108 then 111 into a list via the `l` character. Which is then printed as the word `Hello`.

The more appropriate method to write this string however is:
```
@"Hello"
```
Like most langauges, escape characters such as `\n` work, and like most 2d languages, the string is constructed in the last direction of the branch.

```
@
p
"Hello, World"
```
Is incorrect, and will result in the compile stage soft-crashing.
```
@
p
"
H
e
l
l
o
,

W
o
r
l
d
"
```
Is more correct. As is:
```
@
p"Hello, World!"
```

Although flat number lists are the most common type of list, a list can also hold other lists. Make of that what you will.

## Conditionals, Looping, and Input

Conditionals are the simplest form of actual branching. The conditional character `?` takes an input variable, and two branches. If the variable is truthy, use branch one, otherwise, use branch two.
```
 1
@?"True"
 "
 F
 a
 l
 s
 e
 "
```
The above code is a branching statement, if `1` is truthy, it will return `"True"`, otherwise, it will return `"False"`

These _have_ to be branches, that is,
```
  1 2 3
#?#####
```

Won't return `2` if `1` is truthy and `3` otherwise, instead it wont return anything.

The `i` character gets input, and can optionally take a number argument to get the `n`th input. This is important, because in a loop, all the inputs are moved over by one.

Assume the number 3 is on the command line.
```
@i
```
Will print that 3.
If `3` and `2` are on the command lines, then they can be acessed with `i` or `i1` and `i2`.

The looping construct is `%`. If this construct is passed a number on the first branch, it will loop through all numbers from 1 to `n`, running the second branch, passing that currently iterated number to the input. If it's passed a list, it will iterate through all the elements of the list, passing their elements.
```
@%5
 i
```
The above code prints numbers 1-5. The `5` is the first branch of the looping construct, so it runs the second branch, which just contains `i`, 5 times, giving `i` numbers 1 - 5.

You can still access those lower inputs, as they were just pushed to the right. For example.
```
@%i
 +/
 i
 2
```
The above code loops through all numbers from 1-i, and adds i to them. For the input 3, the output is `4, 5, 6`. The self referenced `i` by the second branch gets the current iteration, the `i2` gets the initial input.

## All the Functions

* `@`: The IP start point. Only one per program, please.
* `+`: Sums all the inputs, and returns as a single number/list.
* `*`: Take a single number from the first branch. If there's a second branch, run that the first number times, otherwise, just return the second value on the first branch repeated the first value times.
* `0-9`: All numbers push themselves concatenated to the front of it's arguments. `@1#2` pushes `12`, for example.
* `<^>v`: Branch restrictors, can only branch in the direction they point.
* `#`: Intentional no-op. Does absolutely nothing.
* `p`: Write all arguments (Separated by tabs) to STDOUT, followed by a newline.
* `w`: Write all arguments, concatenated together, to STDOUT.
* `j`: Concatenate a list or strings(lists) (second arguemnt), separated by the first argument.
* `i`: Get the first argument numbered input, or the first if none is specified. In a loop, the iterator is first.
* `-`: Subtract all the arguments, in order. Return the output.
* `n`: Try to convert a list to a number.
* `s`: Get a list representation of a number.
* `g`: Get the value at index (second argument) of the list in the first argument.
* `?`: If the first return value of the first branch is truthy, execute the second one, else, optionally execute the third.
* `%`: Take the first return value of the first branch. If it's a list, execute the second branch with each value of the list. If it's a number, execute the second branch with each number 1-n.