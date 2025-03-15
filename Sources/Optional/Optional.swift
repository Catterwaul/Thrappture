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

  @inlinable public mutating func set(_ newValue: @autoclosure () throws(Error) -> Value) {
    self = try? newValue()
  }
}

// MARK: - public
public extension Optional {
  /// Exchange a tuple of `Optional`s for a single `Optional` whose `Wrapped` is a tuple.
  /// - Returns: `nil` if any tuple element is `nil`.
  @inlinable static func zip<each _Wrapped>(_ optional: (repeat (each _Wrapped)?)) -> Self
  where Wrapped == (repeat each _Wrapped) {
    try? (repeat (each optional).get())
  }

  /// Transform `.some` into `.none`, if a condition fails.
  /// - Parameters:
  ///   - isSome: The condition that will result in `nil`, when evaluated to `false`.
  func filter<Error>(_ isSome: (Wrapped) throws(Error) -> Bool) throws(Error) -> Self {
    try flatMap { wrapped throws(Error) in try isSome(wrapped) ? wrapped : nil }
  }
}
