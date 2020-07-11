import 'dart:typed_data';

import 'package:armv4t/src/common/assert.dart';
import 'package:binary/binary.dart';
import 'package:meta/meta.dart';

/// Represents an operating mode of the ARM processor.
@immutable
@sealed
class ArmOperatingMode {
  static const usr = ArmOperatingMode._(0x10, 'usr');
  static const fiq = ArmOperatingMode._(0x11, 'fiq');
  static const irq = ArmOperatingMode._(0x12, 'irq');
  static const svc = ArmOperatingMode._(0x13, 'svc');
  static const abt = ArmOperatingMode._(0x17, 'abt');
  static const und = ArmOperatingMode._(0x1b, 'und');
  static const sys = ArmOperatingMode._(0x1f, 'sys');

  /// 4-bit value that represents this mode.
  final int value;

  /// Name of the operating mode.
  final String name;

  const ArmOperatingMode._(this.value, this.name);

  @override
  String toString() {
    if (assertionsEnabled) {
      return 'ArmOperatingMode { 0x${value.toRadixString(16)}: $name }';
    } else {
      return super.toString();
    }
  }
}

/// An emulated ARMv7 CPU.
@sealed
abstract class Arm7Processor {
  /// Creates a new [Arm7Processor], which uses the `ARMv4T` instruction set.
  ///
  /// May optionally provide an initial set of [registers], but these are
  /// expected to contain valid elements and undefined behavior may occur if
  /// they were not originally created by a compatible instance of this class.
  factory Arm7Processor({Uint32List registers}) = _Arm7Processor;

  /// Current program status register.
  StatusRegister get psr;

  /// Reads the current value stored in the register [index].
  ///
  /// Throws [RangeError] if [index] is not within the interval `0->15`.
  Uint32 operator [](int index);

  /// Writes [value] into the register [index].
  ///
  /// Throws [RangeError] if [index] is not within the interval `0->15`.
  void operator []=(int index, Uint32 value);

  /// Returns a copy of the current state of the registers.
  Uint32List copyRegisters();
}

class _Arm7Processor implements Arm7Processor {
  /// Number of registers that are available normally.
  ///
  /// This includes ro->r14, as well as r15 (the program counter).
  static const _userRegisters = 16;

  static const _fiqRegsiters = 7;
  static const _svcRegisters = 2;
  static const _abtRegisters = 2;
  static const _irqRegisters = 2;
  static const _undRegistesr = 2;

  /// Table describing additional registers available per [ArmOperatingMode].
  static const _bankedRegisters = 0 +
      /**/
      _fiqRegsiters +
      _svcRegisters +
      _abtRegisters +
      _irqRegisters +
      _undRegistesr;

  /// Number of status registers.
  ///
  /// This includes the CPSR ([ArmOperatingMode.usr] and [ArmOperatingMode.sys])
  /// as well the various SPSRs for the remaining operating modes, which are
  /// banked for usage only in that operating mode.
  static const _statusRegisters = 6;

  /// Number of 32-bit registers needed to represent the physical registers.
  static const _physicalRegisters = 0 +
      /**/
      _userRegisters +
      _bankedRegisters +
      _statusRegisters;

  /// A combination of both current, banked, and status registers.
  ///
  /// - `00 -> 15`: General registers.
  /// - `16`:       `CPSR`.
  /// - `17 -> 23`: Banked regsiters (`FIQ`).
  /// - `24`:       `SPSR_FIQ`.
  /// - `25 -> 26`: Banked registers (`SVC`).
  /// - `27`:       `SPSR_SVC`.
  /// - `28 -> 29`: Banked registers (`ABT`).
  /// - `30`:       `SPSR_ABT`
  /// - `31 -> 32`: Banked registers (`IRQ`).
  /// - `33`:       `SPSR_IRQ`.
  /// - `34 -> 35`: Banked registers (`UND`).
  /// - `36`:       `SPSR_UND`.
  final Uint32List _registers;

  factory _Arm7Processor({Uint32List registers}) {
    if (registers == null) {
      registers = Uint32List(_physicalRegisters);
    } else if (registers.length != _physicalRegisters) {
      throw ArgumentError.value(
        registers,
        'registers',
        'Requires exact length of $_physicalRegisters, got ${registers.length}',
      );
    }
    return _Arm7Processor._(registers);
  }

  const _Arm7Processor._(this._registers);

  ArmOperatingMode get _mode => ArmOperatingMode.usr;

  static const _statusRegistersUsr = 16;
  static const _bankedRegistersFiq = 17;
  static const _statusRegsitersFiq = 24;
  static const _bankedRegistersSvc = 25;
  static const _statusRegistersSvc = 27;
  static const _bankedRegistersAbt = 28;
  static const _statusRegistersAbt = 30;
  static const _bankedRegistersIrq = 31;
  static const _statusRegistersIrq = 33;
  static const _bankedRegistersUnd = 34;
  static const _statusRegistersUnd = 36;

  int _swapBankedRegister(int index) {
    if (index < 8 || index == 15) {
      return index;
    } else {
      final mode = _mode;
      if (mode == ArmOperatingMode.usr || mode == ArmOperatingMode.sys) {
        return index;
      } else {
        final offset = index - 8;
        switch (mode) {
          case ArmOperatingMode.fiq:
            return _bankedRegistersFiq + offset;
          case ArmOperatingMode.svc:
            return _bankedRegistersSvc + offset;
          case ArmOperatingMode.abt:
            return _bankedRegistersAbt + offset;
          case ArmOperatingMode.irq:
            return _bankedRegistersIrq + offset;
          case ArmOperatingMode.und:
            return _bankedRegistersUnd + offset;
          default:
            throw StateError('Unexpected: $mode');
        }
      }
    }
  }

  @override
  StatusRegister get psr => StatusRegister(Uint32(_statusRegister));

  int get _statusRegister {
    switch (_mode) {
      case ArmOperatingMode.usr:
      case ArmOperatingMode.sys:
        return _registers[_statusRegistersUsr];
      case ArmOperatingMode.fiq:
        return _registers[_statusRegsitersFiq];
      case ArmOperatingMode.svc:
        return _registers[_statusRegistersSvc];
      case ArmOperatingMode.abt:
        return _registers[_statusRegistersAbt];
      case ArmOperatingMode.irq:
        return _registers[_statusRegistersIrq];
      case ArmOperatingMode.und:
        return _registers[_statusRegistersUnd];
      default:
        throw StateError('Unexpected: $_mode');
    }
  }

  @override
  Uint32 operator [](int index) {
    RangeError.checkValueInInterval(index, 0, _userRegisters);
    return _registers.getBoxed(_swapBankedRegister(index));
  }

  @override
  void operator []=(int index, Uint32 value) {
    RangeError.checkValueInInterval(index, 0, _userRegisters);
    _registers[_swapBankedRegister(index)] = value.value;
  }

  @override
  Uint32List copyRegisters() => Uint32List.fromList(_registers);
}

class StatusRegister {
  const factory StatusRegister(Uint32 value) = _StatusRegister;
}

class _StatusRegister implements StatusRegister {
  final Uint32 _value;

  const _StatusRegister(this._value);
}
