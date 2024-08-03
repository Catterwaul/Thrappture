public extension Optional {
  /// An error that represents that an `Optional` was `nil`.
  struct Nil: Swift.Error & Equatable {
    @available(*, unavailable) private init() { }
  }
}

// MARK: - ExpressibleByNilLiteral
extension Optional.Nil: ExpressibleByNilLiteral {
  @inlinable public init(nilLiteral: Void) { }
}
