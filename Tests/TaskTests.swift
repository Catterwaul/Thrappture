import Testing
import Thrappture

struct TaskTests {
  @Test func maps() async throws {
    enum Failure: Error { case failure }
    let intTask = Task<_, any Error> { 1 }

    func transform(_ value: Int) throws(Failure) -> String {
      if value >= 100 { "💯" } else { throw .failure }
    }
    #expect(try await intTask.mapValue { $0 + 1 }.value == 2)
//    #expect(throws: Failure.failure, performing: intResult.flatMapValue(transform).get)
//
//    #expect(throws: Double?.Nil.self) {
//      try intResult.flatMap { get in
//        do { return try transform(get()) }
//        catch { throw nil as Double?.Nil }
//      }.get()
//    }
  }

  @Test func reduce() async {
    enum Failure: Error { case failure }
    var task = Task<Int, _> { throw Failure.failure }
    func reduce() async -> Int { await task.reduce(1, +) }
    #expect(await reduce() == 1)
    task = .init { 2 }
    #expect(await reduce() == 3)
  }

  @Test func zip() async {
    let jenies = (Task { "👖" }, Task { "🧞‍♂️" })
    #expect(
      try await Task.zip(jenies).value == ("👖", "🧞‍♂️")
    )
  }

  @Test func zip_async() async throws {
    let jenies = (
      Task<_, any Error> { "👖" },
      Task { throw nil as String?.Nil }
    )
    await #expect(throws: String?.Nil.self) {
      try await Task.zip(jenies).value
    }
  }
}
