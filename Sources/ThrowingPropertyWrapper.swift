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
  ///   - defaultValue: An unmodified value, when `get()` `throw`s.
  ///   - combine: Use the wrapped value to create another value of the same type as `defaultValue`.
  @inlinable func reduce<Transformed, Error: Swift.Error>(
    _ defaultValue: Transformed,
    _ combine: (_ errorValue: Transformed, _ wrappedValue: Value) throws(Error) -> Transformed
  ) throws(Error) -> Transformed {
    do { return try combine(defaultValue, get()) }
    catch { return defaultValue }
  }
}
