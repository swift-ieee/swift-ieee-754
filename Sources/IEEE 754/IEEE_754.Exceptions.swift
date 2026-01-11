// IEEE_754.Exceptions.swift
// swift-ieee-754
//
// IEEE 754-2019 Section 7: Exception Handling
// Authoritative implementations for IEEE 754 exception flags

public import Synchronization

#if canImport(CIEEE754)
    import CIEEE754
#endif

// MARK: - IEEE 754 Exception Handling

extension IEEE_754 {
    /// IEEE 754 Exception Handling (Section 7)
    ///
    /// Implements the five exception flags defined in IEEE 754-2019 Section 7.
    ///
    /// ## Overview
    ///
    /// The IEEE 754 standard defines five exceptional conditions that can occur
    /// during floating-point operations:
    ///
    /// - **Invalid Operation**: Domain errors (e.g., sqrt(-1), 0/0, ∞-∞)
    /// - **Division by Zero**: Finite non-zero ÷ zero
    /// - **Overflow**: Result too large to represent
    /// - **Underflow**: Non-zero result too small to represent as normal
    /// - **Inexact**: Rounded result differs from exact mathematical result
    ///
    /// ## Thread Safety
    ///
    /// Exception state is maintained in a thread-safe shared store using Swift's
    /// Synchronization.Mutex (Foundation-free). All operations are atomic and safe
    /// to call from multiple threads.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Test exception flags
    /// if IEEE_754.Exceptions.test(.invalid) {
    ///     print("Invalid operation detected")
    /// }
    ///
    /// // Clear all flags
    /// IEEE_754.Exceptions.clear()
    ///
    /// // Clear specific flag
    /// IEEE_754.Exceptions.clear(.overflow)
    ///
    /// // Check if any exception is raised
    /// if IEEE_754.Exceptions.raised.any {
    ///     print("Some exception occurred")
    /// }
    /// ```
    ///
    /// ## Limitations
    ///
    /// Swift's standard floating-point operations do not raise IEEE 754 exceptions.
    /// This implementation provides:
    /// - Manual exception flag setting for user operations
    /// - Thread-local exception state storage
    /// - Query and clear operations
    ///
    /// To integrate with actual operations, wrap arithmetic operations with
    /// result checking and manual flag raising.
    ///
    /// ## See Also
    ///
    /// - IEEE 754-2019 Section 7: Exceptions
    /// - IEEE 754-2019 Section 8: Alternate exception handling attributes
    public enum Exceptions {}
}

// MARK: - Exception Flag Type

extension IEEE_754.Exceptions {
    /// IEEE 754 Exception Flags
    ///
    /// Hierarchical structure for the five IEEE 754 exception types.
    ///
    /// ## Exception Types
    ///
    /// - `invalid`: Invalid operation (domain error)
    /// - `divisionByZero`: Division of finite non-zero by zero
    /// - `overflow`: Result exceeds maximum representable value
    /// - `underflow`: Non-zero result smaller than minimum normal
    /// - `inexact`: Rounded result differs from exact result
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Raise an exception
    /// IEEE_754.Exceptions.raise(.invalid)
    ///
    /// // Test for exception
    /// if IEEE_754.Exceptions.test(.overflow) {
    ///     // Handle overflow
    /// }
    /// ```
    ///
    /// ## See Also
    ///
    /// - IEEE 754-2019 Section 7.2: Invalid operation
    /// - IEEE 754-2019 Section 7.3: Division by zero
    /// - IEEE 754-2019 Section 7.4: Overflow
    /// - IEEE 754-2019 Section 7.5: Underflow
    /// - IEEE 754-2019 Section 7.6: Inexact
    public enum Flag: Sendable, Equatable, CaseIterable {
        /// Invalid operation exception (IEEE 754-2019 Section 7.2)
        ///
        /// Raised for operations with invalid operands, such as:
        /// - sqrt(-1)
        /// - 0.0 / 0.0
        /// - ∞ - ∞
        /// - ∞ / ∞
        /// - 0.0 * ∞
        /// - Invalid conversions
        case invalid

        /// Division by zero exception (IEEE 754-2019 Section 7.3)
        ///
        /// Raised when dividing a finite non-zero number by zero:
        /// - 1.0 / 0.0 → +∞
        /// - -1.0 / 0.0 → -∞
        case divisionByZero

        /// Overflow exception (IEEE 754-2019 Section 7.4)
        ///
        /// Raised when the result magnitude is too large to represent:
        /// - Double.greatestFiniteMagnitude * 2.0
        /// - exp(1000)
        case overflow

        /// Underflow exception (IEEE 754-2019 Section 7.5)
        ///
        /// Raised when a non-zero result is too small to represent as normal:
        /// - Double.leastNormalMagnitude / 2.0
        /// - Results in subnormal range
        case underflow

        /// Inexact exception (IEEE 754-2019 Section 7.6)
        ///
        /// Raised when the result differs from the exact mathematical result:
        /// - 1.0 / 3.0 (cannot be represented exactly)
        /// - Any operation requiring rounding
        case inexact
    }
}

// MARK: - Flag CustomStringConvertible

extension IEEE_754.Exceptions.Flag: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalid: return "invalid"
        case .divisionByZero: return "divisionByZero"
        case .overflow: return "overflow"
        case .underflow: return "underflow"
        case .inexact: return "inexact"
        }
    }
}

// MARK: - Thread-Local Exception State

extension IEEE_754.Exceptions {
    /// Exception state container
    @usableFromInline
    final class ExceptionState: @unchecked Sendable {
        @usableFromInline
        struct Flags {
            var invalid: Bool = false
            var divisionByZero: Bool = false
            var overflow: Bool = false
            var underflow: Bool = false
            var inexact: Bool = false
        }

        @usableFromInline
        let state: Mutex<Flags> = Mutex(Flags())

        @usableFromInline
        init() {}
    }

    /// Global shared exception state
    ///
    /// Uses Swift 6.0 Synchronization.Mutex for Foundation-free thread safety.
    /// For true thread-local storage, use the CIEEE754 C target which provides
    /// pthread-based TLS on supported platforms.
    @usableFromInline
    static let sharedState = ExceptionState()
}

// MARK: - ExceptionState Methods

extension IEEE_754.Exceptions.ExceptionState {
    @usableFromInline
    func set(_ flag: IEEE_754.Exceptions.Flag) {
        state.withLock { flags in
            switch flag {
            case .invalid: flags.invalid = true
            case .divisionByZero: flags.divisionByZero = true
            case .overflow: flags.overflow = true
            case .underflow: flags.underflow = true
            case .inexact: flags.inexact = true
            }
        }
    }

    @usableFromInline
    func clear(_ flag: IEEE_754.Exceptions.Flag) {
        state.withLock { flags in
            switch flag {
            case .invalid: flags.invalid = false
            case .divisionByZero: flags.divisionByZero = false
            case .overflow: flags.overflow = false
            case .underflow: flags.underflow = false
            case .inexact: flags.inexact = false
            }
        }
    }

    @usableFromInline
    func get(_ flag: IEEE_754.Exceptions.Flag) -> Bool {
        state.withLock { flags in
            switch flag {
            case .invalid: return flags.invalid
            case .divisionByZero: return flags.divisionByZero
            case .overflow: return flags.overflow
            case .underflow: return flags.underflow
            case .inexact: return flags.inexact
            }
        }
    }

    @usableFromInline
    func clearAll() {
        state.withLock { flags in
            flags.invalid = false
            flags.divisionByZero = false
            flags.overflow = false
            flags.underflow = false
            flags.inexact = false
        }
    }
}

// MARK: - Exception Operations

extension IEEE_754.Exceptions {
    /// Raise an exception flag
    ///
    /// Sets the specified exception flag.
    ///
    /// - Parameter flag: The exception flag to raise
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Exceptions.raise(.invalid)
    /// ```
    ///
    /// Note: This operation is thread-safe.
    public static func raise(_ flag: Flag) {
        sharedState.set(flag)

        #if canImport(CIEEE754)
            // Also raise in C thread-local storage for consistency
            let cFlag: IEEE754ExceptionFlag
            switch flag {
            case .invalid: cFlag = IEEE754_EXCEPTION_INVALID
            case .divisionByZero: cFlag = IEEE754_EXCEPTION_DIVBYZERO
            case .overflow: cFlag = IEEE754_EXCEPTION_OVERFLOW
            case .underflow: cFlag = IEEE754_EXCEPTION_UNDERFLOW
            case .inexact: cFlag = IEEE754_EXCEPTION_INEXACT
            }
            ieee754_raise_exception(cFlag)
        #endif
    }

    /// Test if an exception flag is raised
    ///
    /// Checks whether the specified exception flag is currently set.
    ///
    /// - Parameter flag: The exception flag to test
    /// - Returns: true if the flag is raised, false otherwise
    ///
    /// Example:
    /// ```swift
    /// if IEEE_754.Exceptions.test(.overflow) {
    ///     print("Overflow occurred")
    /// }
    /// ```
    public static func test(_ flag: Flag) -> Bool {
        #if canImport(CIEEE754)
            // Check C thread-local storage (preferred if available)
            let cFlag: IEEE754ExceptionFlag
            switch flag {
            case .invalid: cFlag = IEEE754_EXCEPTION_INVALID
            case .divisionByZero: cFlag = IEEE754_EXCEPTION_DIVBYZERO
            case .overflow: cFlag = IEEE754_EXCEPTION_OVERFLOW
            case .underflow: cFlag = IEEE754_EXCEPTION_UNDERFLOW
            case .inexact: cFlag = IEEE754_EXCEPTION_INEXACT
            }
            return ieee754_test_exception(cFlag) != 0 || sharedState.get(flag)
        #else
            return sharedState.get(flag)
        #endif
    }

    /// Clear an exception flag
    ///
    /// Resets the specified exception flag.
    ///
    /// - Parameter flag: The exception flag to clear
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Exceptions.clear(.overflow)
    /// ```
    public static func clear(_ flag: Flag) {
        sharedState.clear(flag)

        #if canImport(CIEEE754)
            // Also clear in C thread-local storage
            let cFlag: IEEE754ExceptionFlag
            switch flag {
            case .invalid: cFlag = IEEE754_EXCEPTION_INVALID
            case .divisionByZero: cFlag = IEEE754_EXCEPTION_DIVBYZERO
            case .overflow: cFlag = IEEE754_EXCEPTION_OVERFLOW
            case .underflow: cFlag = IEEE754_EXCEPTION_UNDERFLOW
            case .inexact: cFlag = IEEE754_EXCEPTION_INEXACT
            }
            ieee754_clear_exception(cFlag)
        #endif
    }

    /// Clear all exception flags
    ///
    /// Resets all five exception flags to their initial (unraised) state.
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Exceptions.clear()
    /// ```
    public static func clear() {
        sharedState.clearAll()

        #if canImport(CIEEE754)
            // Also clear C thread-local storage
            ieee754_clear_all_exceptions()
        #endif
    }

}

// MARK: - Compatibility Properties

extension IEEE_754.Exceptions {
    /// Check if invalid operation exception is raised
    @inlinable
    public static var invalidOperation: Bool {
        test(.invalid)
    }

    /// Check if division by zero exception is raised
    @inlinable
    public static var divisionByZero: Bool {
        test(.divisionByZero)
    }

    /// Check if overflow exception is raised
    @inlinable
    public static var overflow: Bool {
        test(.overflow)
    }

    /// Check if underflow exception is raised
    @inlinable
    public static var underflow: Bool {
        test(.underflow)
    }

    /// Check if inexact exception is raised
    @inlinable
    public static var inexact: Bool {
        test(.inexact)
    }
}
