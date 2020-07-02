import 'package:binary/binary.dart';

/// An indirect way to return a value [R]
abstract class ArmFormatVisitor<R, C> {
  R visitDataProcessingOrPsrTransfer(List<int> bits);
  R visitMultiplyAndMultiplyLongAccumulate(List<int> bits);
  R visitSingleDataSwap(List<int> bits);
  R visitBranchAndExchange(List<int> bits);
  R visitHalfWordDataTransfer(List<int> bits);
  R visitBlockDataTransfer(List<int> bits);
  R visitBranch(List<int> bits);
  R visitSoftwareInterrupt(List<int> bits);
}

final _patternDataProcessingOrPsrTransfer = BitPatternBuilder.parse(
  'CCCC_00IP_PPPS_NNNN_DDDD_OOOO_OOOO_OOOO',
).build('DATA_PROCESSING_OR_PSR_TRANSFER');

final _patternMultiply = BitPatternBuilder.parse(
  'CCCC_000P_PPPS_DDDD_NNNN_FFFF_1001_MMMM',
).build('MULTIPLY_AND_MULTIPLY_LONG_ACCUMULATE');

final _patternSingleDataSwap = BitPatternBuilder.parse(
  'CCCC_0001_0B00_NNNN_DDDD_0000_1001_MMMM',
).build('SINGLE_DATA_SWAP');

final _patternBranchAndExchange = BitPatternBuilder.parse(
  'CCCC_0001_0010_1111_1111_1111_0001_NNNN',
).build('BRANCH_AND_EXCHANGE');

final _patternHalfWordDataTransfer = BitPatternBuilder.parse(
  'CCCC_000P_UIWL_NNNN_DDDD_0000_1HH1_MMMM',
).build('HALF_WORD_DATA_TRANSFER');

final _patternBlockDataTransfer = BitPatternBuilder.parse(
  'CCCC_100P_USWL_NNNN_RRRR_RRRR_RRRR_RRRR',
).build('BLOCK_DATA_TRANSFER');

final _patternBranch = BitPatternBuilder.parse(
  'CCCC_101L_OOOO_OOOO_OOOO_OOOO_OOOO_OOOO',
).build('BRANCH');

final _patternSoftwareInterrupt = BitPatternBuilder.parse(
  'CCCC_1111_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX',
).build('SOFTWARE_INTERRUPT');

abstract class ArmInstruction {}
