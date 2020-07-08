import 'dart:typed_data';

import 'package:armv4t/src/common/binary.dart';
import 'package:binary/binary.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// Represents a comment-field that is not significant to the processor.
@immutable
@sealed
class Comment {
  /// 24-bit unsigned integer.
  final Uint24 value;

  const Comment(this.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object o) => o is Comment && value == o.value;
}

/// Represents an immediate value.
@immutable
@sealed
class Immediate<T extends Integral<T>> implements Shiftable<Immediate<T>> {
  /// Wrapped immediate value of size and type [T].
  final T value;

  const Immediate(this.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object o) => o is Immediate && value == o.value;
}

/// Represents a reference to a register.
///
/// The concrete implementations are [RegisterAny] and [RegisterNotPC].
///
/// Note that two registers are considered equal if the [index] is the same.
@immutable
@sealed
abstract class Register<R extends Register<R>>
    implements
        /**/ Comparable<Register<R>>,
        /**/ Shiftable<R> {
  /// A register that is zero-filled (`0000`).
  static final filledWith0s = RegisterAny(Uint4.zero);

  /// A register that is one-filled (`0000`).
  static final filledWith1s = RegisterAny(Uint4(15));

  final Uint4 index;

  Register._(this.index);

  @override
  int compareTo(Register<void> other) => index.compareTo(other.index);

  @override
  int get hashCode => index.hashCode;

  @override
  bool operator ==(Object o) => o is Register && index == o.index;

  /// Whether this refers to the program counter (`r15`).
  bool get isProgramCounter => index.value == 15;
}

/// A register that referes to any index (0-15).
@immutable
@sealed
class RegisterAny extends Register<RegisterAny> {
  /// Stack pointer (`RegisterAny(Uint4(13))`).
  static final sp = RegisterAny(Uint4(13));

  /// Link register (`RegisterAny(Uint4(14))`).
  static final lr = RegisterAny(Uint4(14));

  /// Program counter (`RegisterAny(Uint4(15))`).
  static final pc = RegisterAny(Uint4(15));

  RegisterAny(Uint4 index) : super._(index);
}

/// A register that _cannot_ refer to `r15` (`PC`).
@immutable
@sealed
class RegisterNotPC extends Register<RegisterNotPC> {
  /// Link register (`RegisterNotPC(Uint4(14))`).
  static final lr = RegisterNotPC(Uint4(14));

  /// Stack pointer (`RegisterNotPC(Uint4(15))`).
  static final sp = RegisterNotPC(Uint4(15));

  RegisterNotPC(Uint4 index) : super._(index) {
    if (index.value == 15) {
      throw RangeError.range(index.value, 0, 14);
    }
  }
}

/// A list of registers, normally parsed from a mask.
///
/// If `R == RegisterNotPC`, the register `r15` (`PC`) cannot be referenced.
@immutable
@sealed
class RegisterList<R extends Register<R>> {
  factory RegisterList.parse(int bitMask) {
    if (bitMask == 0) {
      return RegisterList._(Uint8List(0));
    } else {
      return RegisterList._(
        Uint8List.fromList([
          for (var i = 0; i < bitMask.bitLength; i++) if (bitMask.isSet(i)) i
        ]),
      );
    }
  }

  factory RegisterList(Set<Uint4> values) {
    if (values.contains(Uint4(15))) {
      throw RangeError.range(15, 0, 14);
    }
    final sorted = values.map((v) => v.value).toList()..sort();
    return RegisterList._(
      UnmodifiableUint8ListView(Uint8List.fromList(sorted)),
    );
  }

  /// Registers being referenced, by index.
  final Uint8List _values;

  RegisterList._(this._values);

  @override
  int get hashCode => const ListEquality<Object>().hash(_values);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    }
    if (o is RegisterList<R>) {
      return const ListEquality<Object>().equals(_values, o._values);
    } else {
      return false;
    }
  }

  /// Registers referenced by this list ordered from r0 onwards.
  Iterable<R> get registers {
    R Function(Uint4) create;
    if (R == RegisterNotPC) {
      create = (value) => RegisterNotPC(value) as R;
    } else {
      create = (value) => RegisterAny(value) as R;
    }
    return _values.map((value) => create(Uint4(value)));
  }
}

/// Represents something that can be used a source or value for shifting.
@immutable
@sealed
abstract class Shiftable<T extends Shiftable<T>> {}

/// Represents a shifted [Immediate] value.
class ShiftedImmediate<I extends Integral<I>> {
  /// ROR-Shift applied to [immediate] (`0-30`, in steps of 2).
  final Uint4 rorShift;

  /// Immediate value.
  final Immediate<I> immediate;

  const ShiftedImmediate(this.rorShift, this.immediate);

  @override
  int get hashCode => rorShift.hashCode ^ immediate.hashCode;

  @override
  bool operator ==(Object o) {
    if (o is ShiftedImmediate<I>) {
      return rorShift == o.rorShift && immediate == o.immediate;
    } else {
      return false;
    }
  }
}

/// Represents a register [operand] that will be shifted [by] another value.
@immutable
@sealed
class ShiftedRegister<T extends Shiftable<T>, R extends Register<R>> {
  /// Operand register.
  final R operand;

  /// Shift type.
  final ShiftType type;

  /// Shift by.
  final T by;

  const ShiftedRegister(this.operand, this.type, this.by);

  @override
  int get hashCode => operand.hashCode ^ type.hashCode ^ by.hashCode;

  @override
  bool operator ==(Object o) {
    if (o is ShiftedRegister<T, R>) {
      return operand == o.operand && type == o.type && by == o.by;
    } else {
      return false;
    }
  }
}

/// Represents types of shifts that can be applied.
enum ShiftType {
  /// `0x0`: Logical shift-left (`<<`).
  LSL,

  /// `0x1:` Logical shift-right (`>>`).
  LSR,

  /// `0x2:` Arithmetic shift-right (`>>>`).
  ASR,

  /// `0x3`: Rotate right.
  ROR,

  /// Special cased; Rotate right with extend.
  RRX,
}
