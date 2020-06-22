part of '../../instruction.dart';

/// Add.
///
/// Lo register operand | Hi register operand | Condition codes set
/// ------------------- | ------------------- | -------------------
/// ✔                   | ✔                   | ✔
///
/// `Rd := Rn + Op2`.
abstract class ADD extends ThumbInstruction {
  final int destinationRegister;
  final int sourceRegister;

  const ADD._({
    @required this.destinationRegister,
    @required this.sourceRegister,
  }) : super._();
}

class ADD$Register extends ADD {
  final int otherRegister;

  const ADD$Register({
    @required int destinationRegister,
    @required int sourceRegister,
    @required this.otherRegister,
  }) : super._(
          destinationRegister: destinationRegister,
          sourceRegister: sourceRegister,
        );
}

class ADD$Offset3 extends ADD {
  final int immediateValue;

  const ADD$Offset3({
    @required int destinationRegister,
    @required int sourceRegister,
    @required this.immediateValue,
  }) : super._(
          destinationRegister: destinationRegister,
          sourceRegister: sourceRegister,
        );
}
