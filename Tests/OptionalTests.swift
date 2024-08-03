import Testing
import Thrappture

struct OptionalTests {
  @Test func assignmentOperator() throws {
    let value = "🪕"

    var optional: Optional = value

    try? optional = .none.get()
    _ = try #require(optional)

    var some = "🎻"
    try? some = optional.get()
    #expect(some == value)
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
        try _?.zip(jenies).get()
      }
    }
  }
}
