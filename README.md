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
