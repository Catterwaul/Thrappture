# Notes on Conversion

## Typed Throws and Return Values

#### Result

Typed throws make it so you don't need to return `Result`s anymore, to propagate typed errors.

**Old:**

```swift
enum MatéError: Swift.Error { case 🧉 }
func string() -> Result<String, MatéError> { .failure(.🧉) }
```

**New:**

```swift
func string() throws(MatéError) -> String { throw .🧉 }
```

*This tip is not specific to Thrappture, but is relevant.*

#### Optional

[Optional.Nil](<doc:Swift/Optional/Nil>) makes this possible for optionals, as well. Use it in the cases when you consider a `nil` return to be an error.

```swift
func string() -> String? { nil }
func string() throws(String?.Nil) -> String { throw nil }
```

## Assignment

Swift doesn't offer a very concise way to assign wrapped values of optionals to other values. 

```swift
if let optional { value = optional }
```

That is not terrible, but `Result` offers better.

```swift
try? value = result.get() 
```

This package [adds `get` to `Optional`](<doc:Swift/Optional/get()>), allowing for the same syntax that `Result` offers.    
