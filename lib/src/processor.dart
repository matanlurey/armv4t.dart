import 'dart:typed_data';

import 'package:armv4t/src/common/assert.dart';
import 'package:armv4t/src/common/binary.dart';
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

  /// 5-bit value that represents this mode.
  final int value;

  /// Name of the operating mode.
  final String name;

  factory ArmOperatingMode.from(int bits) {
    Uint5.checkRange(bits);
    if (bits == usr.value) return usr;
    if (bits == fiq.value) return fiq;
    if (bits == irq.value) return irq;
    if (bits == svc.value) return svc;
    if (bits == abt.value) return abt;
    if (bits == und.value) return und;
    if (bits == sys.value) return sys;
    throw ArgumentError('Unknown value: $bits');
  }

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
  static const _SP = 13;
  static const _LR = 14;
  static const _PC = 15;

  /// Returns a default (valid) register set for a reset processor state.
  @visibleForTesting
  static Uint32List defaultRegisterSet() {
    return _Arm7Processor._defaultRegisterSet();
  }

  /// Creates a new [Arm7Processor], which uses the `ARMv4T` instruction set.
  ///
  /// May optionally provide an initial set of [registers], but these are
  /// expected to contain valid elements and undefined behavior may occur if
  /// they were not originally created by a compatible instance of this class.
  factory Arm7Processor({Uint32List registers}) = _Arm7Processor;

  @protected
  const Arm7Processor._();

  /// Current program status register.
  StatusRegister get cpsr;
  set cpsr(StatusRegister psr);

  /// Saved program status register.
  StatusRegister get spsr;
  set spsr(StatusRegister psr);

  /// `r13`: The _Stack Pointer_ (`SP`) during [StatusRegister.thumbState].
  ///
  /// While in _ARM_ state the usr may decide to use `r13` and/or other
  /// register(s) as stack pointer(s), or as a general purpose regsiter. There's
  /// a separate `r13` register for _each_ [ArmOperatingMode], and (when used as
  /// a stack pointer) each exception handler may (really, _must_) use its own
  /// stack.
  @nonVirtual
  Uint32 get stackPointer => this[_SP];
  set stackPointer(Uint32 value) => this[_SP] = value;

  /// `r14`: The _Link Register_ (`LR`).
  ///
  /// When calling to a sub-routine by a Branch with Link (`LR`) instruction,
  /// then the return address (i.e. the old value of [programCounter]) is saved
  /// in this register.
  ///
  /// Storing the return address in [linkRegister] is faster than pushing it
  /// into memory, however, as there's only one `LR` for each [ArmOperatingMode]
  /// the user must manually push its content before entering nested routines.
  ///
  /// Same happens when an exception is called; [programCounter] is saved in the
  /// [linkRegister] of the new [ArmOperatingMode].
  ///
  /// > NOTE: In _ARM_ mode, `r14` _may_ be used as a general purpose register
  /// > provided that the above usage as a link register isn't required.
  @nonVirtual
  Uint32 get linkRegister => this[_LR];
  set linkRegister(Uint32 value) => this[_LR] = value;

  /// `r15`: **Always** used as the _Program Counter_ (`PC`).
  ///
  /// TODO(https://github.com/matanlurey/armv4t.dart/issues/41): Pipe-lining?
  @nonVirtual
  Uint32 get programCounter => this[_PC];
  set programCounter(Uint32 value) => this[_PC] = value;

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

class _Arm7Processor extends Arm7Processor {
  static Uint32List _defaultRegisterSet() => Uint32List(_physicalRegisters)
    ..[_statusRegistersUsr] =
        StatusRegister._defaultForMode(ArmOperatingMode.usr).toBits().value
    ..[_statusRegsitersFiq] =
        StatusRegister._defaultForMode(ArmOperatingMode.fiq).toBits().value
    ..[_statusRegistersSvc] =
        StatusRegister._defaultForMode(ArmOperatingMode.svc).toBits().value
    ..[_statusRegistersAbt] =
        StatusRegister._defaultForMode(ArmOperatingMode.abt).toBits().value
    ..[_statusRegistersIrq] =
        StatusRegister._defaultForMode(ArmOperatingMode.irq).toBits().value
    ..[_statusRegistersUnd] =
        StatusRegister._defaultForMode(ArmOperatingMode.und).toBits().value;

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
      // Create a new empty register set.
      registers = _defaultRegisterSet();
    } else if (registers.length != _physicalRegisters) {
      throw ArgumentError.value(
        registers,
        'registers',
        'Requires exact length of $_physicalRegisters, got ${registers.length}',
      );
    }
    return _Arm7Processor._(registers);
  }

  const _Arm7Processor._(this._registers) : super._();

  ArmOperatingMode get _mode => cpsr.mode;

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
        if (mode == ArmOperatingMode.fiq) {
          final offset = index - 8;
          return _bankedRegistersFiq + offset;
        } else {
          if (index < 13) {
            return index;
          } else {
            final offset = index - 13;
            switch (mode) {
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
    }
  }

  @override
  StatusRegister get cpsr {
    return StatusRegister(Uint32(_registers[_statusRegistersUsr]));
  }

  @override
  set cpsr(StatusRegister psr) {
    _registers[_statusRegistersUsr] = psr.toBits().value;
  }

  @override
  StatusRegister get spsr {
    return StatusRegister(Uint32(_registers[_savedStatusRegister]));
  }

  @override
  set spsr(StatusRegister psr) {
    _registers[_savedStatusRegister] = psr.toBits().value;
  }

  int get _savedStatusRegister {
    switch (_mode) {
      case ArmOperatingMode.usr:
      case ArmOperatingMode.sys:
        throw StateError('Cannot access SPSR in USR/SYS');
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

/// Represents an immutable program status register (`PSR`).
@immutable
@sealed
abstract class StatusRegister {
  factory StatusRegister([Uint32 value]) {
    if (value == null) {
      return StatusRegister._defaultForMode(ArmOperatingMode.usr);
    } else {
      final register = _StatusRegister(value);
      // Assert that the mode can be loaded (e.g. is a valid/known range).
      register.mode;
      return register;
    }
  }

  factory StatusRegister._defaultForMode(ArmOperatingMode mode) {
    return _StatusRegister(Uint32.zero.replaceBitRange(4, 0, mode.value));
  }

  /// Returns a new [StatusRegister] with any non-null fields updated.
  StatusRegister update({
    bool isSigned,
    bool isZero,
    bool isCarry,
    bool isOverflow,
    bool irqDisabled,
    bool fiqDisabled,
    bool thumbState,
    ArmOperatingMode mode,
  });

  /// Whether bit `31` (`N`) set, signifying "signed", otherwise not signed.
  bool get isSigned;

  /// Whether bit `30` (`Z`) set, signifying "zero", othwerwise not zero.
  bool get isZero;

  /// Whether bit `29` (`C`) set, signifying "carry", otherwise no carry.
  bool get isCarry;

  /// Whether bit `28` (`V`) set, signifying "overflow", otherwise no overflow.
  bool get isOverflow;

  /// Whether bit `7` (`I`) set, signifying that `IRQ` is disabled.
  bool get irqDisabled;

  /// Whether bit `6` (`F`) set, signifying that `FIQ` is disabled.
  bool get fiqDisabled;

  /// Whether bit `5` (`T`) set, signifying that `THUMB` mode is enabled.
  bool get thumbState;

  /// Current operating mode (bits 4-0).
  ArmOperatingMode get mode;

  /// Returns the bit representation of this register.
  Uint32 toBits();
}

class _StatusRegister implements StatusRegister {
  static const _N = 31;
  static const _Z = 30;
  static const _C = 29;
  static const _V = 28;
  static const _I = 7;
  static const _F = 6;
  static const _T = 5;
  static const _M4 = 4;
  static const _M0 = 0;

  final Uint32 _value;

  const _StatusRegister(this._value);

  @override
  bool operator ==(Object o) => o is _StatusRegister && _value == o._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  StatusRegister update({
    bool isSigned,
    bool isZero,
    bool isCarry,
    bool isOverflow,
    bool irqDisabled,
    bool fiqDisabled,
    bool thumbState,
    ArmOperatingMode mode,
  }) {
    var value = _value;
    if (isSigned != null) {
      value = value.toggleBit(_N, isSigned);
    }
    if (isZero != null) {
      value = value.toggleBit(_Z, isZero);
    }
    if (isCarry != null) {
      value = value.toggleBit(_C, isCarry);
    }
    if (isOverflow != null) {
      value = value.toggleBit(_V, isOverflow);
    }
    if (irqDisabled != null) {
      value = value.toggleBit(_I, irqDisabled);
    }
    if (fiqDisabled != null) {
      value = value.toggleBit(_F, fiqDisabled);
    }
    if (thumbState != null) {
      value = value.toggleBit(_T, thumbState);
    }
    if (mode != null) {
      value = value.replaceBitRange(_M4, _M0, mode.value);
    }
    return _StatusRegister(value);
  }

  @override
  bool get isSigned => _value.isSet(_N);

  @override
  bool get isZero => _value.isSet(_Z);

  @override
  bool get isCarry => _value.isSet(_C);

  @override
  bool get isOverflow => _value.isSet(_V);

  @override
  bool get irqDisabled => _value.isSet(_I);

  @override
  bool get fiqDisabled => _value.isSet(_F);

  @override
  bool get thumbState => _value.isSet(_T);

  @override
  ArmOperatingMode get mode {
    return ArmOperatingMode.from(_value.bitRange(_M4, _M0).value);
  }

  @override
  Uint32 toBits() => _value;
}
