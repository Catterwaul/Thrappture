# ``Thrappture``

Treat `Optional` and `Result` like the throwing property wrappers they are.

* Property wrappers cannot throw. 
* `Optional` and `Result` are not property wrappers.

This package imagines what life would be like if those statements were not true. 🤩

---

#### What's a "Throwing Property Wrapper"?

Some types are conceptually just wrappers around a value, giving it additional behavior. Swift uses [property wrappers](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties/#Property-Wrappers) to represent these types. 

But while throwing errors from properties is supported, throwing errors from a property wrapper's `wrappedValue` property, specifically, is not (yet). That's what a "throwing property wrapper" would employ. 

### Optional and Result should be throwing property wrappers.

`Optional` and `Result` both predate property wrappers, but it's the right model for them, and we should embrace that as much as possible.

While we can't actually *turn them* into throwing property wrappers, thinking of them that way enables aids with understanding the helpful utilities found in this package. 

#### Optional

`Optional` acts *halfway* to being a property wrapper.

You can ***set*** an optional to what would be its "`"wrappedValue`".

```swift
var value: Optional = 1
value = 2
```

But there is no mechanism in place to assign an optional to an instance of its wrapped value.

```swift
let newValue: Int = value // Value of optional type 'Int?' must be unwrapped to a value of type 'Int'
```

And it's as if `Optional` somehow had an overloaded `wrappedValue` `set` accessor to match that, because you can also ***set*** an optional to be another optional.

```swift
value = .some(3)
value = nil
```

Property wrappers deal with that kind of conflation by using *projected values*, by way of "`$`" syntax. If `Optional` were a throwing property wrapper, the syntax would be this, instead:

```swift
@Optional var value = 1
value = 2
$value = .some(3)
$value = nil
let newValue: Int = try value
```

What would that last line throw? [Optional.Nil](<doc:Swift/Optional/Nil>).

#### Result

`Result` doesn't have the conflation problem that `Optional` does, but that's because it doesn't offer any syntactic sugar.

If `Result` were a throwing property wrapper, the syntax for a "`Result` version" of the previous example would be this:

```swift
@Result<_, Int?.Nil> var value = 1
value = 2
$value = .success(3)
$value = .failure(nil)
let newValue: Int = try value
```

---

### Usage Examples

You've got the source code, so aside from reading this documentation, see the **Tests** folder for example usage! 😺

## Topics

- <doc:Notes-on-Conversion>
- ``ThrowingPropertyWrapper``
