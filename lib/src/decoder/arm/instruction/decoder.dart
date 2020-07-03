part of '../instruction.dart';

class ArmInstructionDecoder implements ArmFormatVisitor<ArmInstruction, void> {
  const ArmInstructionDecoder();

  @override
  ArmInstruction visitDataProcessingOrPsrTransfer(
    DataProcessingOrPsrTransfer format, [
    void _,
  ]) {
    final condition = Condition.parse(format.condition.value);
    final opCode = _ALUOpCode.values[format.opCode.value];
    if (!format.setConditionCodes) {
      switch (opCode) {
        case _ALUOpCode.TEQ:
        case _ALUOpCode.TST:
        case _ALUOpCode.CMP:
        case _ALUOpCode.CMN:
          return _decodePsrTransfer(format, opCode.index.isSet(0));
        default:
          break;
      }
    }
    final setConditionCodes = format.setConditionCodes;
    final operand1 = RegisterAny(format.operand1Register);
    final destination = RegisterAny(format.destinationRegister);

    Or3<
        ShiftedRegister<Immediate<Uint8>>,
        /**/
        ShiftedRegister<RegisterNotPC>,
        /**/
        ShiftedImmediate<Uint8>> operand2;

    if (format.immediateOperand) {
      // I = 1
      final rorShift = format.operand2.bitRange(11, 8).value.asUint4();
      final immediate = format.operand2.bitRange(7, 0).value.asUint8();
      operand2 = Or3.right(ShiftedImmediate(rorShift, immediate));
    } else {
      // I = 0
      final shiftByRegister = format.operand2.isSet(4);
      if (shiftByRegister) {
        // R = 1
        // TODO: Complete.
        operand2 = Or3.middle(null);
      } else {
        // R = 0
        // TODO: Complete.
        operand2 = Or3.left(null);
      }
    }

    switch (opCode) {
      case _ALUOpCode.AND:
        return AND(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.EOR:
        return EOR(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.SUB:
        return SUB(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.RSB:
        return RSB(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.ADD:
        return ADD(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.ADC:
        return ADC(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.SBC:
        return SBC(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.RSC:
        return RSC(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.TST:
        return TST(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.TEQ:
        return TEQ(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.CMP:
        return CMP(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.CMN:
        return CMN(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.ORR:
        return ORR(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.MOV:
        return MOV(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.BIC:
        return BIC(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      case _ALUOpCode.MVN:
        return MVN(
          condition: condition,
          setConditionCodes: setConditionCodes,
          operand1: operand1,
          destination: destination,
          operand2: operand2,
        );
      default:
        throw StateError('Should not be a possible result');
    }
  }

  PsrTransferArmInstruction _decodePsrTransfer(
    DataProcessingOrPsrTransfer format,
    bool isMSR,
  ) {
    throw UnimplementedError();
  }

  @override
  MultiplyAndMultiplyLongArmInstruction visitMultiply(
    Multiply format, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  MultiplyAndMultiplyLongArmInstruction visitMultiplyLong(
    MultiplyLong format, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  SWP visitSingleDataSwap(
    SingleDataSwap format, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  BX visitBranchAndExchange(
    BranchAndExchange format, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  HalfwordDataTransferArmInstruction visitHalfwordDataTransfer(
    HalfwordDataTransfer format, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  SingleDataTransferArmInstruction visitSingleDataTransfer(
    SingleDataTransfer format, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  BlockDataTransferArmInstruction visitBlockDataTransfer(
    BlockDataTransfer format, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  ArmInstruction visitBranch(
    Branch format, [
    void _,
  ]) =>
      throw UnimplementedError();

  @override
  SWI visitSoftwareInterrupt(
    SoftwareInterrupt format, [
    void _,
  ]) =>
      throw UnimplementedError();
}

enum _ALUOpCode {
  AND,
  EOR,
  SUB,
  RSB,
  ADD,
  ADC,
  SBC,
  RSC,
  TST,
  TEQ,
  CMP,
  CMN,
  ORR,
  MOV,
  BIC,
  MVN,
}
