part of '../../instruction.dart';

/// Halfword and Signed Data Transefer.
///
/// The instruction is only executed if [condition] is true.
///
/// These instructions are used to load or store half-words of data and also
/// load sign-extended bytes or half-words of data. The memory address used in
/// the transfer is calculated by adding an offset to or subtract an offset from
/// a base regsiter. The result of thsi calculation may be written back into the
/// base regsiter if auto-indexing is required.
abstract class LDRH$STRH$LDRSB$LDRSH extends ArmInstruction {
  /// Pre/Post indexing.
  final int p;

  /// Up/Down.
  final int u;

  /// Write-back.
  final int w;

  /// `Rn`.
  final int baseRegister;

  /// `Rd`.
  final int sourceOrDestinationRegister;

  /// `Rm`.
  final int offsetRegister;

  const LDRH$STRH$LDRSB$LDRSH._({
    @required int condition,
    @required this.p,
    @required this.u,
    @required this.w,
    @required this.baseRegister,
    @required this.sourceOrDestinationRegister,
    @required this.offsetRegister,
  }) : super._(condition);

  @override
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]) =>
      throw UnimplementedError();
}

class LRDH extends LDRH$STRH$LDRSB$LDRSH {
  const LRDH({
    @required int condition,
    @required int p,
    @required int u,
    @required int w,
    @required int baseRegister,
    @required int sourceOrDestinationRegister,
    @required int offsetRegister,
  }) : super._(
          condition: condition,
          p: p,
          u: u,
          w: w,
          baseRegister: baseRegister,
          sourceOrDestinationRegister: sourceOrDestinationRegister,
          offsetRegister: offsetRegister,
        );
}
