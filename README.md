# ARMv4T

[![ARMv4T on pub.dev][pub_img]][pub_url]
[![Code coverage][cov_img]][cov_url]
[![Github action status][gha_img]][gha_url]
[![Dartdocs][doc_img]][doc_url]
[![Style guide][sty_img]][sty_url]

[pub_url]: https://pub.dartlang.org/packages/armv4t
[pub_img]: https://img.shields.io/pub/v/armv4t.svg
[gha_url]: https://github.com/matanlurey/armv4t.dart/actions
[gha_img]: https://github.com/matanlurey/armv4t.dart/workflows/Dart/badge.svg
[cov_url]: https://codecov.io/gh/matanlurey/armv4t.dart
[cov_img]: https://codecov.io/gh/matanlurey/armv4t.dart/branch/master/graph/badge.svg
[doc_url]: https://www.dartdocs.org/documentation/armv4t/latest
[doc_img]: https://img.shields.io/badge/Documentation-armv4t-blue.svg
[sty_url]: https://pub.dev/packages/pedantic
[sty_img]: https://img.shields.io/badge/style-pedantic-40c4ff.svg

An emulator for the [ARMv4T instruction set][], written in Dart.

[armv4t instruction set]: https://developer.arm.com/docs/dvi0025/latest/arm922t-with-ahb-system-on-chip-platform-os-processor/the-armv4t-architecture/the-armv4t-instruction-sets

## Resources

A few different resources and documents used to develop this package.

### Documentation

- [ARM Assembler Guide](doc/arm-assembler-guide.pdf)
- [ARM CPU Overview](https://problemkaputt.de/gbatek.htm#armcpuoverview)
- [ARM THUMB Programmers Guide](doc/arm-thumb-programmers-model.pdf)
- [ARMv4T Instruction Set][]
- [ARM7/TDMI Datasheet](doc/arm7tdmi-data-sheet.pdf)
- [ARM7/TDMI Instruction Timings](doc/arm7tdmi-timings.pdf)
- [CowBitSpec: CPU](https://www.cs.rit.edu/~tjh8300/CowBite/CowBiteSpec.htm#CPU)
- [Designing Emulators for Complex Systems (Reddit)](https://www.reddit.com/r/EmuDev/comments/con6kg/when_designing_emulators_for_more_complex_systems/)
- [Emulating the GBA](https://web.archive.org/web/20150428041044/http://6bit.net/shonumi/2015/04/19/emulating-the-gba/)

### Other Emulators

- [`arm-js` (JavaScript)](https://github.com/ozaki-r/arm-js)
- [`armulator` (C++)](https://github.com/nfsu/armulator)
- [`armv4t_emu` (Rust)](https://github.com/daniel5151/armv4t_emu)
- [`uARM` (C++)](https://github.com/mellotanica/uARM)
