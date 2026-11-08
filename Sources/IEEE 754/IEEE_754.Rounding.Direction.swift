
extension IEEE_754.Rounding {
    public enum Direction: Sendable, Equatable {

        case towardInfinity(Sign)

        case towardZero

        case toNearest(TieBreaking)
    }
}
