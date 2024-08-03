/// A type that could be a property wrapper if `get throws` were supported for `wrappedValue`.
///
/// In addition to what can be represented in the type system,
/// there are many methods which all `ThrowingPropertyWrapper`s have in common,
/// which vary only by the generic representation of `Self`, with various `Value` and `Error` types.
/// See the documentation for a list of those "requirements".
public protocol ThrowingPropertyWrapper<Value, Error> {
  associatedtype Value
  associatedtype Error: Swift.Error

  /// The `get` accessor for the wrapped value.
  @inlinable func get() throws(Error) -> Value

  /// The `set` accessor for the wrapped value.
  @inlinable mutating func set(_ newValue: @autoclosure () throws(Error) -> Value)
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
      return try makeResult(errorResult, get())
    } catch {
      return errorResult
    }
  }
}
