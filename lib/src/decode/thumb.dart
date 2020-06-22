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

  /// A collection of all the known formats in [ThumbInstructionSet], sorted.
  static final BitPatternGroup<List<int>, BitPattern<List<int>>> allFormats = [
    $01$moveShiftedRegister,
    $02$addAndSubtract,
    $03$moveCompareAddAndSubtractImmediate,
    $04$aluOperation,
    $05$highRegisterOperationsAndBranch,
    $06$pcRelativeLoad,
    $07$loadAndStoreWithRelativeOffset,
    $08$loadAndStoreSignExtended,
    $09$loadAndStoreWithImmediateOffset,
    $10$loadAndStoreHalfword,
    $11$spRelativeLoadAndStore,
    $12$loadAddress,
    $13$addOffsetToStackPointer,
    $14$pushAndPopRegisters,
    $15$multipleLoadAndStore,
    $16$conditionalBranch,
    $17$softwareInterrupt,
    $18$unconditionalBranch,
    $19$longBranchWithLink,
  ].toGroup();

  /// Format used to match and decode this instruction.
  final BitPattern<List<int>> format;

  const ThumbInstructionSet._(this.format) : assert(format != null);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    } else if (o is ThumbInstructionSet && identical(format, o.format)) {
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

/// Decoded object from [ThumbInstructionSet.$01$moveShiftedRegister].

class MoveShiftedRegister extends ThumbInstructionSet {
  static final _F = ThumbInstructionSet.$01$moveShiftedRegister;

  /// OpCode (2-bits).
  final int opcode;

  /// Offset (5-bits).
  final int offset;

  /// Register `S` (3-bits).
  final int registerS;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [MoveShiftedRegister] by decoding [bits].
  factory MoveShiftedRegister.decodeBits(int bits) {
    return MoveShiftedRegister.fromList(_F.capture(bits));
  }

  /// Creates a [MoveShiftedRegister] converting a previously [decoded] list.
  factory MoveShiftedRegister.fromList(List<int> decoded) {
    return MoveShiftedRegister(
      opcode: decoded[0],
      offset: decoded[1],
      registerS: decoded[2],
      registerD: decoded[3],
    );
  }

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
        super._(_F);

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
  static final _F = ThumbInstructionSet.$02$addAndSubtract;

  /// OpCode (2-bits).
  final int opcode;

  /// Register `N` or Offset (3-bits).
  final int registerNOrOffset3;

  /// Register `S`.
  final int registerS;

  /// Register `D`.
  final int registerD;

  /// Creates a [AddAndSubtract] by decoding [bits].
  factory AddAndSubtract.decodeBits(int bits) {
    return AddAndSubtract.fromList(_F.capture(bits));
  }

  /// Creates a [AddAndSubtract] converting a previously [decoded] list.
  factory AddAndSubtract.fromList(List<int> decoded) {
    return AddAndSubtract(
      opcode: decoded[0],
      registerNOrOffset3: decoded[1],
      registerS: decoded[2],
      registerD: decoded[3],
    );
  }

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
        super._(_F);

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
  static final _F = ThumbInstructionSet.$03$moveCompareAddAndSubtractImmediate;

  /// OpCode (2-bits).
  final int opcode;

  /// Register `D` (3-bits).
  final int registerD;

  /// Offset (8-bits).
  final int offset;

  /// Creates a [MoveCompareAddAndSubtractImmediate] by decoding [bits].
  factory MoveCompareAddAndSubtractImmediate.decodeBits(int bits) {
    return MoveCompareAddAndSubtractImmediate.fromList(_F.capture(bits));
  }

  /// Creates a [MoveCompareAddAndSubtractImmediate] converting a previously [decoded] list.
  factory MoveCompareAddAndSubtractImmediate.fromList(List<int> decoded) {
    return MoveCompareAddAndSubtractImmediate(
      opcode: decoded[0],
      registerD: decoded[1],
      offset: decoded[2],
    );
  }

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
        super._(_F);

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
  static final _F = ThumbInstructionSet.$04$aluOperation;

  /// OpCode (4-bits).
  final int opcode;

  /// Register `S` (3-bits).
  final int registerS;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [ALUOperation] by decoding [bits].
  factory ALUOperation.decodeBits(int bits) {
    return ALUOperation.fromList(_F.capture(bits));
  }

  /// Creates a [ALUOperation] converting a previously [decoded] list.
  factory ALUOperation.fromList(List<int> decoded) {
    return ALUOperation(
      opcode: decoded[0],
      registerS: decoded[1],
      registerD: decoded[2],
    );
  }

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
        super._(_F);

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
  static final _F = ThumbInstructionSet.$05$highRegisterOperationsAndBranch;

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

  /// Creates a [HighRegisterOperationsAndBranchExchange] by decoding [bits].
  factory HighRegisterOperationsAndBranchExchange.decodeBits(int bits) {
    return HighRegisterOperationsAndBranchExchange.fromList(_F.capture(bits));
  }

  /// Creates a [HighRegisterOperationsAndBranchExchange] converting a previously [decoded] list.
  factory HighRegisterOperationsAndBranchExchange.fromList(List<int> decoded) {
    return HighRegisterOperationsAndBranchExchange(
      opcode: decoded[0],
      h1: decoded[1],
      h2: decoded[2],
      registerSOrHS: decoded[3],
      registerDOrHD: decoded[4],
    );
  }

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
        super._(_F);

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
  static final _F = ThumbInstructionSet.$06$pcRelativeLoad;

  /// Register `D` (3-bits).
  final int registerD;

  /// Word (8-bits).
  final int word8;

  /// Creates a [PCRelativeLoad] by decoding [bits].
  factory PCRelativeLoad.decodeBits(int bits) {
    return PCRelativeLoad.fromList(_F.capture(bits));
  }

  /// Creates a [PCRelativeLoad] converting a previously [decoded] list.
  factory PCRelativeLoad.fromList(List<int> decoded) {
    return PCRelativeLoad(
      registerD: decoded[0],
      word8: decoded[1],
    );
  }

  /// Creates a [PCRelativeLoad] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  PCRelativeLoad({
    @required this.registerD,
    @required this.word8,
  })  : assert(registerD != null),
        assert(word8 != null),
        super._(_F);

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
  static final _F = ThumbInstructionSet.$07$loadAndStoreWithRelativeOffset;

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

  /// Creates a [LoadAndStoreWithRelativeOffset] by decoding [bits].
  factory LoadAndStoreWithRelativeOffset.decodeBits(int bits) {
    return LoadAndStoreWithRelativeOffset.fromList(_F.capture(bits));
  }

  /// Creates a [LoadAndStoreWithRelativeOffset] converting a previously [decoded] list.
  factory LoadAndStoreWithRelativeOffset.fromList(List<int> decoded) {
    return LoadAndStoreWithRelativeOffset(
      l: decoded[0],
      b: decoded[1],
      registerO: decoded[2],
      registerB: decoded[3],
      registerD: decoded[4],
    );
  }

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
        super._(_F);

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
  static final _F = ThumbInstructionSet.$08$loadAndStoreSignExtended;

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

  /// Creates a [LoadAndStoreSignExtendedByteAndHalfWord] by decoding [bits].
  factory LoadAndStoreSignExtendedByteAndHalfWord.decodeBits(int bits) {
    return LoadAndStoreSignExtendedByteAndHalfWord.fromList(_F.capture(bits));
  }

  /// Creates a [LoadAndStoreSignExtendedByteAndHalfWord] converting a previously [decoded] list.
  factory LoadAndStoreSignExtendedByteAndHalfWord.fromList(List<int> decoded) {
    return LoadAndStoreSignExtendedByteAndHalfWord(
      h: decoded[0],
      s: decoded[1],
      registerO: decoded[2],
      registerB: decoded[3],
      registerD: decoded[4],
    );
  }

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
        super._(_F);

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
  static final _F = ThumbInstructionSet.$09$loadAndStoreWithImmediateOffset;

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

  /// Creates a [LoadAndStoreWithImmediateOffset] by decoding [bits].
  factory LoadAndStoreWithImmediateOffset.decodeBits(int bits) {
    return LoadAndStoreWithImmediateOffset.fromList(_F.capture(bits));
  }

  /// Creates a [LoadAndStoreWithImmediateOffset] converting a previously [decoded] list.
  factory LoadAndStoreWithImmediateOffset.fromList(List<int> decoded) {
    return LoadAndStoreWithImmediateOffset(
      b: decoded[0],
      l: decoded[1],
      offset5: decoded[2],
      registerB: decoded[3],
      registerD: decoded[4],
    );
  }

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
        super._(_F);

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
  static final _F = ThumbInstructionSet.$10$loadAndStoreHalfword;

  /// `L` (1-bit).
  final int l;

  /// Offset (5-bits).
  final int offset5;

  /// Register `B` (3-bits).
  final int registerB;

  /// Register `D` (3-bits).
  final int registerD;

  /// Creates a [LoadAndStoreHalfWord] by decoding [bits].
  factory LoadAndStoreHalfWord.decodeBits(int bits) {
    return LoadAndStoreHalfWord.fromList(_F.capture(bits));
  }

  /// Creates a [LoadAndStoreHalfWord] converting a previously [decoded] list.
  factory LoadAndStoreHalfWord.fromList(List<int> decoded) {
    return LoadAndStoreHalfWord(
      l: decoded[0],
      offset5: decoded[1],
      registerB: decoded[2],
      registerD: decoded[3],
    );
  }

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
        super._(_F);

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
  static final _F = ThumbInstructionSet.$11$spRelativeLoadAndStore;

  /// `L` (1-bit).
  final int l;

  /// Register `D` (3-bits).
  final int registerD;

  /// Word (8-bits).
  final int word8;

  /// Creates a [SPRelativeLoadAndStore] by decoding [bits].
  factory SPRelativeLoadAndStore.decodeBits(int bits) {
    return SPRelativeLoadAndStore.fromList(_F.capture(bits));
  }

  /// Creates a [SPRelativeLoadAndStore] converting a previously [decoded] list.
  factory SPRelativeLoadAndStore.fromList(List<int> decoded) {
    return SPRelativeLoadAndStore(
      l: decoded[0],
      registerD: decoded[1],
      word8: decoded[2],
    );
  }

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
        super._(_F);

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
  static final _F = ThumbInstructionSet.$12$loadAddress;

  /// `SP` (1-bit).
  final int sp;

  /// Register `D` (3-bits).
  final int registerD;

  /// Word (8-bits).
  final int word8;

  /// Creates a [LoadAddress] by decoding [bits].
  factory LoadAddress.decodeBits(int bits) {
    return LoadAddress.fromList(_F.capture(bits));
  }

  /// Creates a [LoadAddress] converting a previously [decoded] list.
  factory LoadAddress.fromList(List<int> decoded) {
    return LoadAddress(
      sp: decoded[0],
      registerD: decoded[1],
      word8: decoded[2],
    );
  }

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
        super._(_F);

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
  static final _F = ThumbInstructionSet.$13$addOffsetToStackPointer;

  /// `S` (1-bit).
  final int s;

  /// S-Word (7-bits).
  final int sWord7;

  /// Creates a [AddOffsetToStackPointer] by decoding [bits].
  factory AddOffsetToStackPointer.decodeBits(int bits) {
    return AddOffsetToStackPointer.fromList(_F.capture(bits));
  }

  /// Creates a [AddOffsetToStackPointer] converting a previously [decoded] list.
  factory AddOffsetToStackPointer.fromList(List<int> decoded) {
    return AddOffsetToStackPointer(
      s: decoded[0],
      sWord7: decoded[1],
    );
  }

  /// Creates a [AddOffsetToStackPointer] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  AddOffsetToStackPointer({
    @required this.s,
    @required this.sWord7,
  })  : assert(s != null),
        assert(sWord7 != null),
        super._(_F);

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
  static final _F = ThumbInstructionSet.$14$pushAndPopRegisters;

  /// `L` (1-bit).
  final int l;

  /// `R` (1-bit).
  final int r;

  /// Register list (8-bits).
  final int registerList;

  /// Creates a [PushAndPopRegisters] by decoding [bits].
  factory PushAndPopRegisters.decodeBits(int bits) {
    return PushAndPopRegisters.fromList(_F.capture(bits));
  }

  /// Creates a [PushAndPopRegisters] converting a previously [decoded] list.
  factory PushAndPopRegisters.fromList(List<int> decoded) {
    return PushAndPopRegisters(
      l: decoded[0],
      r: decoded[1],
      registerList: decoded[2],
    );
  }

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
        super._(_F);

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
  static final _F = ThumbInstructionSet.$15$multipleLoadAndStore;

  /// `L` (1-bit).
  final int l;

  /// Register `B` (3-bits).
  final int registerB;

  /// Register list (8-bits).
  final int registerList;

  /// Creates a [MultipleLoadAndStore] by decoding [bits].
  factory MultipleLoadAndStore.decodeBits(int bits) {
    return MultipleLoadAndStore.fromList(_F.capture(bits));
  }

  /// Creates a [MultipleLoadAndStore] converting a previously [decoded] list.
  factory MultipleLoadAndStore.fromList(List<int> decoded) {
    return MultipleLoadAndStore(
      l: decoded[0],
      registerB: decoded[1],
      registerList: decoded[2],
    );
  }

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
        super._(_F);

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
  static final _F = ThumbInstructionSet.$16$conditionalBranch;

  /// Condition (4-bits).
  final int condition;

  /// Softset (8-bits).
  final int softSet8;

  /// Creates a [ConditionalBranch] by decoding [bits].
  factory ConditionalBranch.decodeBits(int bits) {
    return ConditionalBranch.fromList(_F.capture(bits));
  }

  /// Creates a [ConditionalBranch] converting a previously [decoded] list.
  factory ConditionalBranch.fromList(List<int> decoded) {
    return ConditionalBranch(
      condition: decoded[0],
      softSet8: decoded[1],
    );
  }

  /// Creates a [ConditionalBranch] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  ConditionalBranch({
    @required this.condition,
    @required this.softSet8,
  })  : assert(condition != null),
        assert(softSet8 != null),
        super._(_F);

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
  static final _F = ThumbInstructionSet.$17$softwareInterrupt;

  /// Value (8-bits).
  final int value8;

  /// Creates a [SoftwareInterrupt] by decoding [bits].
  factory SoftwareInterrupt.decodeBits(int bits) {
    return SoftwareInterrupt.fromList(_F.capture(bits));
  }

  /// Creates a [SoftwareInterrupt] converting a previously [decoded] list.
  factory SoftwareInterrupt.fromList(List<int> decoded) {
    return SoftwareInterrupt(
      value8: decoded[0],
    );
  }

  /// Creates a [SoftwareInterrupt] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  SoftwareInterrupt({
    @required this.value8,
  })  : assert(value8 != null),
        super._(_F);

  @override
  Map<String, Object> toJson() {
    return {
      'Value8': value8,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$18$unconditionalBranch].
class UnconditionalBranch extends ThumbInstructionSet {
  static final _F = ThumbInstructionSet.$18$unconditionalBranch;

  /// Offset (11-bits).
  final int offset11;

  /// Creates a [UnconditionalBranch] by decoding [bits].
  factory UnconditionalBranch.decodeBits(int bits) {
    return UnconditionalBranch.fromList(_F.capture(bits));
  }

  /// Creates a [UnconditionalBranch] converting a previously [decoded] list.
  factory UnconditionalBranch.fromList(List<int> decoded) {
    return UnconditionalBranch(
      offset11: decoded[0],
    );
  }

  /// Creates a [UnconditionalBranch] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  UnconditionalBranch({
    @required this.offset11,
  })  : assert(offset11 != null),
        super._(_F);

  @override
  Map<String, Object> toJson() {
    return {
      'Offset11': offset11,
    };
  }
}

/// Decoded object from [ThumbInstructionSet.$19$longBranchWithLink].
class LongBranchWithLink extends ThumbInstructionSet {
  static final _F = ThumbInstructionSet.$19$longBranchWithLink;

  /// `H` (1-bit).
  final int h;

  /// Offset (11-bits).
  final int offset;

  /// Creates a [LongBranchWithLink] by decoding [bits].
  factory LongBranchWithLink.decodeBits(int bits) {
    return LongBranchWithLink.fromList(_F.capture(bits));
  }

  /// Creates a [LongBranchWithLink] converting a previously [decoded] list.
  factory LongBranchWithLink.fromList(List<int> decoded) {
    return LongBranchWithLink(
      h: decoded[0],
      offset: decoded[1],
    );
  }

  /// Creates a [LongBranchWithLink] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  LongBranchWithLink({
    @required this.h,
    @required this.offset,
  })  : assert(h != null),
        assert(offset != null),
        super._(_F);

  @override
  Map<String, Object> toJson() {
    return {
      'H': h,
      'Offset': offset,
    };
  }
}

/*
/// Decoded object from [ThumbInstructionSet.X].
class NAME extends ThumbInstructionSet {
  static final _F = ThumbInstructionSet.X;

  /// Creates a [NAME] by decoding [bits].
  factory NAME.decodeBits(int bits) {
    return NAME.fromList(_F.capture(bits));
  }

  /// Creates a [NAME] converting a previously [decoded] list.
  factory NAME.fromList(List<int> decoded) {
    return NAME(
      opcode: decoded[0],
    );
  }

  /// Creates a [NAME] from the provided variables.
  ///
  /// > **NOTE**: Bits are **not** checked for correctness or size!
  NAME({
    @required this.opcode,
  })  : assert(opcode != null),
        super._(_F);

  @override
  Map<String, Object> toJson() {
    return {
      'Op': opcode,
    };
  }
}
*/
