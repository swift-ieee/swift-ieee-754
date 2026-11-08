public import Dependency
public import Synchronization


extension IEEE_754.Exceptions {
    @usableFromInline
    final class ExceptionState: @unchecked Sendable {
        @usableFromInline
        let state: Mutex<Flags> = Mutex(Flags())

        @usableFromInline
        init() {}
    }
}
