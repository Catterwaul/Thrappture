public extension Error {
  /// `throw` this from a function, instead of returning a value.
  func `throw`<Never>() throws -> Never { throw self }
}
