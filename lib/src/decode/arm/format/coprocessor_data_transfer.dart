part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$12$coprocessorDataTransfer].
class CoprocessorDataTransfer extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$12$coprocessorDataTransfer,
    (decoded) => CoprocessorDataTransfer(
      condition: decoded[0],
      p: decoded[1],
      u: decoded[2],
      n: decoded[3],
      w: decoded[4],
      l: decoded[5],
      registerN: decoded[6],
      cpRegisterD: decoded[7],
      cpNumber: decoded[8],
      offset: decoded[9],
    ),
  );

  /// Pre/Post indexing bit.
  final int p;

  /// Up/Down bit.
  final int u;

  /// Transfer length.
  final int n;

  /// Write-back bit.
  final int w;

  /// Load/Store bit.
  final int l;

  /// Base register.
  final int registerN;

  /// Coprocessor source/destination register.
  final int cpRegisterD;

  /// Coprocessor number.
  final int cpNumber;

  /// Unsigned 8-bit immediate offset.
  final int offset;

  /// Creates a [CoprocessorDataTransfer] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  CoprocessorDataTransfer({
    @required int condition,
    @required this.p,
    @required this.u,
    @required this.n,
    @required this.w,
    @required this.l,
    @required this.registerN,
    @required this.cpRegisterD,
    @required this.cpNumber,
    @required this.offset,
  }) : super._(condition, decoder._format);

  @override
  R accept<R, C>(ArmSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitCoprocessorDataTransfer(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Cond': condition,
      'P': p,
      'U': u,
      'N': n,
      'W': w,
      'L': l,
      'Rn': registerN,
      'CRd': cpRegisterD,
      'CP': cpNumber,
      'Offset': offset,
    };
  }
}
