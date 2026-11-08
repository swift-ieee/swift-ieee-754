
extension IEEE_754.Rounding.Direction {
    public enum TieBreaking: Sendable, Equatable {

        case toEven

        case awayFromZero
    }
}
