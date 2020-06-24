part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$07$halfWordDataTranseferImmediate].
class HalfWordAndSignedDataTransferImmediateOffset extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$01$dataProcessingOrPsrTransfer,
    (decoded) => HalfWordAndSignedDataTransferImmediateOffset(
      condition: decoded[0],
      p: decoded[1],
      u: decoded[2],
      w: decoded[3],
      l: decoded[4],
      registerN: decoded[5],
      registerD: decoded[6],
      s: decoded[7],
      h: decoded[8],
      offset: decoded[9],
    ),
  );

  /// Pre/Post indexing (`0` = Post: Offset after transfer), (`1` = Pre).
  final int p;

  /// Up/Down (`0` = Down, Subtract offset from base), (`1` = Add offset).
  final int u;

  /// Write-back (`0` = No write-back, `1` = Write address into base).
  final int w;

  /// Load/store (`0` = Store to memory, `1` = Load from meory).
  final int l;

  /// Base register.
  final int registerN;

  /// Destination register.
  final int registerD;

  /// Signed.
  final int s;

  /// Half-word.
  final int h;

  /// Offset immediate value.
  final int offset;

  /// Creates a [HalfWordAndSignedDataTransferImmediateOffset] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  HalfWordAndSignedDataTransferImmediateOffset({
    @required int condition,
    @required this.p,
    @required this.u,
    @required this.w,
    @required this.l,
    @required this.registerN,
    @required this.registerD,
    @required this.s,
    @required this.h,
    @required this.offset,
  }) : super._(condition, decoder._format);

  @override
  R accept<R, C>(ArmSetVisitor<R, C> visitor, [C context]) {
    throw UnimplementedError();
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Cond': condition,
      'P': p,
      'U': u,
      'W': w,
      'L': l,
      'Rn': registerN,
      'Rd': registerD,
      'S': s,
      'H': h,
      'Offset': offset,
    };
  }
}
