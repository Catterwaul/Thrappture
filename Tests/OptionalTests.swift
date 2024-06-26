import Testing
import Thrappture

struct OptionalTests {
  @Test func assignmentOperator() throws {
    let value = "🪕"

    var optional: Optional = value

    try? optional = .none.wrappedValue()
    _ = try #require(optional)

    var some = "🎻"
    try? some = optional.wrappedValue()
    #expect(some == value)
  }

  @Test func reduce() {
    var int: Int? = nil
    #expect(int.reduce(1, +) == 1)

    int = 2
    #expect(int.reduce(1, +) == 3)
  }

  @Test func zip() throws {
    let jenies = ("👖", "🧞‍♂️")
    #expect(try #require(Optional.zip(jenies)) == jenies)

    // `jenies` should be have been `var`,
    // and this block should not be necessary, but
    // https://github.com/apple/swift/issues/74425
    do {
      var optionalJenies: (_?, _?) = jenies
      optionalJenies.1 = nil
      let jenies = optionalJenies
      #expect(throws: (String, String)?.nil) {
        try _?.zip(jenies).wrappedValue()
      }
    }
  }
}
