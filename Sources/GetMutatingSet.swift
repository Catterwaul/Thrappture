/// A workaround for limitations of Swift's computed properties.
///
/// Limitations of Swift's computed property accessors:
/// 1. They are not mutable.
/// 2. They cannot be referenced as closures.

/// - Note: Cannot use `@propertyWrapper` because
/// 1. "Property wrappers currently cannot define an 'async' or 'throws' accessor"
/// 2. "'set' accessor is not allowed on property with 'get' accessor that is 'async' or 'throws'"
public struct GetMutatingSet<Value, Error: Swift.Error> {
  public init(projectedValue: @escaping () throws(Error) -> Value) {
    self.projectedValue = projectedValue
  }

  public var projectedValue: () throws(Error) -> Value
}

// MARK: - public
public extension GetMutatingSet {
  init(wrappedValue: Value) {
    self.init { wrappedValue }
  }

  func wrappedValue() throws(Error) -> Value {
    try projectedValue()
  }

  mutating func setWrappedValue(_ newValue: Value) {
    projectedValue = { newValue }
  }

  /// A new wrapper around transformed `wrappedValue`s and `Error`s.
  @inlinable func map<NewValue, NewError>(
    _ transform: @escaping (() throws(Error) -> Value) throws(NewError) -> NewValue
  ) -> GetMutatingSet<NewValue, NewError> {
    .init { () throws(NewError) in try transform(projectedValue) }
  }

  /// A new wrapper around transformed `wrappedValue`s.
  @inlinable func mapValue<NewValue>(
    _ transform: @escaping (Value) throws(Error) -> NewValue
  ) -> GetMutatingSet<NewValue, Error> {
    .init { () throws(Error) in try transform(wrappedValue()) }
  }

  /// A new wrapper around transformed `Error`s.
  @inlinable func mapError<NewError>(
    _ transform: @escaping (Error) -> NewError
  ) -> GetMutatingSet<Value, NewError> {
    .init { () throws(NewError) -> Value in
      do throws(Error) {
        return try wrappedValue()
      } catch {
        throw transform(error)
      }
    }
  }
}

public extension GetMutatingSet where Error == Never {
  init(wrappedValue: Value) {
    self.init { wrappedValue }
  }
}

// MARK: - ThrowingPropertyWrapper
extension GetMutatingSet: ThrowingPropertyWrapper { }
