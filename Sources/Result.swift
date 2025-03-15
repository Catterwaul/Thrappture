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
  @inlinable static func zip<each _Success>(
    _ result: (repeat Result<each _Success, Failure>)
  ) -> Self
  where Success == (repeat each _Success) {
    .init { () throws(_) in (repeat try (each result).get()) }
  }
  
  /// Transform success values.
  /// - Throws: `Error`. If you instead want it to be stored in the new `Result`'s  `failure`,
  /// you'll need ``flatMapAndMergeError(_:)``.
  @inlinable func flatMap<NewSuccess: ~Copyable, Error>(
    _ transform: (Success) throws(Error) -> Result<NewSuccess, Failure>
  ) throws(Error) -> Result<NewSuccess, Failure> {
    switch self {
    case .success(let success): try transform(success)
    case .failure(let failure): .failure(failure)
    }
  }

  /// Transform success values.
  ///
  /// If `transform` throws an error, it will be stored in a `.failure`.
  /// If you want to throw the error instead,  you'll need ``flatMap(_:)``.
  /// - Note: Naming this differently than `flatMap` is necessary because it would not be enough,
  /// for the compiler, to just add `try` in front of another `flatMap` overload.
  @inlinable func flatMapAndMergeError<NewSuccess: ~Copyable>(
    _ transform: (Success) throws(Failure) -> Result<NewSuccess, Failure>
  ) -> Result<NewSuccess, Failure> {
    do { return try transform(get()) }
    catch { return .failure(error) }
  }

  /// Transform success values.
  /// - Throws: `Error`. If you want to store the error in a `.failure` instead,
  /// you'll need ``mapAndMergeError(_:)``.
  @inlinable func map<NewSuccess: ~Copyable, Error>(
    _ transform: (Success) throws(Error) -> NewSuccess
  ) throws(Error) -> Result<NewSuccess, Failure> {
    switch self {
    case .success(let success): .success(try transform(success))
    case .failure(let failure): .failure(failure)
    }
  }

  /// Transform success values.
  ///
  /// If `transform` throws an error, it will be stored in a `.failure`.
  /// If you want to throw the error instead,  you'll need ``map(_:)``.
  /// - Note: Naming this differently than `map` is necessary because it would not be enough,
  /// for the compiler, to just add `try` in front of another `map` overload.
  @inlinable func mapAndMergeError<NewSuccess: ~Copyable>(
    _ transform: (Success) throws(Failure) -> NewSuccess
  ) -> Result<NewSuccess, Failure> {
    .init { () throws(_) in try transform(get()) }
  }
}
