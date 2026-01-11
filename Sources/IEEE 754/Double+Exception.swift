// Double+Exception.swift
// swift-ieee-754
//
// Hardware floating-point exception state for Double

// MARK: - Double.Exception Namespace

extension Double {
    /// Hardware floating-point exception state accessor
    ///
    /// Provides access to the CPU's floating-point unit exception flags.
    /// These flags are set automatically by the hardware during floating-point
    /// operations.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// Double.exception.clear()
    /// _ = 1.0 / 0.0  // Raises hardware division by zero
    ///
    /// let state = Double.exception.test()
    /// if state.division {
    ///     print("Division by zero detected")
    /// }
    /// ```
    ///
    /// ## Note
    ///
    /// Float and Double share the same hardware FPU, so `Float.exception.test()`
    /// and `Double.exception.test()` return the same state.
    public enum Exception {}

    /// Hardware floating-point exception accessor
    public static var exception: Exception.Type { Exception.self }
}

// MARK: - Double.Exception.State

extension Double.Exception {
    /// Hardware floating-point exception state (alias for Float.Exception.State)
    ///
    /// Float and Double share the same hardware FPU, so they share the same
    /// State type.
    public typealias State = Float.Exception.State
}

// MARK: - Double.Exception Methods

extension Double.Exception {
    /// Test hardware FPU exception flags
    ///
    /// Queries the CPU's floating-point unit for exception flags.
    /// Delegates to `Float.exception.test()` since they share the same FPU.
    ///
    /// - Returns: Current FPU exception state
    ///
    /// ## Example
    ///
    /// ```swift
    /// let state = Double.exception.test()
    /// if state.overflow {
    ///     print("FPU overflow detected")
    /// }
    /// ```
    @inlinable
    public static func test() -> State {
        Float.exception.test()
    }

    /// Clear hardware FPU exception flags
    ///
    /// Clears all exception flags in the CPU's floating-point unit.
    /// Delegates to `Float.exception.clear()` since they share the same FPU.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Double.exception.clear()
    /// // All hardware FPU exception flags are now clear
    /// ```
    @inlinable
    public static func clear() {
        Float.exception.clear()
    }
}
