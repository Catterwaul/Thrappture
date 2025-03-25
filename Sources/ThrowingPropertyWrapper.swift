/// A type that could be a property wrapper if `get throws` were supported for `wrappedValue`.
///
/// In addition to what can be represented in the type system,
/// there are many methods which all `ThrowingPropertyWrapper`s have in common,
/// which vary only by the generic representation of `Self`, with various `Success` and `Failure` types.
/// See the documentation for a list of those "requirements".
public protocol ThrowingPropertyWrapper<Success, Failure> {
  associatedtype Success
  associatedtype Failure: Error

  /// Wrap a value or an error.
  @inlinable init(catching: @autoclosure () throws(Failure) -> Success)

  /// The `get` accessor for the wrapped value.
  @inlinable func get() throws(Failure) -> Success

  /// The `set` accessor for the wrapped value.
  ///
  /// `set` accessors  are unavailable for properties with throwing `get` accessors,
  /// so this is forced to be a method.
  @inlinable mutating func set(_ newValue: @autoclosure () throws(Failure) -> Success)
}

// MARK: - public
public extension ThrowingPropertyWrapper {
  /// Modify a wrapped value.
  /// - Parameters:
  ///   - defaultValue: An unmodified value, when `get()` `throw`s.
  ///   - combine: Use the wrapped value to create another value of the same type as `defaultValue`.
  @inlinable func reduce<Transformed, Error: Swift.Error>(
    _ defaultValue: Transformed,
    _ combine: (_ errorValue: Transformed, _ wrappedValue: Success) throws(Error) -> Transformed
  ) throws(Error) -> Transformed {
    do { return try combine(defaultValue, get()) }
    catch { return defaultValue }
  }
}
