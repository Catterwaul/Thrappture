import Testing


/// Express what it would be like if `Optional` and `Result` were property wrappers,
/// using `GetMutatingSet` as a proxy.
@Test func exhibitHypotheticalSyntax() throws {
  let value = "🪕"

  Optional: do {
    // @GetMutatingSet var optional = value
    var optional = GetMutatingSet<_, String?.Nil>(wrappedValue: value)

    // optional = value
    optional.setWrappedValue(value)

    // let none: String? = nil
    let none: GetMutatingSet<String, _> = nil

    // try? optional = none
    try? optional.setWrappedValue(none.wrappedValue())
    #expect(try optional.wrappedValue() == value)

    var some = "🎻"
    // try? some = optional
    try? some = optional.wrappedValue()
    #expect(some == value)
  }

  Result: do {
    struct Error: Swift.Error { }
    // @GetMutatingSet<_, Error> var result = value
    var result = GetMutatingSet<_, Error>(wrappedValue: value)

    // result = value
    result.setWrappedValue(value)

    var failure = result
    // $failure = { throw Error() }
    failure.projectedValue = { () throws(Error) in throw .init() }

    // try? result = failure
    try? result.setWrappedValue(failure.wrappedValue())
    #expect(try result.wrappedValue() == value)

    var success = "🎻"
    // try? success = result
    try? success = result.wrappedValue()
    #expect(success == value)
  }
}

// MARK: -

extension GetMutatingSet: @retroactive ExpressibleByNilLiteral where Error == Value?.Nil {
  public init(nilLiteral: Void) {
    self.init { () throws(Error) in throw nil  }
  }

//  init(_ value: Value) {
//    self.init { value }
//  }
}
