import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// Provides shared utilities for pretty-printing instructions.
mixin InstructionPrintHelper {
  @protected
  String describeRegister(int register) {
    switch (register) {
      case 13:
        return 'sr';
      case 14:
        return 'lr';
      case 15:
        return 'pc';
      default:
        return 'r$register';
    }
  }

  @protected
  @visibleForTesting
  String describeRegisterList(
    int registerList, {
    String suffix,
    @required int length,
  }) {
    assert(length != null);
    if (registerList == 0) {
      return '';
    }
    final output = <String>[];
    int rangeStart;

    void write(int current) {
      if (current - 1 == rangeStart) {
        // Print the previous set bit.
        output.add(describeRegister(rangeStart));
      } else {
        // Print a range beteween the start and the current index.
        output.add(
          '${describeRegister(rangeStart)}-${describeRegister(current - 1)}',
        );
      }

      // Clear the range.
      rangeStart = null;
    }

    for (var i = 0; i < length; i++) {
      if (registerList.isSet(i)) {
        if (rangeStart == null) {
          // If we haven't started a range, start one.
          rangeStart = i;
        } else {
          // Otherwise it's fine - we are just waiting until we find a 0 bit.
        }
      } else {
        if (rangeStart != null) {
          // Write a range from the start register to the previous register.
          write(i);
        }
      }
    }

    if (rangeStart != null) {
      write(length);
    }

    if (suffix != null) {
      output.add(suffix);
    }

    return output.join(',');
  }
}

/// Given an N-bit list, where the k-th byte set represents the k-th register.
///
/// Any registers in a row are emitted using the format `Rn-Rm`; otherwise
/// they are emitted using `Rn`. Every register or register set is separated
/// by commas before emitting.
///
/// It is considered valid to have _no_ registers (e.g. just the PC/LR).
String describeRegisterList(
  int registerList, {
  String suffix,
  @required int length,
}) {
  assert(length != null);
  if (registerList == 0) {
    return '';
  }
  final output = <String>[];
  int rangeStart;

  void write(int current) {
    if (current - 1 == rangeStart) {
      // Print the previous set bit.
      output.add('R${rangeStart}');
    } else {
      // Print a range beteween the start and the current index.
      output.add('R${rangeStart}-R${current - 1}');
    }

    // Clear the range.
    rangeStart = null;
  }

  for (var i = 0; i < length; i++) {
    if (registerList.isSet(i)) {
      if (rangeStart == null) {
        // If we haven't started a range, start one.
        rangeStart = i;
      } else {
        // Otherwise it's fine - we are just waiting until we find a 0 bit.
      }
    } else {
      if (rangeStart != null) {
        // Write a range from the start register to the previous register.
        write(i);
      }
    }
  }

  if (rangeStart != null) {
    write(length);
  }

  if (suffix != null) {
    output.add(suffix);
  }

  return output.join(',');
}
