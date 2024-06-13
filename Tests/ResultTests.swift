import Testing
import Thrappture

struct ResultTests {
  @Test func zip() throws {
    typealias Error = String?.UnwrapError
    let jenies: (Result<String, Error>, Result<String, Error>) = (.success("👖"), .success("🧞‍♂️"))

    #expect(
      try Result.zip(jenies).wrappedValue() == ("👖", "🧞‍♂️")
    )

    // `jenies` should be have been `var`,
    // and these blocks should not be necessary, but
    // https://github.com/apple/swift/issues/74425
    do {
      var jenies = jenies
      jenies.1 = .failure(nil)
      do {
        let jenies = jenies
        #expect(throws: Error.self) {
          try Result.zip(jenies).wrappedValue()
        }
      }
    }
  }
}
