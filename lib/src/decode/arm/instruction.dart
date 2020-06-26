import 'package:armv4t/src/utils.dart';
import 'package:meta/meta.dart';

import 'format.dart';
import 'printer.dart';

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
