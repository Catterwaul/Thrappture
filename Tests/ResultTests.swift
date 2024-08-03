import Testing
import Thrappture

struct ResultTests {
  @Test func maps() throws {
    enum Failure: Error { case failure }
    let intResult = Result<_, Failure>.success(1)
    #expect(throws: Failure.failure) {
      try intResult.mapSuccess { success throws(Failure) in
        if success >= 100 { "💯" } else { throw .failure }
      }
    }

  }



  }

  @Test func zip() throws {
    let jenies = (
      Result<String, String?.Nil>.success("👖"),
      Result<String, String?.Nil>.success("🧞‍♂️")
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
