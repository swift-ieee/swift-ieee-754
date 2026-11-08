
extension IEEE_754.Classification {
    public enum NumberClass: Sendable, Equatable {

        case nan(NaN)

        case positive(Finite)

        case negative(Finite)
    }
}
