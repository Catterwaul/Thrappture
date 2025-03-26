# ``ThrowingPropertyWrapper``

## "Requirements"

Below, you'll find implementations of similar methods on `Optional` and `Result`. Their "mapping" methods warrant more details:

##### General transformation

Transforming a value, by applying a function to it using dot syntax, is sometimes an easier-to-read way to write code, and probably ought to be available on *every type*: 

```swift
func transform<Transformed, Error>(
  _ transform: (Self) throws(Error) -> Transformed
) throws(Error) -> Transformed {
  try transform(self)
}
```

But that's not specific to throwing property wrappers, and is not included in this package.

We *could* restrict the transformation to require mapping similar types of wrappers, such as `Int?` ➡️ `String?`, or `Result<Int, Never>` ➡️ `Result<String, any Error>`.

###### Result

For `Result`, that would look like this:

```swift
func transform<NewSuccess, NewFailure, Error>(
  _ transform: (Self) throws(Error) -> Result<NewSuccess, NewFailure>
) throws(Error) -> Result<NewSuccess, NewFailure> {
  try transform(self)
}
```

###### Optional

And `Optional`'s equivalent implementation would look like this: 

```swift
func transform<NewWrapped, Error>(
  _ transform: (Self) throws(Error) -> NewWrapped?
) throws(Error) -> NewWrapped? {
  try transform(self)
}
```

Even with this new restriction, the possibilities are so vast in what can be accomplished there, that it's not worth creating a function for. And so again, this `transform` is not included in this package either. 

### flatMap

`flatMap` is the closest to a general-purpose `transform` method that this package works with. The capabilities are different in only two respects: 

1. `flatMap`'s' `transform` closure operates only on a wrapped value, instead of an entire wrapper instance.

2. `flatMap` cannot modify the wrapped error type.

The "`flat`" in `flatMap` refers to the way that it introduces no more "nesting" than the wrapper represented before transformation. For example, `String?.flatMap`, when supplied with a `transform` closure returning type `Int?`, will return `Int?`. (As opposed to `Int??`).

`flatMap` will not throw an error when the wrapper wraps an error, but it will throw an error if the transformation throws an error.

###### Result

[`Result`'s implementation](doc:Swift/Result/flatMap(_:)) is documented below. The standard library nearly gets this right, but [it does not incorporate throwing an error](https://developer.apple.com/documentation/swift/result/flatMap(_:)).

###### Optional

[`Optional.flatMap`](https://developer.apple.com/documentation/swift/optional/flatmap(_:)) is implemented perfectly in the standard library.

[Optional chaining](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/optionalchaining/) represents a specific subset of `flatMap`—the most common use case. It would be great if other throwing property wrappers could use chaining as well, but is of course not supported.
 
```swift
let animals: Optional = "🦁🐯🐻"
var first: Character? = animals.flatMap(\.first)
first = animals?.first // Same as above.
```

### flatMapAndMergeError

This is a special case of `flatMap`. If `transform` throws the untransformed wrapper's `Failure` type, the error can be forwarded into the transformed wrapper type, rather than being thrown from `flatMap`. 

Both forms are useful. Naming this differently than `flatMap` is necessary because it would not be enough, for the compiler, to just add `try` in front of another `flatMap` overload.

###### Result

 [`Result`'s implementation](doc:Swift/Result/flatMapAndMergeError(_:)) is documented below.

###### Optional

We've defined `Optional`'s `Failure` type as [`Nil`](<doc:Swift/Optional/Nil>). But regardless of how you model it, `Optional.none` is generic over `Optional` itself. That means that the only way for two `Optional` types to "share their `Failure` type", is for the `Optional`s to actually be of the exact same type.

So, `flatMapAndMergeError` would be simplifiable to the following. We haven't felt a need to include this in this package, but are open to doing so if you could convince us of its usefulness.

```swift
func flatMapAndMergeError(
  _ transform: (Wrapped) throws(Nil) -> Self
) -> Self {
  try? transform(get())
}
```

### map

The only difference between `flatMap` and `map` is that map's `transform` closure returns a wrapped value, not a wrapper. Thusly, no "flattening" is necessary. 

###### Result

[`Result`'s implementation](doc:Swift/Result/map(_:)) is documented below. The standard library nearly gets this right, but [it does not incorporate throwing an error](https://developer.apple.com/documentation/swift/result/map(_:)).

###### Optional

[`Optional.map`](https://developer.apple.com/documentation/swift/optional/map(_:)) is implemented perfectly in the standard library.

### mapAndMergeError

This is to `map` as `flatMapAndMergeError` is to `flatMap`.

###### Result

[`Result`'s implementation](doc:Swift/Result/mapAndMergeError(_:)) is documented below.

###### Optional

Because Swift allows for values to be implicitly promoted to optionals, the body of `Optional.mapAndMergeError` would be exactly the same as `Optional.flatMapAndMergeError`'s', above. So we're not including this method either.

#### flatMapFailure

This is the same idea as `flatMap`, except, with a transformation of the wrapper's `Failure` type, rather than its `Value` type.

###### Result

As we've seen above with `flatMap` and `map`, the standard library nearly gets this right, under the problematic* name [`flatMapError`](https://developer.apple.com/documentation/swift/result/flatMapError(_:)), but it does not incorporate throwing an error. It *should*, for completeness, but does anyone need that? 🤔 (It won't be included in this package until we hear that they do.)

\* It's problematic because the failure type, while restricted to be an error, is called `Failure`, not `Error`. And it's not clear whether you're mapping a failure enumeration case, or an error occurring from the transformation closure. 

###### Optional

`Optional` cannot make use of this by itself, because its `Failure` type always matches its `Wrapped` type. I.e. transforming one `Optional.Nil` to another is the same as transforming one `Optional` to another. That requires a `flatMap`. And, a transformation of `nil`, if you want to do anything other than change one `nil` into `another`.

You can't do much meaningful using `nil` as an input, but there is syntactical sugar available to "transform it"—the [nil-coalescing operator](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/basicoperators/#Nil-Coalescing-Operator). 

A combination of `flatMap`, nil-coalescing, and implicit promotion to optionals is not only about the closest you can get to `flatMapError` with an `Optional`—it's also a practical usage of the `transform` methods we started off this article with—just with a different spelling.  

```swift
let characters: Optional = "🦁🐯🐻"
let character: Character? = characters.flatMap { "\($0)👧🏻👠🐒🪽".randomElement() } ?? "🧙‍♀️"
```

#### mapFailure

This is to `flatMapFailure` as `map` is to `flatMap`.

#### mapFailureToSuccess

This idea only works when the `Failure` type is going to be "removed", which is represented by `Never`. So, there's no point in offering a `flatMapFailureToSuccess`, as `Result.failure`s can't be created with if their `Failure` is `Never`.

###### Result

[`Result`'s implementation](doc:Swift/Result/mapFailureToSuccess(_:)) is documented below.

###### Optional

This is nil-coalescing, specifically when the result is non-optional.

***Important to note:*** while nil-coalescing allows for completely removing `Optional` wrappers, you'll sometimes need to use `flatMap`, instead of `map`, to flatten optionality down to one level of wrapping, first. 

```swift
let characters: Optional = "🦁🐯🐻👧🏻👠🐒🪽"
characters?.randomElement() ?? "🧙‍♀️"               // Character
characters.flatMap { $0.randomElement() } ?? "🧙‍♀️" // Character
characters.map { $0.randomElement() } ?? "🧙‍♀️"     // Character?
```

#### mapFailureToSuccessAndErrorToFailure

This is a niche type of error mapping operation.  

It's similar to the "`…AndMergeError`"s in that an error thrown from transforming will become a `failure`.

But it's dissimilar in that while the error thrown *can* be `Failure`, there's no requirement of that (and it's likely to be a rare case). So, calling this `mapFailureToSuccessAndMergeError` would not generally be accurate.

###### Result

[`Result`'s implementation](doc:Swift/Result/mapFailureToSuccessAndErrorToFailure(_:)) is documented below.

###### Optional

This is nil-coalescing, when the argument on the right of the `??` is also optional.  

Because `Success` can't change, and `Failure` is tied to `Success`, for `Optional`, `Failure` can't change either.

```swift
let characters: Optional = "🦁🐯🐻👧🏻👠🐒🪽"
let character: Character? = "🧙‍♀️"
characters?.randomElement() ?? character  // Character?
```

## Topics

- ``/ThrowingPropertyWrapper/init(catching:)``
- ``/ThrowingPropertyWrapper/get()``
- ``/ThrowingPropertyWrapper/set(_:)``
- ``/ThrowingPropertyWrapper/reduce(_:_:)``

### zip

- ``Swift/Optional/zip(_:)``
- ``Swift/Result/zip(_:)``

### Result's maps

- ``Swift/Result/flatMap(_:)``
- ``Swift/Result/flatMapAndMergeError(_:)``
- ``Swift/Result/map(_:)``
- ``Swift/Result/mapAndMergeError(_:)``
- ``Swift/Result/mapFailureToSuccess(_:)``
- ``Swift/Result/mapFailureToSuccessAndErrorToFailure(_:)``
