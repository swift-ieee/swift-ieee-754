// IEEE_754.Rounding.Mode.swift
// swift-ieee-754
//
// IEEE 754-2019 Section 4.3: Rounding Mode for Arithmetic Operations

extension IEEE_754.Rounding {
    /// Rounding mode for arithmetic operations
    ///
    /// Represents the seven commonly used rounding modes for floating-point arithmetic.
    /// The five IEEE 754-2019 standard modes are: ``positive``, ``negative``, ``zero``,
    /// ``nearest``, and ``away``. Two additional modes are included for completeness:
    /// ``magnitude`` (round away from zero) and ``toward`` (ties toward zero).
    ///
    /// ## IEEE 754 Standard Modes
    ///
    /// | Mode | IEEE 754 Name | Description |
    /// |------|---------------|-------------|
    /// | ``nearest`` | roundTiesToEven | Default mode, ties to even |
    /// | ``away`` | roundTiesToAway | Ties away from zero |
    /// | ``positive`` | roundTowardPositive | Toward +∞ (ceiling) |
    /// | ``negative`` | roundTowardNegative | Toward -∞ (floor) |
    /// | ``zero`` | roundTowardZero | Toward zero (truncate) |
    ///
    /// ## Extended Modes
    ///
    /// | Mode | Description |
    /// |------|-------------|
    /// | ``magnitude`` | Away from zero (all values, not just ties) |
    /// | ``toward`` | Ties toward zero |
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let result = a.arithmetic.add(b, rounding: .nearest)
    /// let truncated = c.arithmetic.divide(d, rounding: .zero)
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``Direction``: Hierarchical enum for roundToIntegral operations
    /// - IEEE 754-2019 Section 4.3.1: Rounding-direction attributes
    public enum Mode: Sendable, Hashable, CaseIterable {
        /// Round toward positive infinity (ceiling)
        ///
        /// IEEE 754: roundTowardPositive
        case positive

        /// Round toward negative infinity (floor)
        ///
        /// IEEE 754: roundTowardNegative
        case negative

        /// Round toward zero (truncate)
        ///
        /// IEEE 754: roundTowardZero
        case zero

        /// Round away from zero (magnitude up)
        ///
        /// Always moves away from zero regardless of exactness.
        /// Not a standard IEEE 754 mode but commonly supported.
        case magnitude

        /// Round to nearest, ties to even (banker's rounding)
        ///
        /// IEEE 754: roundTiesToEven (default mode)
        ///
        /// When the exact result is exactly halfway between two representable values,
        /// rounds to the one with an even least significant digit.
        case nearest

        /// Round to nearest, ties away from zero
        ///
        /// IEEE 754: roundTiesToAway
        ///
        /// When the exact result is exactly halfway between two representable values,
        /// rounds away from zero.
        case away

        /// Round to nearest, ties toward zero
        ///
        /// When the exact result is exactly halfway between two representable values,
        /// rounds toward zero. Not a standard IEEE 754 mode but supported for
        /// compatibility with some decimal arithmetic specifications.
        case toward
    }
}

// MARK: - Default Mode

extension IEEE_754.Rounding.Mode {
    /// The default rounding mode (ties to even)
    ///
    /// IEEE 754-2019 specifies roundTiesToEven as the default rounding mode.
    public static var `default`: Self { .nearest }
}
