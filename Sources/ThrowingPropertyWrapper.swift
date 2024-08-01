/// A type that could be a property wrapper if `get throws` were supported for `wrappedValue`.
///
/// In addition to what can be represented in the type system,
/// there are many methods which all `ThrowingPropertyWrapper`s have in common,
/// which vary only by the generic representation of `Self`, with various `Value` and `Error` types.
/// See the documentation for a list of those "requirements".
public protocol ThrowingPropertyWrapper<Value, Error> {
  associatedtype Value
  associatedtype Error: Swift.Error

  /// - Note: This method should be the following property, which has equivalent spelling,
  /// [but it doesn't work yet](https://github.com/apple/swift/issues/74290).
  /// ```swift
  /// @inlinable var wrappedValue: Value { get throws(Error) }
  /// ```
  @inlinable func wrappedValue() throws(Error) -> Value
}

// MARK: - public
public extension ThrowingPropertyWrapper {
  /// Modify a wrapped value.
  /// - Parameters:
  ///   - makeResult: arguments: (`errorResult`, `wrappedValue!`)
  /// - Returns: An unmodified value, when `wrappedValue` `throw`s.
  func reduce<Result, Error: Swift.Error>(
    _ errorResult: Result,
    _ makeResult: (_ errorResult: Result, _ wrappedValue: Value) throws(Error) -> Result
  ) throws(Error) -> Result {
    do {
      return try makeResult(errorResult, wrappedValue())
    } catch {
      return errorResult
    }
  }
}
