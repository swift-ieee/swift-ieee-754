# swift-ieee-754

Use this package when you need the IEEE 754 operations Swift doesn't spell out for `Float` and `Double`: reading and writing their binary32 and binary64 bytes, the standard's minimum and maximum, total order, signaling comparisons, NaN payloads, and exception flags. Start from `Double.bytes(endianness:)` and `Double.init(bytes:endianness:)` for bytes, and from the namespaces under `IEEE_754`, such as `IEEE_754.MinMax` and `IEEE_754.Comparison`, for the operations.

## Laws

- Bytes are the value's bit pattern, little-endian unless you ask for big-endian. Signed zeros, infinities and subnormals keep their bits.
- Decoding a single value needs exactly 4 bytes for `Float` and 8 for `Double`, and gives nil otherwise. Decoding an array gives nil unless the byte count is a multiple of the element size.
- `IEEE_754.Exceptions` is a software flag store, not the FPU's. Arithmetic never sets it. Only `IEEE_754.Exceptions.raise(_:)` and a signaling comparison with a NaN operand do. Its flags are shared by every thread and task in the process.
- `Float.Exception.test()` reads the hardware FPU flags instead, and `Double.Exception` reads the same flags. Where the C shims aren't built, such as on Windows and visionOS, it always reports no flags.
- A signaling comparison with a NaN operand raises `invalid` and returns false, except `IEEE_754.Comparison.Signaling.notEqual(_:_:)`, which returns true. Signaling comparisons and `IEEE_754.RoundingControl` exist only where the C shims are built.
- `IEEE_754.RoundingControl.withMode(_:_:)` sets the thread's FPU rounding mode for the body and restores the previous mode afterwards, also when the body throws. It traps if the mode can't be set.
- `IEEE_754.MinMax.minimum(_:_:)` and `IEEE_754.MinMax.maximum(_:_:)` return NaN if either operand is NaN. The `Number` variants return the other operand instead, and NaN only when both are NaN. All of them treat `-0.0` as less than `0.0`. The magnitude variants break a tie in magnitude the same way.
- `IEEE_754.Comparison.totalOrder(_:_:)` orders `-0.0` before `0.0`, and positive NaN after every number.
- `IEEE_754.Rounding.round(_:)` rounds ties to even, so `4.5` becomes `4.0`. Use `IEEE_754.Rounding.roundAwayFromZero(_:)` for ties away from zero.
- Conversions to `Int` and `UInt` return nil for NaN, infinity and values outside the integer's range, instead of trapping. The plain ones round ties to even, and the `Truncating` ones round toward zero. `UInt` conversions return nil for any negative value, even one that would round to zero.
- `IEEE_754.NextOperations.nextAfter(_:toward:)` between two zeros of opposite sign returns the target, so the sign changes. A NaN operand gives NaN.
- `IEEE_754.Scaling.logB(_:)` returns `Int.min` for zero and `Int.max` for infinity and NaN.
- `IEEE_754.Payload.encodeSignalingNaN(payload:)` uses payload 1 when the payload is 0, because a signaling NaN with payload 0 would be infinity.
