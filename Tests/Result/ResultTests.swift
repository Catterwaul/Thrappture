import HMError
import Testing

struct ResultTests {
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
