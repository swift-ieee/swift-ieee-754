
extension IEEE_754.Comparison.Predicate {
    public enum OrderingMode: Sendable, Equatable {

        case less(orEqual: Bool)

        case greater(orEqual: Bool)
    }
}
