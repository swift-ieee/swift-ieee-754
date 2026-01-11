// IEEE_754.Outcome.swift
// swift-ieee-754
//
// IEEE 754-2019 Section 7: Functional Result with Exception Status

extension IEEE_754 {
    /// Result of an arithmetic operation paired with exception status
    ///
    /// `Outcome` enables functional-style arithmetic where operations return both
    /// the computed value and any exception status flags, rather than relying on
    /// global state or hardware FPU flags.
    ///
    /// ## Overview
    ///
    /// Unlike traditional approaches that use global exception state, `Outcome`
    /// encapsulates the result and status together:
    ///
    /// ```swift
    /// let result = a.arithmetic.add(b)
    /// print(result.value)   // The computed sum
    /// print(result.status)  // Any exceptions that occurred
    /// ```
    ///
    /// ## Checking Status
    ///
    /// ```swift
    /// let result = a.arithmetic.divide(b)
    ///
    /// // Check for specific exceptions
    /// if result.status.contains(.divisionByZero) {
    ///     // Handle division by zero
    /// }
    ///
    /// // Check if any exception occurred
    /// if !result.status.isEmpty {
    ///     // Handle exceptional case
    /// }
    ///
    /// // Check for clean operation
    /// if result.status == .none {
    ///     // Operation completed without exceptions
    /// }
    /// ```
    ///
    /// ## Chaining Operations
    ///
    /// Status flags can be accumulated across operations:
    ///
    /// ```swift
    /// let r1 = a.arithmetic.add(b)
    /// let r2 = r1.value.arithmetic.multiply(c)
    /// let combined = r1.status.union(r2.status)
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``Status``: Exception status flags
    /// - IEEE 754-2019 Section 7: Exceptions
    public struct Outcome<Value: Sendable>: Sendable {
        /// The result value of the operation
        public let value: Value

        /// Exception status flags from the operation
        public let status: Status

        /// Creates an outcome with a value and status
        ///
        /// - Parameters:
        ///   - value: The result value
        ///   - status: Exception status flags (defaults to none)
        @inlinable
        public init(value: Value, status: Status = .none) {
            self.value = value
            self.status = status
        }
    }
}

// MARK: - Convenience Initializers

extension IEEE_754.Outcome {
    /// Creates an outcome representing a clean operation (no exceptions)
    ///
    /// - Parameter value: The result value
    @inlinable
    public static func clean(_ value: Value) -> Self {
        Self(value: value, status: .none)
    }
}

// MARK: - Status Inspection

extension IEEE_754.Outcome {
    /// Whether any exception occurred during the operation
    @inlinable
    public var exceptions: Bool {
        !status.isEmpty
    }

    /// Whether the operation completed without exceptions
    @inlinable
    public var clean: Bool {
        status.isEmpty
    }
}

// MARK: - Equatable

extension IEEE_754.Outcome: Equatable where Value: Equatable {}

// MARK: - Hashable

extension IEEE_754.Outcome: Hashable where Value: Hashable {}
