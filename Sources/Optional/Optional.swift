// MARK: - ThrowingPropertyWrapper
extension Optional: ThrowingPropertyWrapper {
  @inlinable public init(catching value: @autoclosure () throws(Error) -> Wrapped) {
    self = try? value()
  }
  
  /// The `get` accessor for the wrapped value.
  /// - Bug: [We can't use `throws(Nil)`](https://github.com/apple/swift/issues/74289).
  /// Until that is fixed, `Optional.Error` remains `any Error`, not `Nil`, as it should be.
  /// - Throws: `Nil`
  @inlinable public func get() throws -> Wrapped {
    switch self {
    case let wrapped?: return wrapped
    case nil: throw nil as Nil
    }
  }

  @inlinable public mutating func set(_ newValue: @autoclosure () throws(Error) -> Wrapped) {
    self = try? newValue()
  }
}
