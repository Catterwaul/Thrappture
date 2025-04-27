// MARK: - ThrowingPropertyWrapper
extension Result: ThrowingPropertyWrapper {
  @inlinable public mutating func set(_ newValue: @autoclosure () throws(Failure) -> Success) {
    self = .init(catching: newValue)
  }
}
