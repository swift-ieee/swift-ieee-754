
extension IEEE_754.Payload {
    public enum NaNType: Sendable, Equatable {

        case quiet(payload: UInt64)

        case signaling(payload: UInt64)
    }
}
