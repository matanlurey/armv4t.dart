part of '../../instruction.dart';

/// Multiply Long and Multiply-Accumulate Long (`MULL`, `MLAL`, etc).
///
/// The multiply long instructions perform integer multiplication on two 32-bit
/// operands and produce 64-bit results. Signed and unsigned multiplication each
/// with optional accumulate give rise to four variations.
///
/// The multiply forms (`UMULL` and `SMULL`) take two 32-bit numbers and
/// multiply them to produce a 64-bit result of the form
/// `RdHi, RdLo := Rm * Rs`. the lower 32-bits of the 64-bit result are written
/// to [sourceOrDestinationRegisterLo], the upper 32-bit results of the result
/// are written to [sourceOrDestinationRegisterHi].
///
/// The multiply-accumulate forms (`UMLAL` and `SMLAL`) take two 32-bit numbers,
/// multiply them and add a 64-bit number to produce a 64-bit result of the form
/// `RdHi, RdLo := Rm * Rs + RdHi, RdLo`. The lower 32-bits of the 64-bit number
/// to add is read from [sourceOrDestinationRegisterHi]. The lower 32-bits of
/// the 64-bit number are written to [sourceOrDestinationRegisterLo]. The upper
/// 32-bits of the 64-bit result are written to [sourceOrDestinationRegisterHi].
///
/// The `UMULL` and `UMLAL` instructions treat all of their operands as unsigned
/// binary numbers and write an unsigned 64-bit result. The `SMULL` and `SMLAL`
/// instructions treat all of their operands as two's-complement signed numbers
/// and write a two's-complement signed 64-bit result.
abstract class MULL$MLAL$UMULL$SMULL$UMLAL$SMLAL extends ArmInstruction {
  /// Set condition code (`0` = Do not, `1` = Set condition codes).
  final int s;

  /// `RdHi`.
  final int sourceOrDestinationRegisterHi;

  /// `RdLo`.
  final int sourceOrDestinationRegisterLo;

  /// `Rs`.
  final int operandRegister1;

  /// `Rm`.
  final int operandRegister2;

  const MULL$MLAL$UMULL$SMULL$UMLAL$SMLAL._({
    @required int condition,
    @required this.s,
    @required this.sourceOrDestinationRegisterHi,
    @required this.sourceOrDestinationRegisterLo,
    @required this.operandRegister1,
    @required this.operandRegister2,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}

/// A sub-type of [MULL$MLAL$UMULL$SMULL$UMLAL$SMLAL] specifically for `MULL`.
class MULL extends MULL$MLAL$UMULL$SMULL$UMLAL$SMLAL {
  const MULL({
    @required int condition,
    @required int s,
    @required int sourceOrDestinationRegisterHi,
    @required int sourceOrDestinationRegisterLo,
    @required int operandRegister1,
    @required int operandRegister2,
  }) : super._(
          condition: condition,
          s: s,
          sourceOrDestinationRegisterHi: sourceOrDestinationRegisterHi,
          sourceOrDestinationRegisterLo: sourceOrDestinationRegisterLo,
          operandRegister1: operandRegister1,
          operandRegister2: operandRegister2,
        );
}
