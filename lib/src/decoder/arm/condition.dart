import 'package:meta/meta.dart';

/// _ARM_ opcode suffixes that are used for conditionally executing code.
///
/// > NOTE: In _THUMB_ mode, `{cond}` can only be used for branch opcodes.
@immutable
@sealed
class Condition {
  /// Equal (zero, same, `Z=1`).
  static const eq = Condition._(0x0, 'eq');

  /// Not equal (non-zero, not same, `Z=0`).
  static const ne = Condition._(0x1, 'ne');

  /// Unsigned higher or same (carry set, `C=1`).
  static const cs = Condition._(0x2, 'cs');

  /// Unsigned lower (carry cleared, `C=0`).
  static const cc = Condition._(0x3, 'cc');

  /// Signed negative (minus, `N=1`).
  static const mi = Condition._(0x4, 'mi');

  /// Signed positive or zero (plus, `N=0`).
  static const pl = Condition._(0x5, 'pl');

  /// Signed overflow (v set, `V=1`).
  static const vs = Condition._(0x6, 'vs');

  /// Signed no overflow (v cleared, `V=0`).
  static const vc = Condition._(0x7, 'vc');

  /// Unsigned higher (`C=1 and Z=0`).
  static const hi = Condition._(0x8, 'hi');

  /// Unsigned lower same (`C=0 or Z=1`).
  static const ls = Condition._(0x9, 'ls');

  /// Signed greater or equal (`N=V`).
  static const ge = Condition._(0xa, 'ge');

  /// Signed less than (`N<>V`).
  static const lt = Condition._(0xb, 'lt');

  /// Signed greater than (`Z=0 and N=V`).
  static const gt = Condition._(0xc, 'gt');

  /// Signed less or equal (`Z=1 or N<>V`).
  static const le = Condition._(0xd, 'le');

  /// Always (this suffix can be omitted).
  static const al = Condition._(0xe, 'al');

  /// Never.
  static const nv = Condition._(0xf, 'nv');

  /// 4-bit opcode for a given condition field.
  final int value;

  /// Human-readable mnuemonic.
  final String mnuemonic;

  /// Returns the condition with a matching [value] compared to [bits].
  factory Condition.parse(int bits) {
    final result = const [
      eq,
      ne,
      cs,
      cc,
      mi,
      pl,
      vs,
      vc,
      hi,
      ls,
      ge,
      lt,
      gt,
      le,
      al,
      nv,
    ][bits];
    assert(result.value == bits);
    return result;
  }

  const Condition._(this.value, this.mnuemonic);

  @override
  String toString() => 'Condition { 0x${value.toRadixString(16)}: $mnuemonic}}';
}
