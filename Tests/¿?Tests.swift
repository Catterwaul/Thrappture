import Testing
import Thrappture

struct ErrorCoalescingOperatorTests {
  @Test func errorCoalescing() throws {
    let none: Bool? = .none
    #expect(try none.get() ¿? true)
    #expect(throws: Bool?.Nil.self) {
      try none.get() ¿? none.get()
    }

    struct Error1: Error { }
    #expect(throws: Error1.self) {
      try none.get() ¿? Error1().throw()
    }

    struct Error2: Error { }
    #expect(throws: Error2.self) {
      try none.get() ¿? Error1().throw() ¿? Error2().throw()
    }
  }

  @Test func asyncErrorCoalescing() async {
    struct Error: Swift.Error { }
    await #expect(throws: Error.self) {
      func `throw`() async throws(Error) {
        throw .init()
      }
      try await (try await `throw`()) ¿? (try await `throw`())
    }
  }
}
