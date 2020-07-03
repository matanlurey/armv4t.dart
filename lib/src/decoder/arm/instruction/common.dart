part of '../instruction.dart';

abstract class MaySetConditionCodes implements ArmInstruction {
  /// Whether to set condition codes on the PSR.
  bool get setConditionCodes;
}

class Address {}

class AddressingMode {}

class Comment {}

class Immediate<T extends Integral<T>> implements Shiftable<Immediate<T>> {}

class Label {}

abstract class Register<R extends Register<R>> implements Shiftable<R> {
  static final filledWith0s = RegisterAny(Uint4.zero);
  static final filledWith1s = RegisterAny(Uint4(15));

  final Uint4 index;

  Register._(this.index);
}

class RegisterAny extends Register<RegisterAny> {
  RegisterAny(Uint4 index) : super._(index);
}

class RegisterNotPC extends Register<RegisterNotPC> {
  RegisterNotPC(Uint4 index) : super._(index) {
    if (index.value == 15) {
      throw RangeError.range(index.value, 0, 14);
    }
  }
}

class RegisterList<R extends Register<R>> {}

abstract class Shiftable<T extends Shiftable<T>> {}

class ShiftedImmediate<T extends Integral<T>> {
  /// ROR-Shift applied to [immediate] (`0-30`, in steps of 2).
  final Uint4 rorShift;

  /// Immediate value.
  final T immediate;

  const ShiftedImmediate(this.rorShift, this.immediate);
}

class ShiftedRegister<T extends Shiftable<T>> {}

class ShiftType {
  const ShiftType._();
}
