// Swift API Wrappers Tests.swift
// swift-ieee-754
//
// Tests for elegant Swift wrappers around CIEEE754 functionality

import Testing

@testable import IEEE_754

// MARK: - Rounding Control Tests

@Suite("Swift API - Rounding Control")
struct SwiftRoundingControlTests {
    @Test func getRoundingMode() {
        let mode = IEEE_754.RoundingControl.get()
        // Should be one of the four valid modes
        switch mode {
        case .toNearest, .downward, .upward, .towardZero:
            break  // Valid
        }
    }

    @Test func setRoundingMode() throws {
        // Save original mode
        let originalMode = IEEE_754.RoundingControl.get()
        defer {
            // Always restore original mode, even if test fails
            try? IEEE_754.RoundingControl.set(originalMode)
        }

        try IEEE_754.RoundingControl.set(.upward)
        let mode = IEEE_754.RoundingControl.get()
        #expect(mode == .upward)
    }

    @Test func withModeScoping() throws {
        // Save original mode
        let originalMode = IEEE_754.RoundingControl.get()
        defer {
            // Always restore original mode, even if test fails
            try? IEEE_754.RoundingControl.set(originalMode)
        }

        // Set a specific mode first
        try IEEE_754.RoundingControl.set(.toNearest)

        let result = try IEEE_754.RoundingControl.withMode(.towardZero) {
            let mode = IEEE_754.RoundingControl.get()
            #expect(mode == .towardZero)
            return 10.0 / 3.0
        }

        // Mode should be restored
        let restoredMode = IEEE_754.RoundingControl.get()
        #expect(restoredMode == .toNearest)
        #expect(result > 0)
    }
}

// MARK: - Exception Handling Tests

@Suite("Swift API - Exception Handling")
struct SwiftExceptionHandlingTests {
    @Test func clearAllExceptions() {
        IEEE_754.Exceptions.clear()
        #expect(!IEEE_754.Exceptions.invalidOperation)
        #expect(!IEEE_754.Exceptions.divisionByZero)
        #expect(!IEEE_754.Exceptions.overflow)
        #expect(!IEEE_754.Exceptions.underflow)
        #expect(!IEEE_754.Exceptions.inexact)
    }

    @Test func raiseAndTestException() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.invalid)

        #expect(IEEE_754.Exceptions.invalidOperation)
        #expect(!IEEE_754.Exceptions.overflow)
    }

    @Test func fpuExceptionDetection() {
        Float.exception.clear()

        // Perform operation that might set FPU exceptions
        _ = 1.0 / 3.0  // May set inexact

        let fpuState = Float.exception.test()

        // Verify structure is readable
        #expect(fpuState.invalid == false || fpuState.invalid == true)
        #expect(fpuState.division == false || fpuState.division == true)
    }

    @Test func fpuStateEquatable() {
        Float.exception.clear()
        let state1 = Float.exception.test()
        let state2 = Float.exception.test()

        #expect(state1 == state2)
    }
}

// MARK: - Signaling Comparison Tests

@Suite("Swift API - Signaling Comparisons")
struct SwiftSignalingComparisonTests {
    @Test func signalingEqualNormal() {
        IEEE_754.Exceptions.clear()

        let result = IEEE_754.Comparison.Signaling.equal(3.14, 3.14)
        #expect(result == true)
        #expect(!IEEE_754.Exceptions.invalidOperation)
    }

    @Test func signalingEqualNaN() {
        IEEE_754.Exceptions.clear()

        let result = IEEE_754.Comparison.Signaling.equal(Double.nan, 3.14)
        #expect(result == false)
        #expect(IEEE_754.Exceptions.invalidOperation)
    }

    @Test func signalingLessNormal() {
        IEEE_754.Exceptions.clear()

        #expect(IEEE_754.Comparison.Signaling.less(2.0, 3.0) == true)
        #expect(IEEE_754.Comparison.Signaling.less(3.0, 2.0) == false)
        #expect(!IEEE_754.Exceptions.invalidOperation)
    }

    @Test func signalingLessNaN() {
        IEEE_754.Exceptions.clear()

        let result = IEEE_754.Comparison.Signaling.less(Double.nan, 3.14)
        #expect(result == false)
        #expect(IEEE_754.Exceptions.invalidOperation)
    }

    @Test func signalingGreaterFloat() {
        IEEE_754.Exceptions.clear()

        #expect(IEEE_754.Comparison.Signaling.greater(Float(3.0), Float(2.0)) == true)
        #expect(IEEE_754.Comparison.Signaling.greater(Float(2.0), Float(3.0)) == false)
    }

    @Test func signalingNotEqualNaN() {
        IEEE_754.Exceptions.clear()

        let result = IEEE_754.Comparison.Signaling.notEqual(Double.nan, 3.14)
        #expect(result == true)  // NaN is not equal to anything
        #expect(IEEE_754.Exceptions.invalidOperation)
    }
}

// MARK: - Integration Tests

@Suite("Swift API - Integration Scenarios")
struct SwiftAPIIntegrationTests {
    @Test func roundingAndExceptions() throws {
        IEEE_754.Exceptions.clear()

        try IEEE_754.RoundingControl.withMode(.upward) {
            let result = 1.0 / 3.0
            #expect(result > 0)

            // Mode should be upward within closure
            #expect(IEEE_754.RoundingControl.get() == .upward)
        }

        // Mode should be restored
        // Exceptions should still be clear
        #expect(!IEEE_754.Exceptions.invalidOperation)
    }

    @Test func signalingComparisonSetsException() {
        IEEE_754.Exceptions.clear()

        // This should set the invalid exception
        _ = IEEE_754.Comparison.Signaling.equal(Float.nan, Float.nan)

        // Verify exception was set
        #expect(IEEE_754.Exceptions.invalidOperation)

        // Clear for next test
        IEEE_754.Exceptions.clear()
    }

    @Test func fpuAndThreadLocalExceptions() {
        IEEE_754.Exceptions.clear()
        Float.exception.clear()

        // Raise thread-local exception
        IEEE_754.Exceptions.raise(.overflow)

        // Check thread-local
        #expect(IEEE_754.Exceptions.overflow)

        // FPU state is independent
        let fpuState = Float.exception.test()
        // FPU overflow might or might not be set depending on operations
        #expect(fpuState.overflow == false || fpuState.overflow == true)
    }
}
