enum Condition {
  /// `operand1 AND operand2`.
  ///
  /// OpCode: `0000`.
  AND,

  /// `operand1 EOR operand2`.
  ///
  /// OpCode: `0001`.
  EOR,

  /// `operand1 - operand2`.
  ///
  /// OpCode: `0010`.
  SUB,

  /// `operand2 - operand1`.
  ///
  /// OpCode: `0011`.
  RSB,

  /// `operand1 + operand2`.
  ///
  /// OpCode: `0100`.
  ADD,

  /// `operand + operand2 + carry`.
  ///
  /// OpCode: `0101`.
  ADC,

  /// `operand1 - operand2 + carry - 1`.
  ///
  /// OpCode: `0110`.
  SBC,

  /// `operand2 - operand1 + carry - 1`.
  ///
  /// OpCode: `0111`.
  RSC,

  /// [AND], but result is not written.
  ///
  /// OpCode: `1000`.
  TST,

  /// [EOR], but result is not written.
  ///
  /// OpCode: `1001`.
  TEQ,

  /// [SUB], but result is not written.
  ///
  /// OpCode: `1010`.
  CMP,

  /// [ADD], but result is not written.
  ///
  /// OpCode: `1011`.
  CMN,

  /// `operand1 OR operand2`.
  ///
  /// OpCode: `1100`.
  ORR,

  /// `operand2` (`operand1` is ignored).
  ///
  /// OpCode: `1101`.
  MOV,

  /// `operand1 AND NOT operand2` (Bit clear).
  ///
  /// OpCode: `1110`.
  BIC,

  /// `NOT operand2` (`operand1` is ignored).
  ///
  /// OpCode: `1111`.
  MVN,
}

/// Able to [decodeBits] ([int]) into a [Condition].
class ArmConditionDecoder {
  const ArmConditionDecoder();

  /// Returns [bits] as a decoded `ARM` [Condition] code
  Condition decodeBits(int bits) {
    switch (bits) {
      case 0x0:
        return Condition.AND;
      case 0x1:
        return Condition.EOR;
      case 0x2:
        return Condition.SUB;
      case 0x3:
        return Condition.RSB;
      case 0x4:
        return Condition.ADD;
      case 0x5:
        return Condition.ADC;
      case 0x6:
        return Condition.SBC;
      case 0x7:
        return Condition.RSC;
      case 0x8:
        return Condition.TST;
      case 0x9:
        return Condition.TEQ;
      case 0xA:
        return Condition.CMP;
      case 0xB:
        return Condition.CMN;
      case 0xC:
        return Condition.ORR;
      case 0xD:
        return Condition.MOV;
      case 0xE:
        return Condition.BIC;
      case 0xF:
        return Condition.MVN;
      default:
        throw ArgumentError.value(bits, 'bits');
    }
  }
}

extension ConditionX on Condition {
  /// Applies to the appropriate sub-method of [visitor], optionally [context].
  R accept<R, C>(ArmConditionVisitor<R, C> visitor, [C context]) {
    switch (this) {
      case Condition.AND:
        return visitor.visitAND(context);
      case Condition.EOR:
        return visitor.visitEOR(context);
      case Condition.SUB:
        return visitor.visitSUB(context);
      case Condition.RSB:
        return visitor.visitRSB(context);
      case Condition.ADD:
        return visitor.visitADD(context);
      case Condition.ADC:
        return visitor.visitADC(context);
      case Condition.SBC:
        return visitor.visitSBC(context);
      case Condition.RSC:
        return visitor.visitRSC(context);
      case Condition.TST:
        return visitor.visitTST(context);
      case Condition.TEQ:
        return visitor.visitTEQ(context);
      case Condition.CMP:
        return visitor.visitCMP(context);
      case Condition.CMN:
        return visitor.visitCMN(context);
      case Condition.ORR:
        return visitor.visitORR(context);
      case Condition.MOV:
        return visitor.visitMOV(context);
      case Condition.BIC:
        return visitor.visitBIC(context);
      case Condition.MVN:
        return visitor.visitMVN(context);
      default:
        throw ArgumentError.notNull();
    }
  }
}

/// Visitor methods for a given [Condition].
abstract class ArmConditionVisitor<R, C> {
  R visitAND([C context]);
  R visitEOR([C context]);
  R visitSUB([C context]);
  R visitRSB([C context]);
  R visitADD([C context]);
  R visitADC([C context]);
  R visitSBC([C context]);
  R visitRSC([C context]);
  R visitTST([C context]);
  R visitTEQ([C context]);
  R visitCMP([C context]);
  R visitCMN([C context]);
  R visitORR([C context]);
  R visitMOV([C context]);
  R visitBIC([C context]);
  R visitMVN([C context]);
}
