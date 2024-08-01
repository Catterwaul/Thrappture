// MARK: - ThrowingPropertyWrapper
extension Result: ThrowingPropertyWrapper {
  @inlinable public func wrappedValue() throws(Failure) -> Success {
    try get()
  }

  /// Set `self` to `.success(newValue)`.
  ///
  /// This would just be the assignment operator,
  /// if `Result` were actually a property wrapper.
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
  
  /// Transform success values.
  /// - Throws: `Error`. If you instead want it to be stored in the new `Result`'s  `failure`,
  /// use ``flatMapSuccess(_:)`` or ``flatMap(_:)``.
  func mapSuccess<NewSuccess, Error>(
    _ transform: (Success) throws(Error) -> NewSuccess
  ) throws(Error) -> Result<NewSuccess, Failure> {
    switch self {
    case .success(let success): .success(try transform(success))
    case .failure(let failure): .failure(failure)
    }
  }
}
