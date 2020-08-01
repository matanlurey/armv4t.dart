import 'dart:typed_data';

import 'package:armv4t/src/emulator/processor.dart';
import 'package:binary/binary.dart';
import 'package:test/test.dart';

void main() {
  group('Arm7Processor', () {
    Uint32List registers;

    setUp(() => registers = Arm7Processor.defaultRegisterSet());

    test('copyRegisters', () {
      expect(registers, Arm7Processor(registers: registers).copyRegisters());
    });

    group('alias registers', () {
      Arm7Processor cpu;

      setUp(() {
        cpu = Arm7Processor(registers: registers);
      });

      test('SP', () {
        expect(cpu.stackPointer, Uint32.zero);

        cpu.stackPointer = Uint32(8);
        expect(cpu.stackPointer, Uint32(8));
        expect(registers[13], 8);
      });
      test('LR', () {
        expect(cpu.linkRegister, Uint32.zero);

        cpu.linkRegister = Uint32(8);
        expect(cpu.linkRegister, Uint32(8));
        expect(registers[14], 8);
      });
      test('PC', () {
        expect(cpu.programCounter, Uint32.zero);

        cpu.programCounter = Uint32(8);
        expect(cpu.programCounter, Uint32(8));
        expect(registers[15], 8);
      });
    });

    // - `00 -> 15`: General registers.
    // - `16`:       `CPSR`.
    group('should use default registers', () {
      Arm7Processor cpu;

      setUp(() {
        registers.setRange(0, 16, List.generate(16, (index) => index));
        cpu = Arm7Processor(registers: registers);
      });

      for (var i = 0; i < 16; i++) {
        test('r$i', () {
          expect(cpu[i].value, i);
          cpu[i] = Uint32(32);
          expect(cpu[i].value, 32);
        });
      }

      test('CPSR', () {
        expect(cpu.cpsr.mode, ArmOperatingMode.usr);
      });
    });

    group('should use banked registers', () {
      Arm7Processor cpu;

      void setUpRegisters(int start, int end, ArmOperatingMode mode) {
        setUp(() {
          registers.setRange(
            start,
            end + 1,
            List.generate(end - start + 1, (i) => i),
          );
          cpu = Arm7Processor(registers: registers);
          cpu.unsafeSetCpsr(cpu.cpsr.update(mode: mode));
        });
      }

      void assertUntouched(int end) {
        for (var i = 0; i < end; i++) {
          test('[untouched] r$i', () {
            expect(cpu[i].value, 0);
          });
        }
      }

      void assertSwapped(int start, int end) {
        for (var i = start; i <= end; i++) {
          test('[swapped] r$i', () {
            expect(cpu[i].value, i - start);
          });
        }
      }

      // - `17 -> 23`: Banked regsiters (`FIQ`).
      // - `24`:       `SPSR_FIQ`.
      group('fiq', () {
        setUpRegisters(17, 23, ArmOperatingMode.fiq);
        assertUntouched(8);
        assertSwapped(8, 14);
      });

      // - `25 -> 26`: Banked registers (`SVC`).
      // - `27`:       `SPSR_SVC`.
      group('svc', () {
        setUpRegisters(25, 26, ArmOperatingMode.svc);
        assertUntouched(13);
        assertSwapped(13, 14);
      });

      // - `28 -> 29`: Banked registers (`ABT`).
      // - `30`:       `SPSR_ABT`
      group('abt', () {
        setUpRegisters(28, 29, ArmOperatingMode.abt);
        assertUntouched(13);
        assertSwapped(13, 14);
      });

      // - `31 -> 32`: Banked registers (`IRQ`).
      // - `33`:       `SPSR_IRQ`.
      group('irq', () {
        setUpRegisters(31, 32, ArmOperatingMode.irq);
        assertUntouched(13);
        assertSwapped(13, 14);
      });

      // - `34 -> 35`: Banked registers (`UND`).
      // - `36`:       `SPSR_UND`.
      group('und', () {
        setUpRegisters(34, 35, ArmOperatingMode.und);
        assertUntouched(13);
        assertSwapped(13, 14);
      });
    });
  });

  group('StatusRegister', () {
    const _N = 31;
    const _Z = 30;
    const _C = 29;
    const _V = 28;
    const _I = 7;
    const _F = 6;
    const _T = 5;
    const _M4 = 4;
    const _M0 = 0;

    StatusRegister psr;

    setUp(() => psr = StatusRegister());

    test('isSigned', () {
      expect(psr.isSigned, isFalse);
      expect(psr.toBits().isSet(_N), isFalse);

      psr = psr.update(isSigned: true);
      expect(psr.isSigned, isTrue);
      expect(psr.toBits().isSet(_N), isTrue);

      psr = psr.update(isSigned: false);
      expect(psr.isSigned, isFalse);
      expect(psr.toBits().isSet(_N), isFalse);
    });

    test('isZero', () {
      expect(psr.isZero, isFalse);
      expect(psr.toBits().isSet(_Z), isFalse);

      psr = psr.update(isZero: true);
      expect(psr.isZero, isTrue);
      expect(psr.toBits().isSet(_Z), isTrue);

      psr = psr.update(isZero: false);
      expect(psr.isZero, isFalse);
      expect(psr.toBits().isSet(_Z), isFalse);
    });

    test('isCarry', () {
      expect(psr.isCarry, isFalse);
      expect(psr.toBits().isSet(_C), isFalse);

      psr = psr.update(isCarry: true);
      expect(psr.isCarry, isTrue);
      expect(psr.toBits().isSet(_C), isTrue);

      psr = psr.update(isCarry: false);
      expect(psr.isCarry, isFalse);
      expect(psr.toBits().isSet(_C), isFalse);
    });

    test('isOverflow', () {
      expect(psr.isOverflow, isFalse);
      expect(psr.toBits().isSet(_V), isFalse);

      psr = psr.update(isOverflow: true);
      expect(psr.isOverflow, isTrue);
      expect(psr.toBits().isSet(_V), isTrue);

      psr = psr.update(isOverflow: false);
      expect(psr.isOverflow, isFalse);
      expect(psr.toBits().isSet(_V), isFalse);
    });

    test('irqDisabled', () {
      expect(psr.irqDisabled, isFalse);
      expect(psr.toBits().isSet(_I), isFalse);

      psr = psr.update(irqDisabled: true);
      expect(psr.irqDisabled, isTrue);
      expect(psr.toBits().isSet(_I), isTrue);

      psr = psr.update(irqDisabled: false);
      expect(psr.irqDisabled, isFalse);
      expect(psr.toBits().isSet(_I), isFalse);
    });

    test('fiqDisabled', () {
      expect(psr.fiqDisabled, isFalse);
      expect(psr.toBits().isSet(_F), isFalse);

      psr = psr.update(fiqDisabled: true);
      expect(psr.fiqDisabled, isTrue);
      expect(psr.toBits().isSet(_F), isTrue);

      psr = psr.update(fiqDisabled: false);
      expect(psr.fiqDisabled, isFalse);
      expect(psr.toBits().isSet(_F), isFalse);
    });

    test('thumbState', () {
      expect(psr.thumbState, isFalse);
      expect(psr.toBits().isSet(_T), isFalse);

      psr = psr.update(thumbState: true);
      expect(psr.thumbState, isTrue);
      expect(psr.toBits().isSet(_T), isTrue);

      psr = psr.update(thumbState: false);
      expect(psr.thumbState, isFalse);
      expect(psr.toBits().isSet(_T), isFalse);
    });

    group('mode', () {
      test('throws on invalid', () {
        final bits = psr.toBits().replaceBitRange(_M4, _M0, 0);
        expect(() => StatusRegister(bits), throwsArgumentError);
      });

      test('usr', () {
        expect(psr.mode, ArmOperatingMode.usr);
      });

      test('fiq', () {
        psr = psr.update(mode: ArmOperatingMode.fiq);
        expect(psr.mode, ArmOperatingMode.fiq);
        expect(
          psr.toBits().bitRange(_M4, _M0).value,
          ArmOperatingMode.fiq.value,
        );
      });

      test('irq', () {
        psr = psr.update(mode: ArmOperatingMode.irq);
        expect(psr.mode, ArmOperatingMode.irq);
        expect(
          psr.toBits().bitRange(_M4, _M0).value,
          ArmOperatingMode.irq.value,
        );
      });

      test('svc', () {
        psr = psr.update(mode: ArmOperatingMode.svc);
        expect(psr.mode, ArmOperatingMode.svc);
        expect(
          psr.toBits().bitRange(_M4, _M0).value,
          ArmOperatingMode.svc.value,
        );
      });

      test('abt', () {
        psr = psr.update(mode: ArmOperatingMode.abt);
        expect(psr.mode, ArmOperatingMode.abt);
        expect(
          psr.toBits().bitRange(_M4, _M0).value,
          ArmOperatingMode.abt.value,
        );
      });

      test('und', () {
        psr = psr.update(mode: ArmOperatingMode.und);
        expect(psr.mode, ArmOperatingMode.und);
        expect(
          psr.toBits().bitRange(_M4, _M0).value,
          ArmOperatingMode.und.value,
        );
      });

      test('sys', () {
        psr = psr.update(mode: ArmOperatingMode.sys);
        expect(psr.mode, ArmOperatingMode.sys);
        expect(
          psr.toBits().bitRange(_M4, _M0).value,
          ArmOperatingMode.sys.value,
        );
      });
    });

    test('== and hashCode', () {
      expect(psr, StatusRegister());
      expect(psr.hashCode, StatusRegister().hashCode);
    });
  });
}
