
extension IEEE_754.NextOperations.Direction {
    public enum Target: Sendable, Equatable {

        case positiveInfinity

        case negativeInfinity

        case value(Double)
    }
}
