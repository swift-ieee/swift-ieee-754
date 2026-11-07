import Dependency
import Synchronization


extension IEEE_754.Exceptions.ExceptionState {
    @usableFromInline
    struct Flags {
        var invalid: Bool = false
        var divisionByZero: Bool = false
        var overflow: Bool = false
        var underflow: Bool = false
        var inexact: Bool = false
    }
}
