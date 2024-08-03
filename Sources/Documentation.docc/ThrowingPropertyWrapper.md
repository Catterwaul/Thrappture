# ``ThrowingPropertyWrapper``

## "Requirements"

Below, you'll find implementations of similar pairs of methods on `Optional` and `Result`. Some of them warrant more details:

##### mapValue

* `Optional` implements this as [`map`](https://developer.apple.com/documentation/swift/optional/map(_:)).

* `Result` implementation is documented below. (The standard library nearly has this, as [`map`](https://developer.apple.com/documentation/swift/result/map(_:)), but it does not incorporate throwing an error.)

##### mapError

* `Optional` does not need this, because its `Error` type always matches its `Wrapped` type. (I.e. [`Nil`](<doc:Swift/Optional/Nil>) is generic over `Optional` itself.) Transforming one `Optional.Nil` to another is the same as transforming one `Optional` to another.  

* [`Result` implements this](https://developer.apple.com/documentation/swift/result/mapError(_:)). Like  [`map`](https://developer.apple.com/documentation/swift/result/map(_:)), this also does not incorporate throwing an error. It *should*, for completeness, but does anyone need that? 🤔

##### flatMapValue

* `Optional` implements this as [`flatMap`](https://developer.apple.com/documentation/swift/optional/map(_:)).

* `Result`'s implementation is documented below. (The standard library has a similar method, [`flatMap`](https://developer.apple.com/documentation/swift/result/flatMap(_:)), which returns a `Result`, rather than returning a value or throwing an error.)

[Optional chaining](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/optionalchaining/) represents a specific subset of `flatMapValue`—the most common use case. It would be great if other throwing property wrappers could use chaining as well, but is of course not supported.

##### flatMap

* Because you can't do much meaningful with a `nil`, the use cases for `Optional` having a full conversion method are covered by a combination of `map` and [nil-coaslescing](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/basicoperators/#Nil-Coalescing-Operator).
 
```swift
let optional: Optional = "🦁🐯🐻"
optional.map { $0 + "👧🏻"} ?? "🧝‍♀️🐲🧙‍♂️"
```

* `Result`'s implementation is documented below.

##### "map"?

The signature for a hypothetical `map` would be similar to `flatMap`. But an error would be thrown from `map` itself, as with `mapValue`. 

Without that error being part of the return type, like in `flatMap`, there would be no need to return any type in particular, whereas all the other forms of `map` have restrictions which cause them to have to return some kind of transformed wrapper.

```swift
func map<Transformed, Error>(
  _ transform: (Self) throws(Error) -> Transformed
) throws(Error) -> Transformed {
  try transform(self)
}
```

That's a useful method, which probably ought to be available on *every type*. But it's not specific to throwing property wrappers, and is not included in this package. 

## Topics

- ``/ThrowingPropertyWrapper/init(catching:)``
- ``/ThrowingPropertyWrapper/get()``
- ``/ThrowingPropertyWrapper/set(_:)``
- ``/ThrowingPropertyWrapper/reduce(_:_:)``

### zip

- ``Swift/Optional/zip(_:)``
- ``Swift/Result/zip(_:)``

### Result's maps

- ``Swift/Result/mapValue(_:)``
- ``Swift/Result/flatMapValue(_:)``
- ``Swift/Result/flatMap(_:)``
