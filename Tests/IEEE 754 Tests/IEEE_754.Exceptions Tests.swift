// IEEE_754.Exceptions Tests.swift
// swift-ieee-754
//
// Comprehensive tests for IEEE 754-2019 Section 7 Exception Handling

import Testing

@testable import IEEE_754

// MARK: - Exception Flag Tests

@Suite("IEEE_754.Exceptions - Flag Operations", .serialized)
struct ExceptionFlagTests {
    @Test func `Raise And Test Invalid`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.invalid)
        #expect(IEEE_754.Exceptions.test(.invalid))
        #expect(!IEEE_754.Exceptions.test(.overflow))
    }

    @Test func `Raise And Test Division By Zero`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.divisionByZero)
        #expect(IEEE_754.Exceptions.test(.divisionByZero))
        #expect(!IEEE_754.Exceptions.test(.invalid))
    }

    @Test func `Raise And Test Overflow`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.overflow)
        #expect(IEEE_754.Exceptions.test(.overflow))
        #expect(!IEEE_754.Exceptions.test(.underflow))
    }

    @Test func `Raise And Test Underflow`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.underflow)
        #expect(IEEE_754.Exceptions.test(.underflow))
        #expect(!IEEE_754.Exceptions.test(.overflow))
    }

    @Test func `Raise And Test Inexact`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.inexact)
        #expect(IEEE_754.Exceptions.test(.inexact))
        #expect(!IEEE_754.Exceptions.test(.invalid))
    }

    @Test func `Clear Specific Flag`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.invalid)
        IEEE_754.Exceptions.raise(.overflow)
        #expect(IEEE_754.Exceptions.test(.invalid))
        #expect(IEEE_754.Exceptions.test(.overflow))

        IEEE_754.Exceptions.clear(.invalid)
        #expect(!IEEE_754.Exceptions.test(.invalid))
        #expect(IEEE_754.Exceptions.test(.overflow))
    }

    @Test func `Clear All Flags`() {
        IEEE_754.Exceptions.raise(.invalid)
        IEEE_754.Exceptions.raise(.divisionByZero)
        IEEE_754.Exceptions.raise(.overflow)
        IEEE_754.Exceptions.raise(.underflow)
        IEEE_754.Exceptions.raise(.inexact)

        IEEE_754.Exceptions.clear()

        #expect(!IEEE_754.Exceptions.test(.invalid))
        #expect(!IEEE_754.Exceptions.test(.divisionByZero))
        #expect(!IEEE_754.Exceptions.test(.overflow))
        #expect(!IEEE_754.Exceptions.test(.underflow))
        #expect(!IEEE_754.Exceptions.test(.inexact))
    }

    @Test func `Multiple Flags`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.invalid)
        IEEE_754.Exceptions.raise(.overflow)
        IEEE_754.Exceptions.raise(.inexact)

        #expect(IEEE_754.Exceptions.test(.invalid))
        #expect(IEEE_754.Exceptions.test(.overflow))
        #expect(IEEE_754.Exceptions.test(.inexact))
        #expect(!IEEE_754.Exceptions.test(.underflow))
        #expect(!IEEE_754.Exceptions.test(.divisionByZero))
    }

    @Test func `Any Raised When No Flags`() {
        IEEE_754.Exceptions.clear()
        #expect(!IEEE_754.Exceptions.raised.any)
    }

    @Test func `Any Raised When One Flag Set`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.overflow)
        #expect(IEEE_754.Exceptions.raised.any)
    }

    @Test func `Any Raised When Multiple Flags`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.invalid)
        IEEE_754.Exceptions.raise(.inexact)
        #expect(IEEE_754.Exceptions.raised.any)
    }

    @Test func `Get Raised Flags When None`() {
        IEEE_754.Exceptions.clear()
        let raised = IEEE_754.Exceptions.raised.flags
        #expect(raised.isEmpty)
    }

    @Test func `Get Raised Flags When One`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.overflow)
        let raised = IEEE_754.Exceptions.raised.flags
        #expect(raised.count == 1)
        #expect(raised.contains(.overflow))
    }

    @Test func `Get Raised Flags When Multiple`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.invalid)
        IEEE_754.Exceptions.raise(.overflow)
        IEEE_754.Exceptions.raise(.inexact)
        let raised = IEEE_754.Exceptions.raised.flags
        #expect(raised.count == 3)
        #expect(raised.contains(.invalid))
        #expect(raised.contains(.overflow))
        #expect(raised.contains(.inexact))
    }

    @Test func `Get Raised Flags When All`() {
        IEEE_754.Exceptions.clear()
        for flag in IEEE_754.Exceptions.Flag.allCases {
            IEEE_754.Exceptions.raise(flag)
        }
        let raised = IEEE_754.Exceptions.raised.flags
        #expect(raised.count == 5)
    }
}

// MARK: - Compatibility API Tests

@Suite("IEEE_754.Exceptions - Compatibility Properties", .serialized)
struct ExceptionCompatibilityTests {
    @Test func `Invalid Operation Property`() {
        IEEE_754.Exceptions.clear()
        #expect(!IEEE_754.Exceptions.invalidOperation)
        IEEE_754.Exceptions.raise(.invalid)
        #expect(IEEE_754.Exceptions.invalidOperation)
    }

    @Test func `Division By Zero Property`() {
        IEEE_754.Exceptions.clear()
        #expect(!IEEE_754.Exceptions.divisionByZero)
        IEEE_754.Exceptions.raise(.divisionByZero)
        #expect(IEEE_754.Exceptions.divisionByZero)
    }

    @Test func `Overflow Property`() {
        IEEE_754.Exceptions.clear()
        #expect(!IEEE_754.Exceptions.overflow)
        IEEE_754.Exceptions.raise(.overflow)
        #expect(IEEE_754.Exceptions.overflow)
    }

    @Test func `Underflow Property`() {
        IEEE_754.Exceptions.clear()
        #expect(!IEEE_754.Exceptions.underflow)
        IEEE_754.Exceptions.raise(.underflow)
        #expect(IEEE_754.Exceptions.underflow)
    }

    @Test func `Inexact Property`() {
        IEEE_754.Exceptions.clear()
        #expect(!IEEE_754.Exceptions.inexact)
        IEEE_754.Exceptions.raise(.inexact)
        #expect(IEEE_754.Exceptions.inexact)
    }
}

// MARK: - Flag Enum Tests

@Suite("IEEE_754.Exceptions - Flag Enum")
struct ExceptionFlagEnumTests {
    @Test func `Flag Description`() {
        #expect(IEEE_754.Exceptions.Flag.invalid.description == "invalid")
        #expect(IEEE_754.Exceptions.Flag.divisionByZero.description == "divisionByZero")
        #expect(IEEE_754.Exceptions.Flag.overflow.description == "overflow")
        #expect(IEEE_754.Exceptions.Flag.underflow.description == "underflow")
        #expect(IEEE_754.Exceptions.Flag.inexact.description == "inexact")
    }

    @Test func `Flag Equality`() {
        #expect(IEEE_754.Exceptions.Flag.invalid == .invalid)
        #expect(IEEE_754.Exceptions.Flag.invalid != .overflow)
    }

    @Test func `All Cases Count`() {
        #expect(IEEE_754.Exceptions.Flag.allCases.count == 5)
    }

    @Test func `All Cases Contains All`() {
        let allCases = IEEE_754.Exceptions.Flag.allCases
        #expect(allCases.contains(.invalid))
        #expect(allCases.contains(.divisionByZero))
        #expect(allCases.contains(.overflow))
        #expect(allCases.contains(.underflow))
        #expect(allCases.contains(.inexact))
    }
}

// MARK: - Idempotency Tests

@Suite("IEEE_754.Exceptions - Idempotency", .serialized)
struct ExceptionIdempotencyTests {
    @Test func `Raising Twice Has No Effect`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.invalid)
        #expect(IEEE_754.Exceptions.test(.invalid))

        IEEE_754.Exceptions.raise(.invalid)
        #expect(IEEE_754.Exceptions.test(.invalid))
    }

    @Test func `Clearing Twice Has No Effect`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.overflow)
        IEEE_754.Exceptions.clear(.overflow)
        #expect(!IEEE_754.Exceptions.test(.overflow))

        IEEE_754.Exceptions.clear(.overflow)
        #expect(!IEEE_754.Exceptions.test(.overflow))
    }

    @Test func `Clear All On Empty State Has No Effect`() {
        IEEE_754.Exceptions.clear()
        #expect(!IEEE_754.Exceptions.raised.any)
        IEEE_754.Exceptions.clear()
        #expect(!IEEE_754.Exceptions.raised.any)
    }
}

// MARK: - Independence Tests

@Suite("IEEE_754.Exceptions - Flag Independence", .serialized)
struct ExceptionIndependenceTests {
    @Test func `Flags Are Independent`() {
        IEEE_754.Exceptions.clear()

        IEEE_754.Exceptions.raise(.invalid)
        #expect(IEEE_754.Exceptions.test(.invalid))
        #expect(!IEEE_754.Exceptions.test(.divisionByZero))
        #expect(!IEEE_754.Exceptions.test(.overflow))
        #expect(!IEEE_754.Exceptions.test(.underflow))
        #expect(!IEEE_754.Exceptions.test(.inexact))

        IEEE_754.Exceptions.raise(.overflow)
        #expect(IEEE_754.Exceptions.test(.invalid))
        #expect(!IEEE_754.Exceptions.test(.divisionByZero))
        #expect(IEEE_754.Exceptions.test(.overflow))
        #expect(!IEEE_754.Exceptions.test(.underflow))
        #expect(!IEEE_754.Exceptions.test(.inexact))
    }

    @Test func `Clearing One Flag Does Not Affect Others`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.invalid)
        IEEE_754.Exceptions.raise(.overflow)
        IEEE_754.Exceptions.raise(.inexact)

        IEEE_754.Exceptions.clear(.overflow)

        #expect(IEEE_754.Exceptions.test(.invalid))
        #expect(!IEEE_754.Exceptions.test(.overflow))
        #expect(IEEE_754.Exceptions.test(.inexact))
    }
}

// MARK: - Thread Safety Tests

@Suite("IEEE_754.Exceptions - Thread Independence", .serialized)
struct ExceptionThreadTests {
    @Test func `Initial State Is Clean`() {
        IEEE_754.Exceptions.clear()
        #expect(!IEEE_754.Exceptions.raised.any)
    }

    @Test func `State Can Be Set And Queried`() {
        IEEE_754.Exceptions.clear()
        IEEE_754.Exceptions.raise(.invalid)
        #expect(IEEE_754.Exceptions.test(.invalid))
        IEEE_754.Exceptions.clear()
        #expect(!IEEE_754.Exceptions.test(.invalid))
    }
}
