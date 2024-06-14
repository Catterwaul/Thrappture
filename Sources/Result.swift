// MARK: - ThrowingPropertyWrapper
extension Result: ThrowingPropertyWrapper {
  @inlinable public func wrappedValue() throws(Failure) -> Success {
    try get()
  }

  /// Set `self` to `.success(newValue)`.
  public mutating func setWrappedValue(_ newValue: Value) {
    self = .success(newValue)
  }
}

// MARK: - public
public extension Result {
  /// Exchange a tuple of `Results` for a single `Result` whose `Success` is a tuple.
  /// - Returns: `.failure` with the first failure that might occur in a tuple.
  static func zip<each Element>(_ result: (repeat Result<each Element, Failure>)) -> Self
  where Success == (repeat each Element) {
    do {
      return .success((repeat try (each result).wrappedValue()))
    } catch {
      return .failure(error)
    }
  }
}
