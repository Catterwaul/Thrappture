import Testing
import Thrappture

struct GetMutatingSetTests {
  @Test func setWrappedValue() {
    var property = GetMutatingSet(wrappedValue: 0)
    #expect(property.wrappedValue() == 0)
    property.setWrappedValue(1)
    #expect(property.wrappedValue() == 1)
  }

  @Test func map() throws {
    struct Error1: Error { }
    var boolError1 = GetMutatingSet<_, Error1>(wrappedValue: true)
    #expect(try boolError1.mapValue { String($0) }.wrappedValue() == "true")

    boolError1 = boolError1.map { _ throws(_) in throw Error1() }
    struct Error2: Error { }
    let boolError2 = boolError1.mapError { _ in Error2() }
    #expect(throws: Error2.self, performing: boolError2.wrappedValue)
  }
}
