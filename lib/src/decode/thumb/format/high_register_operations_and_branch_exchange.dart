part of '../format.dart';

/// Decoded object from [ThumbInstructionSet.$05$highRegisterOperationsAndBranch].
class HighRegisterOperationsAndBranchExchange extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$05$highRegisterOperationsAndBranch,
    (decoded) => HighRegisterOperationsAndBranchExchange(
      opcode: decoded[0],
      h1: decoded[1],
      h2: decoded[2],
      registerSOrHS: decoded[3],
      registerDOrHD: decoded[4],
    ),
  );

  /// Opcode (2-bits).
  final int opcode;

  /// `"H1"` (1-bit).
  final int h1;

  /// `"H2"` (1-bit).
  final int h2;

  /// Register `S` or `"Hs"` (3-bits).
  final int registerSOrHS;

  /// Register `D` or `"Hd"` (3-bits).
  final int registerDOrHD;

  /// Creates a [HighRegisterOperationsAndBranchExchange] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  HighRegisterOperationsAndBranchExchange({
    @required this.opcode,
    @required this.h1,
    @required this.h2,
    @required this.registerSOrHS,
    @required this.registerDOrHD,
  })  : assert(opcode != null),
        assert(h1 != null),
        assert(h2 != null),
        assert(registerSOrHS != null),
        assert(registerDOrHD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitHighRegisterOperationsAndBranchExchange(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Op': opcode,
      'H1': h1,
      'H2': h2,
      'Rs/Hs': registerSOrHS,
      'Rd/Hd': registerDOrHD,
    };
  }
}
