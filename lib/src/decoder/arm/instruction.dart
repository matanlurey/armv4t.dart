import 'package:armv4t/src/common/binary.dart';
import 'package:armv4t/src/common/union.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

import 'condition.dart';

part 'instruction/arithmetic.dart';
part 'instruction/arithmetic/adc.dart';
part 'instruction/arithmetic/add.dart';
part 'instruction/arithmetic/cmn.dart';
part 'instruction/arithmetic/cmp.dart';
part 'instruction/arithmetic/rsb.dart';
part 'instruction/arithmetic/rsc.dart';
part 'instruction/arithmetic/sbc.dart';
part 'instruction/arithmetic/sub.dart';
part 'instruction/logical/and.dart';
part 'instruction/logical/bic.dart';
part 'instruction/logical/eor.dart';
part 'instruction/logical/mov.dart';
part 'instruction/logical/mvn.dart';
part 'instruction/logical/orr.dart';
part 'instruction/logical/teq.dart';
part 'instruction/logical/tst.dart';
part 'instruction/memory.dart';
part 'instruction/multiply.dart';
part 'instruction/multiply/mla.dart';
part 'instruction/multiply/mul.dart';
part 'instruction/multiply/smlal.dart';
part 'instruction/multiply/smull.dart';
part 'instruction/multiply/umlal.dart';
part 'instruction/multiply/umull.dart';
part 'instruction/other.dart';
part 'instruction/other/mrs.dart';
part 'instruction/other/msr.dart';

@immutable
@sealed
abstract class ArmInstruction {
  /// Conditional execution type.
  final Condition condition;

  const ArmInstruction._({
    @required this.condition,
  });
}

///
abstract class MaySetConditionCodes implements ArmInstruction {
  /// Whether to set condition codes on the PSR.
  bool get setConditionCodes;
}

abstract class ArmInstructionVisitor {}

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

class ShiftedImmediate<T extends Integral<T>> {}

class ShiftedRegister<T extends Shiftable<T>> {}

class ShiftType {
  const ShiftType._();
}
