import 'dart:collection';

import 'package:binary/binary.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// An **internal** package representing all known `THUMB` instruction sets.
///
/// For testing, individual [BitPattern] implementations are accessible as
/// static fields (e.g. `[$01$moveShiftedRegister]`), and a sorted
/// [BitPatternGrpup] is accessible as [allFormats].
abstract class ThumbInstructionSet {
  /// Move shifted register.
  static final $01$moveShiftedRegister = BitPatternBuilder.parse(
    '000P_POOO_OOSS_SDDD',
  ).build('01:MOVE_SHIFTED_REGISTER');

  /// Add and subtract.
  static final $02$addAndSubtract = BitPatternBuilder.parse(
    '0001_11PN_NNSS_SDDD',
  ).build('02:ADD_AND_SUBTRACT');

  /// Move, compare, add, and subtract immediate.
  static final $03$moveCompareAddAndSubtractImmediate = BitPatternBuilder.parse(
    '001P_PDDD_OOOO_OOOO',
  ).build('03:MOVE_COMPARE_ADD_AND_SUBTRACT_IMMEDIATE');

  /// ALU operation.
  static final $04$aluOperation = BitPatternBuilder.parse(
    '0100_00PP_PPSS_SDDD',
  ).build('04:ALU_OPERATION');

  /// High register operations and branch exchange.
  static final $05$highRegisterOperationsAndBranch = BitPatternBuilder.parse(
    '0100_01PP_HJSS_SDDD',
  ).build('05:HIGH_REGISTER_OPERATIONS_AND_BRANCH_EXCHANGE');

  /// PC-relkative load.
  static final $06$pcRelativeLoad = BitPatternBuilder.parse(
    '0100_1DDD_WWWW_WWWW',
  ).build('06:PC_RELATIVE_LOAD');

  /// Load and store with relative offset.
  static final $07$loadAndStoreWithRelativeOffset = BitPatternBuilder.parse(
    '0101_LB0O_OONN_NDDD',
  ).build('07:LOAD_AND_STORE_WITH_RELATIVE_OFFSET');

  /// Load and store sign-extended byte and half-word.
  static final $08$loadAndStoreSignExtended = BitPatternBuilder.parse(
    '0101_HS1O_OOBB_BDDD',
  ).build('08:LOAD_AND_STORE_SIGN_EXTENDED_BYTE_AND_HALFWORD');

  /// Load and store with immediate offset.
  static final $09$loadAndStoreWithImmediateOffset = BitPatternBuilder.parse(
    '011B_LOOO_OONN_NDDD',
  ).build('09:LOAD_AND_STORE_WITH_IMMEDIATE_OFFSET');

  /// Load and store halfword.
  static final $10$loadAndStoreHalfword = BitPatternBuilder.parse(
    '1000_LOOO_OOBB_BDDD',
  ).build('10:LOAD_AND_STORE_HALFWORD');

  /// SP-relative load and store.
  static final $11$spRelativeLoadAndStore = BitPatternBuilder.parse(
    '1001_LDDD_WWWW_WWWW',
  ).build('11:SP_RELATIVE_LOAD_AND_STORE');

  /// Load address.
  static final $12$loadAddress = BitPatternBuilder.parse(
    '1010_SDDD_WWWW_WWWW',
  ).build('12:LOAD_ADDRESS');

  /// Add offset to stack pointer.
  static final $13$addOffsetToStackPointer = BitPatternBuilder.parse(
    '1011_0000_SWWW_WWWW',
  ).build('13:ADD_OFFSET_TO_STACK_POINTER');

  /// Push and pop registers.
  static final $14$pushAndPopRegisters = BitPatternBuilder.parse(
    '1011_L10R_TTTT_TTTT',
  ).build('14:PUSH_AND_POP_REGISTERS');

  /// Multiple load and store.
  static final $15$multipleLoadAndStore = BitPatternBuilder.parse(
    '1100_LBBB_TTTT_TTTT',
  ).build('15:MULTIPLE_LOAD_AND_STORE');

  /// Conditional branch.
  static final $16$conditionalBranch = BitPatternBuilder.parse(
    '1101_CCCC_SSSS_SSSS',
  ).build('16:CONDITIONAL_BRANCH');

  /// Software interrupt.
  static final $17$softwareInterrupt = BitPatternBuilder.parse(
    '1101_1111_VVVV_VVVV',
  ).build('17:SOFTWARE_INTERRUPT');

  /// Unconditional branch.
  static final $18$unconditionalBranch = BitPatternBuilder.parse(
    '1110_0OOO_OOOO_OOOO',
  ).build('18:UNCONDITIONAL_BRANCH');

  /// Long branch with link.
  static final $19$longBranchWithLink = BitPatternBuilder.parse(
    '1111_HOOO_OOOO_OOOO',
  ).build('19:LONG_BRANCH_WITH_LINK');

  /// A known list of all the different [ThumbInstructionSetDecoder] instances.
  static final _decoders = [
    MoveShiftedRegister.decoder,
    AddAndSubtract.decoder,
    MoveCompareAddAndSubtractImmediate.decoder,
    ALUOperation.decoder,
    HighRegisterOperationsAndBranchExchange.decoder,
    PCRelativeLoad.decoder,
    LoadAndStoreWithRelativeOffset.decoder,
    LoadAndStoreSignExtendedByteAndHalfWord.decoder,
    LoadAndStoreWithImmediateOffset.decoder,
    LoadAndStoreHalfWord.decoder,
    SPRelativeLoadAndStore.decoder,
    LoadAddress.decoder,
    AddOffsetToStackPointer.decoder,
    PushAndPopRegisters.decoder,
    MultipleLoadAndStore.decoder,
    ConditionalBranch.decoder,
    SoftwareInterrupt.decoder,
    UnconditionalBranch.decoder,
    LongBranchWithLink.decoder,
  ];

  /// A collection of all the known formats in [ThumbInstructionSet], sorted.
  static final allFormats = _decoders.map((d) => d._format).toList().toGroup();

  static Map<BitPattern<void>, ThumbInstructionSetDecoder> _mapDecoders() {
    final m = {for (final decoder in _decoders) decoder._format: decoder};
    return HashMap.identity()..addAll(m);
  }

  /// Create a Map of [BitPattern] -> [ThumbInstructionSetDecoder].
  static final mapDecoders = _mapDecoders();

  /// Format used to match and decode this instruction.
  final BitPattern<List<int>> _format;

  const ThumbInstructionSet._(this._format) : assert(_format != null);

  /// Delegates to the appropriate method of [visitor], optionally [context].
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    } else if (o is ThumbInstructionSet && identical(_format, o._format)) {
      return const MapEquality<Object, Object>().equals(toJson(), o.toJson());
    } else {
      return false;
    }
  }

  @override
  int get hashCode => const MapEquality<Object, Object>().hash(toJson());

  /// Must provide a JSON representation.
  Map<String, Object> toJson();

  @override
  String toString() => '$runtimeType $toJson()';
}

/// Implements decoding a `List<int>` or `int` into a [T] [ThumbInstructionSet].
@sealed
class ThumbInstructionSetDecoder<T extends ThumbInstructionSet> {
  final BitPattern<List<int>> _format;
  final T Function(List<int>) _decoder;

  /// Create a new [ThumbInstructionSetDecoder] for type [T].
  @literal
  const ThumbInstructionSetDecoder._(this._format, this._decoder);

  /// Creates a [ThumbInstructionSet] by decoding [bits].
  @nonVirtual
  T decodeBits(int bits) => decodeList(_format.capture(bits));

  /// Creates a [ThumbInstructionSet] converting a previously [decoded] list.
  @nonVirtual
  T decodeList(List<int> decoded) => _decoder(decoded);
}

/// Implement to in order to visit known sub-types of [ThumbInstructionSet].
abstract class ThumbInstructionSetVisitor<R, C> {
  R visitMoveShiftedRegister(
    MoveShiftedRegister set, [
    C context,
  ]);

  R visitAddAndSubtract(
    AddAndSubtract set, [
    C context,
  ]);

  R visitMoveCompareAddAndSubtractImmediate(
    MoveCompareAddAndSubtractImmediate set, [
    C context,
  ]);

  R visitALUOperation(
    ALUOperation set, [
    C context,
  ]);

  R visitHighRegisterOperationsAndBranchExchange(
    HighRegisterOperationsAndBranchExchange set, [
    C context,
  ]);

  R visitPCRelativeLoad(
    PCRelativeLoad set, [
    C context,
  ]);

  R visitLoadAndStoreWithRelativeOffset(
    LoadAndStoreWithRelativeOffset set, [
    C context,
  ]);

  R visitLoadAndStoreSignExtendedByteAndHalfWord(
    LoadAndStoreSignExtendedByteAndHalfWord set, [
    C context,
  ]);

  R visitLoadAndStoreWithImmediateOffset(
    LoadAndStoreWithImmediateOffset set, [
    C context,
  ]);

  R visitLoadAndStoreHalfWord(
    LoadAndStoreHalfWord set, [
    C context,
  ]);

  R visitSPRelativeLoadAndStore(
    SPRelativeLoadAndStore set, [
    C context,
  ]);

  R visitLoadAddress(
    LoadAddress set, [
    C context,
  ]);

  R visitAddOffsetToStackPointer(
    AddOffsetToStackPointer set, [
    C context,
  ]);

  R visitPushAndPopRegisters(
    PushAndPopRegisters set, [
    C context,
  ]);

  R visitMultipleLoadAndStore(
    MultipleLoadAndStore set, [
    C context,
  ]);

  R visitConditionalBranch(
    ConditionalBranch set, [
    C context,
  ]);

  R visitSoftwareInterrupt(
    SoftwareInterrupt set, [
    C context,
  ]);

  R visitUnconditionalBranch(
    UnconditionalBranch set, [
    C context,
  ]);

  R visitLongBranchWithLink(
    LongBranchWithLink set, [
    C context,
  ]);
}

/// Decoded object from [ThumbInstructionSet.$01$moveShiftedRegister].
class MoveShiftedRegister extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$01$moveShiftedRegister,
    (decoded) => MoveShiftedRegister(
      opcode: decoded[0],
      offset: decoded[1],
      registerS: decoded[2],
      registerD: decoded[3],
    ),
  );

  /// OpCode (2-bits).
  final int opcode;

  /// Offset (5-bits).
  final int offset;

  /// Register `S` (3-bits).
  final int registerS;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [MoveShiftedRegister] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  MoveShiftedRegister({
    @required this.opcode,
    @required this.offset,
    @required this.registerS,
    @required this.registerD,
  })  : assert(opcode != null),
        assert(offset != null),
        assert(registerS != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitMoveShiftedRegister(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Op': opcode,
      'Offset5': offset,
      'Rs': registerS,
      'Rd': registerD,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$02$addAndSubtract].
class AddAndSubtract extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$02$addAndSubtract,
    (decoded) => AddAndSubtract(
      opcode: decoded[0],
      registerNOrOffset3: decoded[1],
      registerS: decoded[2],
      registerD: decoded[3],
    ),
  );

  /// OpCode (2-bits).
  final int opcode;

  /// Register `N` or Offset (3-bits).
  final int registerNOrOffset3;

  /// Register `S`.
  final int registerS;

  /// Register `D`.
  final int registerD;

  /// Creates a [AddAndSubtract] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  AddAndSubtract({
    @required this.opcode,
    @required this.registerNOrOffset3,
    @required this.registerS,
    @required this.registerD,
  })  : assert(opcode != null),
        assert(registerNOrOffset3 != null),
        assert(registerS != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitAddAndSubtract(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Op': opcode,
      'Rn/Offset3': registerNOrOffset3,
      'Rs': registerS,
      'Rd': registerD,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$03$moveCompareAddAndSubtractImmediate].
class MoveCompareAddAndSubtractImmediate extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$03$moveCompareAddAndSubtractImmediate,
    (decoded) => MoveCompareAddAndSubtractImmediate(
      opcode: decoded[0],
      registerD: decoded[1],
      offset: decoded[2],
    ),
  );

  /// OpCode (2-bits).
  final int opcode;

  /// Register `D` (3-bits).
  final int registerD;

  /// Offset (8-bits).
  final int offset;

  /// Creates a [MoveCompareAddAndSubtractImmediate] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  MoveCompareAddAndSubtractImmediate({
    @required this.opcode,
    @required this.registerD,
    @required this.offset,
  })  : assert(opcode != null),
        assert(offset != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitMoveCompareAddAndSubtractImmediate(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Op': opcode,
      'Rd': registerD,
      'Offset8': offset,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$04$aluOperation].
class ALUOperation extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$04$aluOperation,
    (decoded) => ALUOperation(
      opcode: decoded[0],
      registerS: decoded[1],
      registerD: decoded[2],
    ),
  );

  /// OpCode (4-bits).
  final int opcode;

  /// Register `S` (3-bits).
  final int registerS;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [ALUOperation] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  ALUOperation({
    @required this.opcode,
    @required this.registerS,
    @required this.registerD,
  })  : assert(opcode != null),
        assert(registerS != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitALUOperation(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Op': opcode,
      'Rs': registerS,
      'Rd': registerD,
    };
  }
}

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
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
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

/// Decoded object from [ThumbInstructionSet.$06$pcRelativeLoad].
class PCRelativeLoad extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$06$pcRelativeLoad,
    (decoded) => PCRelativeLoad(
      registerD: decoded[0],
      word8: decoded[1],
    ),
  );

  /// Register `D` (3-bits).
  final int registerD;

  /// Word (8-bits).
  final int word8;

  /// Creates a [PCRelativeLoad] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  PCRelativeLoad({
    @required this.registerD,
    @required this.word8,
  })  : assert(registerD != null),
        assert(word8 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitPCRelativeLoad(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Rd': registerD,
      'Word8': word8,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$07$loadAndStoreWithRelativeOffset].
class LoadAndStoreWithRelativeOffset extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$07$loadAndStoreWithRelativeOffset,
    (decoded) => LoadAndStoreWithRelativeOffset(
      l: decoded[0],
      b: decoded[1],
      registerO: decoded[2],
      registerB: decoded[3],
      registerD: decoded[4],
    ),
  );

  /// `L` (1-bit).
  final int l;

  /// `B` (1-bit).
  final int b;

  /// Register `O` (3-bits).
  final int registerO;

  /// Register `B` (3-bits).
  final int registerB;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [LoadAndStoreWithRelativeOffset] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  LoadAndStoreWithRelativeOffset({
    @required this.l,
    @required this.b,
    @required this.registerO,
    @required this.registerB,
    @required this.registerD,
  })  : assert(l != null),
        assert(b != null),
        assert(registerO != null),
        assert(registerB != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadAndStoreWithRelativeOffset(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'l': l,
      'b': b,
      'Ro': registerO,
      'Rb': registerB,
      'Rd': registerD,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$08$loadAndStoreSignExtended].
class LoadAndStoreSignExtendedByteAndHalfWord extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$08$loadAndStoreSignExtended,
    (decoded) => LoadAndStoreSignExtendedByteAndHalfWord(
      h: decoded[0],
      s: decoded[1],
      registerO: decoded[2],
      registerB: decoded[3],
      registerD: decoded[4],
    ),
  );

  /// `H` (1-bit).
  final int h;

  /// `S` (1-bit).
  final int s;

  /// Register `O` (3-bits).
  final int registerO;

  /// Register `B` (3-bits).
  final int registerB;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [LoadAndStoreSignExtendedByteAndHalfWord] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  LoadAndStoreSignExtendedByteAndHalfWord({
    @required this.h,
    @required this.s,
    @required this.registerO,
    @required this.registerB,
    @required this.registerD,
  })  : assert(h != null),
        assert(s != null),
        assert(registerO != null),
        assert(registerB != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadAndStoreSignExtendedByteAndHalfWord(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'H': h,
      'S': s,
      'Ro': registerO,
      'Rb': registerB,
      'Rd': registerD,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$09$loadAndStoreWithImmediateOffset].
class LoadAndStoreWithImmediateOffset extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$09$loadAndStoreWithImmediateOffset,
    (decoded) => LoadAndStoreWithImmediateOffset(
      b: decoded[0],
      l: decoded[1],
      offset5: decoded[2],
      registerB: decoded[3],
      registerD: decoded[4],
    ),
  );

  /// `B` (1-bit).
  final int b;

  /// `L` (1-bit).
  final int l;

  /// Offset (5-bits).
  final int offset5;

  /// Register `B` (3-bits).
  final int registerB;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [LoadAndStoreWithImmediateOffset] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  LoadAndStoreWithImmediateOffset({
    @required this.b,
    @required this.l,
    @required this.offset5,
    @required this.registerB,
    @required this.registerD,
  })  : assert(b != null),
        assert(l != null),
        assert(offset5 != null),
        assert(registerB != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadAndStoreWithImmediateOffset(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'B': b,
      'L': l,
      'Offset5': offset5,
      'Rb': registerB,
      'Rd': registerD,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$10$loadAndStoreHalfword].
class LoadAndStoreHalfWord extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$10$loadAndStoreHalfword,
    (decoded) => LoadAndStoreHalfWord(
      l: decoded[0],
      offset5: decoded[1],
      registerB: decoded[2],
      registerD: decoded[3],
    ),
  );

  /// `L` (1-bit).
  final int l;

  /// Offset (5-bits).
  final int offset5;

  /// Register `B` (3-bits).
  final int registerB;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [LoadAndStoreHalfWord] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  LoadAndStoreHalfWord({
    @required this.l,
    @required this.offset5,
    @required this.registerB,
    @required this.registerD,
  })  : assert(l != null),
        assert(offset5 != null),
        assert(registerB != null),
        assert(registerD != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadAndStoreHalfWord(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'L': l,
      'Offset5': offset5,
      'Rb': registerB,
      'Rd': registerD,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$11$spRelativeLoadAndStore].
class SPRelativeLoadAndStore extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$11$spRelativeLoadAndStore,
    (decoded) => SPRelativeLoadAndStore(
      l: decoded[0],
      registerD: decoded[1],
      word8: decoded[2],
    ),
  );

  /// `L` (1-bit).
  final int l;

  /// Register `D` (3-bits).
  final int registerD;

  /// Word (8-bits).
  final int word8;

  /// Creates a [SPRelativeLoadAndStore] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  SPRelativeLoadAndStore({
    @required this.l,
    @required this.registerD,
    @required this.word8,
  })  : assert(l != null),
        assert(registerD != null),
        assert(word8 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitSPRelativeLoadAndStore(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'L': l,
      'Rd': registerD,
      'Word8': word8,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$12$loadAddress].
class LoadAddress extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$12$loadAddress,
    (decoded) => LoadAddress(
      sp: decoded[0],
      registerD: decoded[1],
      word8: decoded[2],
    ),
  );

  /// `SP` (1-bit).
  final int sp;

  /// Register `D` (3-bits).
  final int registerD;

  /// Word (8-bits).
  final int word8;

  /// Creates a [LoadAddress] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  LoadAddress({
    @required this.sp,
    @required this.registerD,
    @required this.word8,
  })  : assert(sp != null),
        assert(registerD != null),
        assert(word8 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitLoadAddress(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'SP': sp,
      'Rd': registerD,
      'Word8': word8,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$13$addOffsetToStackPointer].
class AddOffsetToStackPointer extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$13$addOffsetToStackPointer,
    (decoded) => AddOffsetToStackPointer(
      s: decoded[0],
      sWord7: decoded[1],
    ),
  );

  /// `S` (1-bit).
  final int s;

  /// S-Word (7-bits).
  final int sWord7;

  /// Creates a [AddOffsetToStackPointer] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  AddOffsetToStackPointer({
    @required this.s,
    @required this.sWord7,
  })  : assert(s != null),
        assert(sWord7 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitAddOffsetToStackPointer(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'S': s,
      'SWord7': sWord7,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$14$pushAndPopRegisters].
class PushAndPopRegisters extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$14$pushAndPopRegisters,
    (decoded) => PushAndPopRegisters(
      l: decoded[0],
      r: decoded[1],
      registerList: decoded[2],
    ),
  );

  /// `L` (1-bit).
  final int l;

  /// `R` (1-bit).
  final int r;

  /// Register list (8-bits).
  final int registerList;

  /// Creates a [PushAndPopRegisters] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  PushAndPopRegisters({
    @required this.l,
    @required this.r,
    @required this.registerList,
  })  : assert(l != null),
        assert(r != null),
        assert(registerList != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitPushAndPopRegisters(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'L': l,
      'R': r,
      'Rlist': registerList,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$15$multipleLoadAndStore].
class MultipleLoadAndStore extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$15$multipleLoadAndStore,
    (decoded) => MultipleLoadAndStore(
      l: decoded[0],
      registerB: decoded[1],
      registerList: decoded[2],
    ),
  );

  /// `L` (1-bit).
  final int l;

  /// Register `B` (3-bits).
  final int registerB;

  /// Register list (8-bits).
  final int registerList;

  /// Creates a [MultipleLoadAndStore] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  MultipleLoadAndStore({
    @required this.l,
    @required this.registerB,
    @required this.registerList,
  })  : assert(l != null),
        assert(registerB != null),
        assert(registerList != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitMultipleLoadAndStore(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'L': l,
      'Rb': registerB,
      'Rlist': registerList,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$16$conditionalBranch].
class ConditionalBranch extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$16$conditionalBranch,
    (decoded) => ConditionalBranch(
      condition: decoded[0],
      softSet8: decoded[1],
    ),
  );

  /// Condition (4-bits).
  final int condition;

  /// Softset (8-bits).
  final int softSet8;

  /// Creates a [ConditionalBranch] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  ConditionalBranch({
    @required this.condition,
    @required this.softSet8,
  })  : assert(condition != null),
        assert(softSet8 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitConditionalBranch(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Cond': condition,
      'Softset8': softSet8,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$17$softwareInterrupt].
class SoftwareInterrupt extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$17$softwareInterrupt,
    (decoded) => SoftwareInterrupt(
      value8: decoded[0],
    ),
  );

  /// Value (8-bits).
  final int value8;

  /// Creates a [SoftwareInterrupt] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  SoftwareInterrupt({
    @required this.value8,
  })  : assert(value8 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitSoftwareInterrupt(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Value8': value8,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$18$unconditionalBranch].
class UnconditionalBranch extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$18$unconditionalBranch,
    (decoded) => UnconditionalBranch(
      offset11: decoded[0],
    ),
  );

  /// Offset (11-bits).
  final int offset11;

  /// Creates a [UnconditionalBranch] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  UnconditionalBranch({
    @required this.offset11,
  })  : assert(offset11 != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitUnconditionalBranch(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'Offset11': offset11,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$19$longBranchWithLink].
class LongBranchWithLink extends ThumbInstructionSet {
  static final decoder = ThumbInstructionSetDecoder._(
    ThumbInstructionSet.$19$longBranchWithLink,
    (decoded) => LongBranchWithLink(
      h: decoded[0],
      offset: decoded[1],
    ),
  );

  /// `H` (1-bit).
  final int h;

  /// Offset (11-bits).
  final int offset;

  /// Creates a [LongBranchWithLink] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  LongBranchWithLink({
    @required this.h,
    @required this.offset,
  })  : assert(h != null),
        assert(offset != null),
        super._(decoder._format);

  @override
  R accept<R, C>(ThumbInstructionSetVisitor<R, C> visitor, [C context]) {
    return visitor.visitLongBranchWithLink(this, context);
  }

  @override
  Map<String, Object> toJson() {
    return {
      'H': h,
      'Offset': offset,
    };
  }
}
