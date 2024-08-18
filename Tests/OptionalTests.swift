import Testing
import Thrappture

struct OptionalTests {
  @Test func filter() throws {
    let optional: Optional = 1
    #expect(optional.filter { $0 > 0 } == 1)
    #expect(optional.filter { $0 > 1 } == nil)
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
      #expect(throws: (String, String)?.Nil.self) {
        try _?.zip(jenies).get()
      }
    }
  }
}
