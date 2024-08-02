# Throwing Property Wrappers

## "Requirements"

In addition to what can be represented in the type system, there are many methods which all `ThrowingPropertyWrapper`s have in common, which vary only by the generic representation of `Self`, with various `Value` and `Error` types.

##### "map"

##### "mapValue"

* `Optional` implements this as [`map`](https://developer.apple.com/documentation/swift/optional/map(_:)).

* `Result` implements this as [`mapSuccess`](<doc:Swift/Result/mapSuccess(_:)>). (The standard library nearly has this, in [`map`](https://developer.apple.com/documentation/swift/result/map(_:)), but it does not incorporate throwing an error.)

###### ?.

[Optional chaining](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/optionalchaining/) represents a specific subset of `mapValue`—the most common use case. It would be great for `Result` as well, but is of course not supported.

##### "mapError"

* `Optional` does not need this, because its `Error` type always matches its `Wrapped` type. (I.e. [`Nil`](<doc:Swift/Optional/Nil>) is generic over `Optional` itself.) Transforming one `Optional.Nil` to another is the same as transforming one `Optional` to another, which is just [`map`](https://developer.apple.com/documentation/swift/optional/map(_:)), or the . 

* `Result` implements this as [`mapError`](https://developer.apple.com/documentation/swift/optional/mapError(_:)). (…Which, like its [`map`](https://developer.apple.com/documentation/swift/result/map(_:)), also does not incorporate throwing an error. It *should*, for completeness, but does anyone need that? 🤔).


--- 


In computer science, zipping is a function which maps a tuple of sequences into a sequence of tuples. This name zip derives from the action of a zipper in that it interleaves two formerly disjoint sequences. The inverse function is unzip.


## Topics

- ``ThrowingPropertyWrapper``


