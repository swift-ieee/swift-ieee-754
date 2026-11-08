
extension IEEE_754.Comparison {
    public enum Predicate: Sendable, Equatable {

        case equality(EqualityMode)

        case ordering(OrderingMode)
    }
}
