/// All ARM instructions can be executed conditionally, based on a 4-bit field.
///
/// The processor tests the state of the condition flags in the CPSR (`N`, `Z`,
/// `V`, and `C`) and if the condition flag state matches the condition, the
/// instruction executes normally. If the condition flag state does _not_ match
/// the condition, the instruction is executed as a _NOP_ (no-operation).
///
/// The condition codes are listed as an enumeration. If omitted, the [AL]
/// (always) condition is used to specifiy the instruction should always
/// execute.
///
/// > NOTE: The `index` of the members of this `enum` are significant as they
/// > are also the exact `OpCode` used to match. For example, `0110` (Overflow)
/// > is the same as `0x6`, or `VS.index`.
enum Condition {
  /// Equal (`Z == 1`).
  EQ,

  /// Not Equal (`Z == 0`).
  NE,

  /// Carry Set/Unsigned Higher or Same (`C == 1`).
  CS$HS,

  /// Carry Clear/Unsigned Lower (`C == 0`).
  CC$LO,

  /// Minus/Negative (`N == 1`).
  MI,

  /// Plus/Positive or Zero (`N == 0`).
  PL,

  /// Overflow (`V == 1`).
  VS,

  /// No overflow (`V == 0`).
  VC,

  /// Unsigned higher (`C == 1 && Z == 0`).
  HI,

  /// Unsigned lower or same (`C == 0 || Z == 1`).
  LS,

  /// Signed Greater Than or Equal (`N == V`).
  GE,

  /// Signed Less Than (`N != V`).
  LT,

  /// Signed Greater Than (`Z == 0 && N == V`).
  GT,

  /// Signed Less Than or Equal (`Z == 1 || N != V`).
  LE,

  /// Always (unconditional).
  AL,

  /// Never (obsolete, unpredictable).
  NV,
}

/// Able to [decodeBits] ([int]) into a [Condition].
class ArmConditionDecoder {
  const ArmConditionDecoder();

  /// Returns [bits] as a decoded `ARM` [Condition] code
  Condition decodeBits(int bits) {
    ArgumentError.checkNotNull(bits);
    return Condition.values[bits];
  }
}

extension ConditionX on Condition {
  /// Applies to the appropriate sub-method of [visitor], optionally [context].
  R accept<R, C>(ArmConditionVisitor<R, C> visitor, [C context]) {
    switch (this) {
      case Condition.EQ:
        return visitor.visitEQ(context);
      case Condition.NE:
        return visitor.visitNE(context);
      case Condition.CS$HS:
        return visitor.visitCS$HS(context);
      case Condition.CC$LO:
        return visitor.visitCC$LO(context);
      case Condition.MI:
        return visitor.visitMI(context);
      case Condition.PL:
        return visitor.visitPL(context);
      case Condition.VS:
        return visitor.visitVS(context);
      case Condition.VC:
        return visitor.visitVC(context);
      case Condition.HI:
        return visitor.visitHI(context);
      case Condition.LS:
        return visitor.visitLS(context);
      case Condition.GE:
        return visitor.visitGE(context);
      case Condition.LT:
        return visitor.visitLT(context);
      case Condition.GT:
        return visitor.visitGT(context);
      case Condition.LE:
        return visitor.visitLE(context);
      case Condition.AL:
        return visitor.visitAL(context);
      case Condition.NV:
        return visitor.visitNV(context);
      default:
        throw ArgumentError.notNull();
    }
  }
}

/// Visitor methods for a given [Condition].
abstract class ArmConditionVisitor<R, C> {
  R visitEQ([C context]);
  R visitNE([C context]);
  R visitCS$HS([C context]);
  R visitCC$LO([C context]);
  R visitMI([C context]);
  R visitPL([C context]);
  R visitVS([C context]);
  R visitVC([C context]);
  R visitHI([C context]);
  R visitLS([C context]);
  R visitGE([C context]);
  R visitLT([C context]);
  R visitGT([C context]);
  R visitLE([C context]);
  R visitAL([C context]);
  R visitNV([C context]);
}
