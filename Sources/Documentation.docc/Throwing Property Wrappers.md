# Throwing Property Wrappers

## "Requirements"

In addition to what can be represented in the type system, there are many methods which all `ThrowingPropertyWrapper`s have in common, which vary only by the generic representation of `Self`, with various `Value` and `Error` types.

`mapValue`

`Optional` implements this as ``Optional.map(_:)``.
`Result` implements this as ``mapSuccess``. (The standard library nearly has this, in `map`, but it does not incorporate throwing an error.)


Optional does not have `mapError` overloads, because …wait, maybe??! 


In computer science, zipping is a function which maps a tuple of sequences into a sequence of tuples. This name zip derives from the action of a zipper in that it interleaves two formerly disjoint sequences. The inverse function is unzip.


## Topics

- ``ThrowingPropertyWrapper``


