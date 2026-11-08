public import Dependency
public import Synchronization


extension IEEE_754.Exceptions {
    public enum Flag: Sendable, Equatable, CaseIterable {

        case invalid

        case divisionByZero

        case overflow

        case underflow

        case inexact
    }
}
