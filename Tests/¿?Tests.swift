import Testing
import Thrappture

struct ErrorCoalescingOperatorTests {
  @Test func errorCoalescing() throws {
    let none: Bool? = .none
    #expect(try none.wrappedValue() ¿? true)
    #expect(throws: Bool?.Nil.self) {
      try none.wrappedValue() ¿? none.wrappedValue()
    }

    struct Error1: Error { }
    #expect(throws: Error1.self) {
      try none.wrappedValue() ¿? Error1().throw()
    }

    struct Error2: Error { }
    #expect(throws: Error2.self) {
      try none.wrappedValue() ¿? Error1().throw() ¿? Error2().throw()
    }
  }
}
