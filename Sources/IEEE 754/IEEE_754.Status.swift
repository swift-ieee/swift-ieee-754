// IEEE_754.Status.swift
// swift-ieee-754
//
// IEEE 754-2019 Section 7: Exception Status Flags (Functional Style)

extension IEEE_754 {
    /// Exception status flags for functional-style arithmetic
    ///
    /// Unlike ``Exceptions`` which maintains global shared state for hardware FPU integration,
    /// `Status` is designed for functional-style arithmetic where operations return both
    /// a result value and exception status together.
    ///
    /// ## Overview
    ///
    /// This OptionSet represents the five IEEE 754 exception flags that can be accumulated
    /// during arithmetic operations:
    ///
    /// - ``invalid``: Invalid operation (domain error)
    /// - ``divisionByZero``: Division of finite non-zero by zero
    /// - ``overflow``: Result exceeds maximum representable value
    /// - ``underflow``: Non-zero result smaller than minimum normal
    /// - ``inexact``: Rounded result differs from exact result
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let result = a.arithmetic.add(b)
    /// if result.status.contains(.overflow) {
    ///     // Handle overflow
    /// }
    /// if !result.status.isEmpty {
    ///     // At least one exception occurred
    /// }
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``Exceptions``: Global exception state for hardware FPU integration
    /// - ``Outcome``: Pairs a value with its exception status
    /// - IEEE 754-2019 Section 7: Exceptions
    public struct Status: OptionSet, Sendable, Hashable {
        public var rawValue: UInt8

        @inlinable
        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - Exception Flags

extension IEEE_754.Status {
    /// Invalid operation exception (Section 7.2)
    ///
    /// Raised for operations with invalid operands:
    /// - sqrt(-1)
    /// - 0.0 / 0.0
    /// - infinity - infinity
    /// - infinity / infinity
    /// - 0.0 * infinity
    public static let invalid = Self(rawValue: 1 << 0)

    /// Division by zero exception (Section 7.3)
    ///
    /// Raised when dividing a finite non-zero number by zero:
    /// - 1.0 / 0.0 produces infinity
    /// - -1.0 / 0.0 produces -infinity
    public static let divisionByZero = Self(rawValue: 1 << 1)

    /// Overflow exception (Section 7.4)
    ///
    /// Raised when the result magnitude is too large to represent.
    public static let overflow = Self(rawValue: 1 << 2)

    /// Underflow exception (Section 7.5)
    ///
    /// Raised when a non-zero result is too small to represent as normal.
    public static let underflow = Self(rawValue: 1 << 3)

    /// Inexact exception (Section 7.6)
    ///
    /// Raised when the rounded result differs from the exact mathematical result.
    public static let inexact = Self(rawValue: 1 << 4)

    /// No exceptions raised
    public static let none: Self = []
}

// MARK: - Convenience

extension IEEE_754.Status {
    /// Alias for ``divisionByZero`` matching common usage
    public static let divide = Self.divisionByZero
}
