// MARK: - ThrowingPropertyWrapper
extension Optional: ThrowingPropertyWrapper {
  /// - Bug: [We can't use `throws(UnwrapError)`](https://github.com/apple/swift/issues/74289).
  /// - Throws: `UnwrapError`
  @inlinable public func wrappedValue() throws -> Wrapped {
    switch self {
    case let wrapped?: return wrapped
    case nil: throw nil as UnwrapError
    }
  }
}

// MARK: - public
public extension Optional {
  /// Exchange a tuple of optionals for a single optional tuple.
  /// - Returns: `nil` if any tuple element is `nil`.
  @inlinable static func zip<each Element>(_ optional: (repeat (each Element)?)) -> Self
  where Wrapped == (repeat each Element) {
    try? (repeat (each optional).wrappedValue())
  }
}
