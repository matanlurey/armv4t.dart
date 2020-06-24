part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$08$singleDataTransfer].
class SingleDataTransfer extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$01$dataProcessingOrPsrTransfer,
    (decoded) => SingleDataTransfer(
      condition: decoded[0],
      i: decoded[1],
      p: decoded[2],
      u: decoded[3],
      b: decoded[4],
      w: decoded[5],
      l: decoded[6],
      registerN: decoded[7],
      registerD: decoded[8],
      offset: decoded[9],
    ),
  );

  /// Whether [offset] is an immediate value (`0`) or a register (`1`).
  final int i;

  /// Whether to add [offset] before transfer (`0`) or after (`1`).
  final int p;

  /// Whether to subtract offset from base (`0`) or add offset to base (`1`).
  final int u;

  /// Whether to transfer word quantity (`0`) or byte quantity (`1`).
  final int b;

  /// Whether not to write-back (`0`) or to write address into base (`1`).
  final int w;

  /// Whether to store into memory (`0`) or load from memory (`1`).
  final int l;

  /// Base register.
  final int registerN;

  /// Destination register.
  final int registerD;

  /// Either an immediate offset or offset register. See [i].
  final int offset;

  /// Creates a [SingleDataTransfer] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  SingleDataTransfer({
    @required int condition,
    @required this.i,
    @required this.p,
    @required this.u,
    @required this.b,
    @required this.w,
    @required this.l,
    @required this.registerN,
    @required this.registerD,
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
      'I': i,
      'P': p,
      'U': u,
      'B': b,
      'W': w,
      'L': l,
      'Rn': registerN,
      'Rd': registerD,
      'Offset': offset,
    };
  }
}
