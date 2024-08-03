# ``ThrowingPropertyWrapper/get()``

- Note: This method could instead be the following property, which has equivalent spelling, [but that doesn't work yet](https://github.com/apple/swift/issues/74290).

```swift
@inlinable var wrappedValue: Value { get throws(Error) }
```
