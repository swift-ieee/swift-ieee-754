// IEEE_754.Exceptions.Raised.swift
// swift-ieee-754
//
// Raised exception accessor for IEEE 754 exceptions

extension IEEE_754.Exceptions {
    /// Accessor for querying raised exception flags
    ///
    /// Provides a structured way to query which exception flags are currently raised.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Check if any exception is raised
    /// if IEEE_754.Exceptions.raised.any {
    ///     print("At least one exception occurred")
    /// }
    ///
    /// // Get all raised flags
    /// let flags = IEEE_754.Exceptions.raised.flags
    /// for flag in flags {
    ///     print("Raised: \(flag)")
    /// }
    /// ```
    public struct Raised: Sendable {
        @usableFromInline
        internal init() {}
    }

    /// Accessor for raised exception flags
    public static var raised: Raised { Raised() }
}

// MARK: - Raised Properties

extension IEEE_754.Exceptions.Raised {
    /// True if any exception flag is currently raised
    @inlinable
    public var any: Bool {
        IEEE_754.Exceptions.Flag.allCases.contains { IEEE_754.Exceptions.test($0) }
    }

    /// Array of all currently raised exception flags
    @inlinable
    public var flags: [IEEE_754.Exceptions.Flag] {
        IEEE_754.Exceptions.Flag.allCases.filter { IEEE_754.Exceptions.test($0) }
    }
}
