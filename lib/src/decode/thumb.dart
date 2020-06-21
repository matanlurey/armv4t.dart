import 'package:binary/binary.dart';

/// An **internal** package representing all known `THUMB` instruction sets.
///
/// For testing, individual [BitPattern] implementations are accessible as
/// static fields (e.g. `[$01$moveShiftedRegister]`), and a sorted
/// [BitPatternGrpup] is accessible as [allFormats].
class ThumbInstructionSet {
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
    '1010_SDDD_WWWW_WWWW',
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

  const ThumbInstructionSet._();
}
