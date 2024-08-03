// MARK: - ThrowingPropertyWrapper
extension Optional: ThrowingPropertyWrapper {
  /// The `get` accessor for the wrapped value.
  /// - Bug: [We can't use `throws(UnwrapError)`](https://github.com/apple/swift/issues/74289).
  /// Until that is fixed, `Optional.Error` remains `any Error`, not `Nil`, as it should be.
  /// - Throws: `Nil`
  @inlinable public func get() throws -> Wrapped {
    switch self {
    case let wrapped?: return wrapped
    case nil: throw Self.nil
    }
  }

  @inlinable public mutating func set(_ newValue: @autoclosure () throws(Error) -> Value) {
    self = try? newValue()
  }
}

// MARK: - public
public extension Optional {
  /// Exchange a tuple of optionals for a single optional tuple.
  /// - Returns: `nil` if any tuple element is `nil`.
  @inlinable static func zip<each Element>(_ optional: (repeat (each Element)?)) -> Self
  where Wrapped == (repeat each Element) {
    try? (repeat (each optional).get())
  }
}
