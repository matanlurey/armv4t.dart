# Decoding ARM Instruction Tests

A subset of ARM instructions are tested in every file that don't necessarily
line up with a specific folder or format, mostly because it makes sense to test
similar instructions together regardless of the exact format.

- Data processing and PSR transfer: [`data_test.dart`][]
- Multiply: [`math_test.dart`][]
- Multiply long: [`math_test.dart`][]
- Single data swap: [`data_test.dart`][]
- Branch and exchange: [`branch_test.dart`][]
- Halfword data transfer, register offset: [`data_test.dart`][]
- Halfword data transfer, immediate offset: [`data_test.dart`][]
- Single data transfer: [`data_test.dart`][]
- Undefined: _Not tested here_.
- Block data transfer: [`data_test.dart`][]
- Branch: [`branch_test.dart`][]
- Coprocessor data transfer: [`coprocessor_test.dart`][]
- Coprocessor data operation: [`coprocessor_test.dart`][]
- Coprocessor register transfer: [`coprocessor_test.dart`][]
- Software interrupt: [`misc_test.dart`][]

[`coprocessor_test.dart`]: coprocessor_test.dart
[`branch_test.dart`]: branch_test.dart
[`data_test.dart`]: data_test.dart
[`math_test.dart`]: math_test.dart
[`misc_test.dart`]: misc_test.dart
