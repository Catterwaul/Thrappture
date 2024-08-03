import Testing
import Thrappture

struct WrapperTests {
  @Test func reduce() {
    let `nil` = nil as Int?
    test(errorWrapper: `nil`)
    test(errorWrapper: Result(catching: `nil`.get))

    func test(errorWrapper: consuming some ThrowingPropertyWrapper<Int, any Error>) {
      func reduce() -> Int { errorWrapper.reduce(1, +) }
      #expect(reduce() == 1)
      errorWrapper.set(2)
      #expect(reduce() == 3)
    }
  }
}
