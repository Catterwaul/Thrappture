// MARK: - public
public extension Task {
  /// Modify a success value.
  /// - Parameters:
  ///   - errorResult: An unmodified value, when `value` `throw`s.
  @inlinable func reduce<Result, Error: Swift.Error>(
    _ errorResult: Result,
    _ makeResult: (_ errorResult: Result, _ value: Success) throws(Error) -> Result
  ) async throws(Error) -> Result {
    do { return try await makeResult(errorResult, value) }
    catch { return errorResult }
  }

}

// MARK: -
// An overload is currently needed for each of the only two error types that `Task` currently supports:
// `Never`, and `any Error`.
// The only difference between the overloads is `try`,
// which would generate a warning if used in the `Never` overloads.

public extension Task where Failure == Never {
  /// Transform success values.
  @inlinable func mapValue<NewSuccess>(
    _ transform: sending @escaping @isolated(any) (Success) throws(Failure) -> NewSuccess
  ) -> Task<NewSuccess, Failure> {
    .init { () throws(_) in await transform(value) }
  }

  /// Exchange a tuple of `Task`s for a single `Task` whose `Success` is a tuple.
  /// - Throws: The first failure that might occur in a tuple.
  @inlinable static func zip<each Element>(_ result: (repeat Task<each Element, Failure>)) -> Self
  where Success == (repeat each Element) {
    .init { () throws(_) in await (repeat (each result).value) }
  }
}

public extension Task where Failure == any Error {
  /// Transform success values.
  @inlinable func mapValue<NewSuccess>(
    _ transform: sending @escaping @isolated(any) (Success) throws(Failure) -> NewSuccess
  ) -> Task<NewSuccess, Failure> {
    .init { () throws(_) in try await transform(value) }
  }

  /// Exchange a tuple of `Task`s for a single `Task` whose `Success` is a tuple.
  /// - Throws: The first failure that might occur in a tuple.
  @inlinable static func zip<each Element>(_ result: (repeat Task<each Element, Failure>)) -> Self
  where Success == (repeat each Element) {
    .init { () throws(_) in await (repeat try (each result).value) }
  }
}
