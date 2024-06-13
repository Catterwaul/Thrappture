// MARK: - ThrowingPropertyWrapper
extension Result: ThrowingPropertyWrapper {
  @inlinable public func wrappedValue() throws(Failure) -> Success {
    try get()
  }

  public mutating func setWrappedValue(_ newValue: Value) {
    self = .success(newValue)
  }
}
