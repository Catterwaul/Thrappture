// MARK: - ThrowingPropertyWrapper
extension Optional: ThrowingPropertyWrapper {
  /// Represents that an `Optional` was `nil`.
  public struct UnwrapError: Swift.Error & Equatable {
    public init() { }
  }

  /// Can't use throws(UnwrapError):
  /// https://github.com/apple/swift/issues/74289
  @inlinable public func wrappedValue() throws -> Wrapped {
    switch self {
    case let wrapped?: return wrapped
    case nil: throw UnwrapError()
    }
  }
}
