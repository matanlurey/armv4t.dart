import 'package:armv4t/src/utils.dart';
import 'package:meta/meta.dart';

import 'format.dart';
import 'printer.dart';

part 'instruction/branch/b.dart';
part 'instruction/branch/bl.dart';
part 'instruction/branch/bx.dart';
part 'instruction/coprocessor/cdp.dart';
part 'instruction/coprocessor/ldc.dart';
part 'instruction/coprocessor/mcr.dart';
part 'instruction/coprocessor/mrc.dart';
part 'instruction/coprocessor/stc.dart';
part 'instruction/data/ldm.dart';
part 'instruction/data/ldr.dart';
part 'instruction/data/ldrb.dart';
part 'instruction/data/ldrh.dart';
part 'instruction/data/ldrsb.dart';
part 'instruction/data/ldrsh.dart';
part 'instruction/data/mov.dart';
part 'instruction/data/mrs.dart';
part 'instruction/data/msr.dart';
part 'instruction/data/mvn.dart';
part 'instruction/data/stm.dart';
part 'instruction/data/str.dart';
part 'instruction/data/strb.dart';
part 'instruction/data/strh.dart';
part 'instruction/math/adc.dart';
part 'instruction/math/add.dart';
part 'instruction/math/mla.dart';
part 'instruction/math/mlal.dart';
part 'instruction/math/mul.dart';
part 'instruction/math/mull.dart';
part 'instruction/math/rsb.dart';
part 'instruction/math/rsc.dart';
part 'instruction/math/sbc.dart';
part 'instruction/math/smlal.dart';
part 'instruction/math/smull.dart';
part 'instruction/math/sub.dart';
part 'instruction/math/umlal.dart';
part 'instruction/math/umull.dart';
part 'instruction/misc/swi.dart';
part 'instruction/misc/swp.dart';
part 'instruction/misc/swpb.dart';

/// An **internal** representation of a decoded `ARM` instruction.
abstract class ArmInstruction {
  /// Condition field.
  final int condition;

  const ArmInstruction._(this.condition);

  /// Invokes the correct sub-method of [visitor], optionally with [context].
  R accept<R, C>(
    ArmInstructionVisitor<R, C> visitor, [
    C context,
  ]);

  @override
  String toString() {
    if (assertionsEnabled) {
      return accept(const ArmInstructionPrinter());
    } else {
      return super.toString();
    }
  }
}

/// Further decodes an [ArmInstructionSet] into an [ArmInstruction].
class ArmDecoder implements ArmSetVisitor<ArmInstruction, void> {
  @override
  ArmInstruction visitDataProcessingOrPSRTransfer(
    DataProcessingOrPSRTransfer instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitMultiplyAndMutiplyAccumulate(
    MultiplyAndMutiplyAccumulate instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitMultiplyLongAndMutiplyAccumulateLong(
    MultiplyLongAndMutiplyAccumulateLong instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitSingleDataSwap(
    SingleDataSwap instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitBranchAndExchange(
    BranchAndExchange instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitHalfWordAndSignedDataTransferRegisterOffset(
    HalfWordAndSignedDataTransferRegisterOffset instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitHalfWordAndSignedDataTransferImmediateOffset(
    HalfWordAndSignedDataTransferImmediateOffset instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitSingleDataTransfer(
    SingleDataTransfer instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitUndefined(
    Undefined instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitBlockDataTransfer(
    BlockDataTransfer instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitBranch(
    Branch instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitCoprocessorDataTransfer(
    CoprocessorDataTransfer instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitCoprocessorDataOperation(
    CoprocessorDataOperation instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitCoprocessorRegisterTransfer(
    CoprocessorRegisterTransfer instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }

  @override
  ArmInstruction visitSoftwareInterrupt(
    SoftwareInterrupt instruction, [
    void _,
  ]) {
    throw UnimplementedError();
  }
}

abstract class ArmInstructionVisitor<R, C> {}
