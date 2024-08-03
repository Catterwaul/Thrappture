// MARK: - ThrowingPropertyWrapper
extension Result: ThrowingPropertyWrapper {
  @inlinable public mutating func set(_ newValue: @autoclosure () throws(Error) -> Value) {
    self = .init(catching: newValue)
  }
}

// MARK: - public
public extension Result {
  /// Exchange a tuple of `Result`s for a single `Result` whose `Success` is a tuple.
  /// - Returns: `.failure` with the first failure that might occur in a tuple.
  @inlinable static func zip<each Element>(_ result: (repeat Result<each Element, Failure>)) -> Self
  where Success == (repeat each Element) {
    .init { () throws(_) in (repeat try (each result).get()) }
  }
  
  /// Transform success values.
  /// - Throws: `Error`. If you instead want it to be stored in the new `Result`'s  `failure`,
  /// use ``flatMapValue(_:)`` or ``flatMap(_:)``.
  @inlinable func mapValue<NewValue: ~Copyable, Error>(
    _ transform: (Success) throws(Error) -> NewValue
  ) throws(Error) -> Result<NewValue, Failure> {
    switch self {
    case .success(let success): .success(try transform(success))
    case .failure(let failure): .failure(failure)
    }
  }

  /// Transform success values.
  ///
  /// If `transform` throws an error, it will be stored in a `.failure`.
  /// This is possible because the `Failure` type cannot change using this method.
  ///
  /// If you need to change the error type as well, you'll need ``flatMap(_:)``,
  /// because the type system cannot guarantee that you'll deal with this type's `Failure`  via `transform`.
  @inlinable func flatMapValue<NewSuccess: ~Copyable>(
    _ transform: (Success) throws(Failure) -> NewSuccess
  ) -> Result<NewSuccess, Failure> {
    .init { () throws(_) in try transform(get()) }
  }

  typealias Get = () throws(Failure) -> Success

  /// Transform results into new results.
  /// 
  /// This is a functionality superset of ``flatMapValue(_:)``,
  /// adding the capability to transform errors as well.
  /// - Parameter transform: Processes this `Result`'s `get`.
  @inlinable func flatMap<NewSuccess: ~Copyable, NewFailure>(
    _ transform: (Get) throws(NewFailure) -> NewSuccess
  ) -> Result<NewSuccess, NewFailure> {
    .init { () throws(_) in try transform(get) }
  }
}
