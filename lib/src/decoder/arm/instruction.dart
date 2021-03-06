/// Decoding instructions specific to `ARM`.
///
/// {@category ARM}
/// {@subCategory Instructions}
library armv4t.decoder.arm.instruction;

import 'package:armv4t/decode.dart';
import 'package:armv4t/src/common/assert.dart';
import 'package:armv4t/src/common/binary.dart';
import 'package:armv4t/src/common/union.dart';
import 'package:armv4t/src/decoder/common.dart';
import 'package:binary/binary.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'condition.dart';
import 'format.dart';
import 'printer.dart';

part 'instruction/arithmetic.dart';
part 'instruction/arithmetic/adc.dart';
part 'instruction/arithmetic/add.dart';
part 'instruction/arithmetic/cmn.dart';
part 'instruction/arithmetic/cmp.dart';
part 'instruction/arithmetic/rsb.dart';
part 'instruction/arithmetic/rsc.dart';
part 'instruction/arithmetic/sbc.dart';
part 'instruction/arithmetic/sub.dart';
part 'instruction/decoder.dart';
part 'instruction/logical/and.dart';
part 'instruction/logical/bic.dart';
part 'instruction/logical/eor.dart';
part 'instruction/logical/mov.dart';
part 'instruction/logical/mvn.dart';
part 'instruction/logical/orr.dart';
part 'instruction/logical/teq.dart';
part 'instruction/logical/tst.dart';
part 'instruction/memory.dart';
part 'instruction/memory/ldm.dart';
part 'instruction/memory/ldr.dart';
part 'instruction/memory/ldrh.dart';
part 'instruction/memory/ldrsb.dart';
part 'instruction/memory/ldrsh.dart';
part 'instruction/memory/stm.dart';
part 'instruction/memory/str.dart';
part 'instruction/memory/strh.dart';
part 'instruction/memory/swp.dart';
part 'instruction/multiply.dart';
part 'instruction/multiply/mla.dart';
part 'instruction/multiply/mul.dart';
part 'instruction/multiply/smlal.dart';
part 'instruction/multiply/smull.dart';
part 'instruction/multiply/umlal.dart';
part 'instruction/multiply/umull.dart';
part 'instruction/other.dart';
part 'instruction/other/b.dart';
part 'instruction/other/bl.dart';
part 'instruction/other/bx.dart';
part 'instruction/other/mrs.dart';
part 'instruction/other/msr.dart';
part 'instruction/other/swi.dart';
part 'instruction/visitor.dart';

@immutable
@sealed
abstract class ArmInstruction {
  /// Conditional execution type.
  final Condition condition;

  const ArmInstruction._({
    @required this.condition,
  });

  /// Invokes a specific method of the provided [visitor].
  R accept<R, C>(ArmInstructionVisitor<R, C> visitor, [C context]);

  @override
  int get hashCode => const ListEquality<Object>().hash(_values());

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    }
    if (o is ArmInstruction && runtimeType == o.runtimeType) {
      return const ListEquality<Object>().equals(_values(), o._values());
    } else {
      return false;
    }
  }

  /// Implement in order to automatically implement `==` and [hashCode].
  @protected
  @visibleForOverriding
  List<Object> _values();

  @override
  String toString() {
    if (assertionsEnabled) {
      return accept(const ArmInstructionPrinter());
    } else {
      return super.toString();
    }
  }
}

abstract class MaySetConditionCodes implements ArmInstruction {
  /// Whether to set condition codes on the PSR.
  bool get setConditionCodes;
}
