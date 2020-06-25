part of '../format.dart';

/// Decoded object from [ArmInstructionSet.$10$blockDataTransfer].
class BlockDataTransfer extends ArmInstructionSet {
  static final decoder = ArmInstructionSetDecoder._(
    ArmInstructionSet.$10$blockDataTransfer,
    (decoded) => BlockDataTransfer(
      condition: decoded[0],
      p: decoded[1],
      u: decoded[2],
      s: decoded[3],
      w: decoded[4],
      l: decoded[5],
      registerN: decoded[6],
      regsiterList: decoded[7],
    ),
  );

  /// Pre/Post indexing bit (`0` = Post, `1` = Pre).
  final int p;

  /// Up/Down bit (`0` = Down, `1` = Up).
  final int u;

  /// PSR & Force User Bit (`0` = Do not load/force, `1` = Load PSR or Force).
  final int s;

  /// Write-back bit (`0` = No write-back, `1` = Write address to back).
  final int w;

  /// Load/Store bit (`0` = Store to memory, `1` = Load from memory).
  final int l;

  /// Base regsiter.
  final int registerN;

  /// Registers.
  final int regsiterList;

  /// Creates a [BlockDataTransfer] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  BlockDataTransfer({
    @required int condition,
    @required this.p,
    @required this.u,
    @required this.s,
    @required this.w,
    @required this.l,
    @required this.registerN,
    @required this.regsiterList,
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
      'S': s,
      'W': w,
      'L': l,
      'Rn': registerN,
      'RegisterList': regsiterList,
    };
  }
}
