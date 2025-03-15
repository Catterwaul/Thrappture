/// A type that could be a property wrapper if `get throws` were supported for `wrappedValue`.
///
/// In addition to what can be represented in the type system,
/// there are many methods which all `ThrowingPropertyWrapper`s have in common,
/// which vary only by the generic representation of `Self`, with various `Value` and `Error` types.
/// See the documentation for a list of those "requirements".
public protocol ThrowingPropertyWrapper<Value, Error> {
  associatedtype Value
  associatedtype Error: Swift.Error

  /// Wrap a value or an error.
  @inlinable init(catching: @autoclosure () throws(Error) -> Value)

  /// The `get` accessor for the wrapped value.
  @inlinable func get() throws(Error) -> Value

  /// The `set` accessor for the wrapped value.
  ///
  /// `set` accessors  are unavailable for properties with throwing `get` accessors,
  /// so this is forced to be a method.
  @inlinable mutating func set(_ newValue: @autoclosure () throws(Error) -> Value)
}

// MARK: - public
public extension ThrowingPropertyWrapper {
  /// Modify a wrapped value.
  /// - Parameters:
  ///   - errorResult: An unmodified value, when `get()` `throw`s.
  @inlinable func reduce<Result, Error: Swift.Error>(
    _ errorResult: Result,
    _ makeResult: (_ errorResult: Result, _ wrappedValue: Value) throws(Error) -> Result
  ) throws(Error) -> Result {
    do { return try makeResult(errorResult, get()) }
    catch { return errorResult }
  }
}
