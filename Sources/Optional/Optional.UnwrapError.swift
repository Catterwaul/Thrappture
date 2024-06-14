public extension Optional {
  /// Represents that an `Optional` was `nil`.
  struct UnwrapError: Swift.Error & Equatable { }
}

// MARK: - ExpressibleByNilLiteral
extension Optional.UnwrapError: ExpressibleByNilLiteral {
  @inlinable public init(nilLiteral: Void) { }
}
