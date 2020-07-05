/// Common data structure and utilities that are more broadly applicable.
///
/// Contains various custom [Integral] implementations, and a simple
/// no-dependency union-like type ([Or2] and [Or3]), and any other classes and
/// methods useful to those who are developing with this package.
library armv4t.common;

import 'package:binary/binary.dart';

import 'src/common/union.dart';

export 'src/common/binary.dart' show Uint2, Uint12, Uint24, Int24;
export 'src/common/union.dart' show Or2, Or3;
