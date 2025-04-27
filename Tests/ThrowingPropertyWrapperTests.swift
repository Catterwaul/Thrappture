import Testing
import Thrappture

struct ThrowingPropertyWrapperTests {
  @Test func accessors() throws {
    func test<Wrapper: ThrowingPropertyWrapper<String, any Error>>(
      _: Wrapper.Type
    ) {
      let value = "🪕"
      var wrapper = Wrapper(catching: value)
      let failure = ResultOptional<String>.nil
      wrapper.set(try failure.get())
      #expect(throws: String?.Nil.self, performing: wrapper.get)
      var success = "🎻"
      try? success = wrapper.get()
      #expect(success == "🎻")
      wrapper.set(value)
      try? success = wrapper.get()
      #expect(success == value)
    }
    test(Optional.self)
    test(Result.self)
  }

  @Test func reduce() {
    func test(nil: consuming some ThrowingPropertyWrapper<Int, some Error>) {
      func reduce() -> Int { `nil`.reduce(1, +) }
      #expect(reduce() == 1)
      `nil`.set(2)
      #expect(reduce() == 3)
    }
    test(nil: nil as Int?)
    test(nil: Result.nil)
  }
}

private typealias ResultOptional<Wrapped> = Result<Wrapped, Wrapped?.Nil>
extension ResultOptional where Failure == Success?.Nil {
  @inlinable static var `nil`: Self { .failure(nil) }
}
