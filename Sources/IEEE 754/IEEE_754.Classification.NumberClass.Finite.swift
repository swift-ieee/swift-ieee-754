
extension IEEE_754.Classification.NumberClass {
    public enum Finite: Sendable, Equatable {

        case infinity

        case normal

        case subnormal

        case zero
    }
}
