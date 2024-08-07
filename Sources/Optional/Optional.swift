// MARK: - ThrowingPropertyWrapper
extension Optional: ThrowingPropertyWrapper {
  @inlinable public init(catching value: @autoclosure () throws -> Wrapped) {
    self = try? value()
  }
  
  /// The `get` accessor for the wrapped value.
  /// - Bug: [We can't use `throws(UnwrapError)`](https://github.com/apple/swift/issues/74289).
  /// Until that is fixed, `Optional.Error` remains `any Error`, not `Nil`, as it should be.
  /// - Throws: `Nil`
  @inlinable public func get() throws -> Wrapped {
    switch self {
    case let wrapped?: return wrapped
    case nil: throw nil as Nil
    }
  }

  @inlinable public mutating func set(_ newValue: @autoclosure () throws(Error) -> Value) {
    self = try? newValue()
  }
}

// MARK: - public
public extension Optional {
  /// Exchange a tuple of `Optional`s for a single `Optional` whose `Wrapped` is a tuple.
  /// - Returns: `nil` if any tuple element is `nil`.
  @inlinable static func zip<each Element>(_ optional: (repeat (each Element)?)) -> Self
  where Wrapped == (repeat each Element) {
    try? (repeat (each optional).get())
  }
}
