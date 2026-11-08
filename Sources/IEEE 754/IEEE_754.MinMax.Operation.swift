
extension IEEE_754.MinMax {
    public enum Operation: Sendable, Equatable {

        case standard(Mode)

        case number(Mode)

        case magnitude(Mode, preferNumber: Bool)
    }
}
