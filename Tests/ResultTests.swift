import Testing
import Thrappture

struct ResultTests {
  @Test func assignmentOperator() throws {
    let value = "🪕"

    var result = Result<_, Never?.Nil>.success(value)

    let failure = Result<String, _>.failure(Never?.nil)
    try? result.setWrappedValue(failure.wrappedValue())
    #expect(try result.wrappedValue() == value)

    var success = "🎻"
    try? success = result.wrappedValue()
    #expect(success == value)
  }

  @Test func maps() throws {
    enum Failure: Error { case failure }
    let intResult = Result<_, Failure>.success(1)
    #expect(throws: Failure.failure) {
      try intResult.mapSuccess { success throws(Failure) in
        if success >= 100 { "💯" } else { throw .failure }
      }
    }

  }

  @Test func reduce() {
    var arrayResult = Result<[Int], Void?.Nil>.failure(nil)
    let array: [Int] = [1, 2]

    #expect(
      arrayResult.reduce(array) { $1 + $0 } == array
    )

    arrayResult.setWrappedValue([0])
    #expect(
      arrayResult.reduce(array) { $1 + $0 } == [0, 1, 2]
    )
  }

  @Test func zip() throws {
    let jenies = (
      Result<String, String?.Nil>.success("👖"),
      Result<String, String?.Nil>.success("🧞‍♂️")
    )

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
        #expect(throws: String?.nil) {
          try Result.zip(jenies).wrappedValue()
        }
      }
    }
  }
}
