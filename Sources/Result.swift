// MARK: - ThrowingPropertyWrapper
extension Result: ThrowingPropertyWrapper {
  @inlinable public mutating func set(_ newValue: @autoclosure () throws(Error) -> Value) {
    self = .init(catching: newValue)
  }
}

// MARK: - public
public extension Result {
  /// Exchange a tuple of `Results` for a single `Result` whose `Success` is a tuple.
  /// - Returns: `.failure` with the first failure that might occur in a tuple.
  @inlinable static func zip<each Element>(_ result: (repeat Result<each Element, Failure>)) -> Self
  where Success == (repeat each Element) {
    do {
      return .success((repeat try (each result).get()))
    } catch {
      return .failure(error)
    }
  }
  
  /// Transform success values.
  /// - Throws: `Error`. If you instead want it to be stored in the new `Result`'s  `failure`,
  /// use ``flatMapSuccess(_:)`` or ``flatMap(_:)``.
  @inlinable func mapSuccess<NewSuccess: ~Copyable, Error>(
    _ transform: (Success) throws(Error) -> NewSuccess
  ) throws(Error) -> Result<NewSuccess, Failure> {
    switch self {
    case .success(let success): .success(try transform(success))
    case .failure(let failure): .failure(failure)
    }
  }
}
