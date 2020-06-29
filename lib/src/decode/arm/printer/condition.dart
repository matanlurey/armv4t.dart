part of '../printer.dart';

/// Converts a [Condition] instance into its assembly-based [String] equivalent.
class ArmConditionPrinter implements ArmConditionVisitor<String, void> {
  const ArmConditionPrinter();

  @override
  String visitEQ([void _]) => 'EQ';

  @override
  String visitNE([void _]) => 'NE';

  @override
  String visitCS$HS([void _]) => 'CS';

  @override
  String visitCC$LO([void _]) => 'CC';

  @override
  String visitMI([void _]) => 'MI';

  @override
  String visitPL([void _]) => 'PL';

  @override
  String visitVS([void _]) => 'VS';

  @override
  String visitVC([void _]) => 'VC';

  @override
  String visitHI([void _]) => 'HI';

  @override
  String visitLS([void _]) => 'LS';

  @override
  String visitGE([void _]) => 'GE';

  @override
  String visitLT([void _]) => 'LT';

  @override
  String visitGT([void _]) => 'GT';

  @override
  String visitLE([void _]) => 'LE';

  @override
  String visitAL([void _]) => '';

  @override
  String visitNV([void _]) => 'NV';
}
