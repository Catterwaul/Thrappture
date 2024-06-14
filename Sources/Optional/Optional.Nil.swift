public extension Optional {
  /// Represents that an `Optional` was `nil`.
  struct Nil: Swift.Error & Equatable { }
}

// MARK: - ExpressibleByNilLiteral
extension Optional.Nil: ExpressibleByNilLiteral {
  @inlinable public init(nilLiteral: Void) { }
}
