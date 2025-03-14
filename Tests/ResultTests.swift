import Testing
import Thrappture

struct ResultTests {
  @Test func maps() throws {
    enum Failure: Error { case failure }
    let intResult = Result<_, Failure>.success(1)

    func transform(_ value: Int) throws(Failure) -> String {
      if value >= 100 { "💯" } else { throw .failure }
    }
    #expect(try intResult.mapValue { $0 + 1 }.get() == 2)
    #expect(throws: Failure.failure) { try intResult.mapValue(transform) }
    #expect(throws: Failure.failure, performing: intResult.flatMapValue(transform).get)

    #expect(throws: Double?.Nil.self) {
      try intResult.flatMap { get in
        do { return try transform(get()) }
        catch { throw nil as Double?.Nil }
      }.get()
    }
  }

  @Test func zip() throws {
    let jenies = (
      Result<_, String?.Nil>.success("👖"),
      Result<_, String?.Nil>.success("🧞‍♂️")
    )

    #expect(
      try Result.zip(jenies).get() == ("👖", "🧞‍♂️")
    )

    // `jenies` should be have been `var`,
    // and these blocks should not be necessary, but
    // https://github.com/apple/swift/issues/74425
    do {
      var jenies = jenies
      jenies.1 = .failure(nil)
      do {
        let jenies = jenies
        #expect(throws: String?.Nil.self) {
          try Result.zip(jenies).get()
        }
      }
    }
  }
}
