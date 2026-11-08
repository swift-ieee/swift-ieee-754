
extension Float.Exception {
    public struct State: Sendable, Equatable {

        public let invalid: Bool

        public let division: Bool

        public let overflow: Bool

        public let underflow: Bool

        public let inexact: Bool

        public init(
            invalid: Bool,
            division: Bool,
            overflow: Bool,
            underflow: Bool,
            inexact: Bool
        ) {
            self.invalid = invalid
            self.division = division
            self.overflow = overflow
            self.underflow = underflow
            self.inexact = inexact
        }
    }
}
