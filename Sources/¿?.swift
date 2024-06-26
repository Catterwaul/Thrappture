infix operator ¿?: NilCoalescingPrecedence

// MARK: - unusable

// Autoclosures lose error type information as of the time of this writing, June 2024.
// That prevents the overloads in this section from being usable.

/// The "**Error-Coalescing Operator**".
/// - Remark: `shift-option-?` *makes the `¿` symbol.*
public func ¿? <Value, Error>(
  _ value0: @autoclosure () throws -> Value,
  _ value1: @autoclosure () throws(Error) -> Value
) throws(Error) -> Value {
  do {
    return try value0()
  } catch {
    return try value1()
  }
}

/// The "**Error-Coalescing Operator**".
/// - Note: This overload requires both arguments to throw the same error type.
/// - Remark: `shift-option-?` *makes the `¿` symbol.*
public func ¿? <Value, Error>(
  _ value0: @autoclosure () throws(Error) -> Value,
  _ value1: @autoclosure () throws(Error) -> Value
) throws(Error) -> Value {
  do {
    return try value0()
  } catch {
    return try value1()
  }
}

// MARK: - Bug workaround overload

/// The "**Error-Coalescing Operator**".
///
/// The compiler cannot deal with a `¿?` overload where `value1` does not `throw`.
/// 
/// **Workaround**: Use `try?` for those situations:
///   ```swift
///   (try? value0) ?? value1
///   ```
///
/// - Remark: `shift-option-?` *makes the `¿` symbol.*
public func ¿? <Value>(
  _ value0: @autoclosure () throws -> Value,
  _ value1: @autoclosure () throws -> Value
) throws -> Value {
  do {
    return try value0()
  } catch {
    return try value1()
  }
}

/// The "**Error-Coalescing Operator**".
/// - Note: The compiler cannot deal with another overload where `value1` is  not`async`.
///   **Workaround**: When the compiler gains the ability to use sync overloads in an async context,
///   store the intermediate result and use the synchronous version of `??` on it.
public func ¿? <Value>(
  _ value0: @autoclosure () async throws -> Value,
  _ value1: @autoclosure () async throws -> Value
) async throws -> Value {
  do {
    return try await value0()
  } catch {
    return try await value1()
  }
}
