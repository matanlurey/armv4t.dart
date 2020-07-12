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

## Libraries

### `armv4t.dart`

Emulator and related components necessary to load and execute ARMv4T programs.

### `decode.dart`

Contains classes and data structures for decoding (and in some cases, encoding)
`Uint32`-encoded binary instructions into their resulting `ArmFormat` and
finally `ArmInstruction` data classes. If you intend to write your own
interpreter, debugger, or (re-)compiler, you may need to import this library.

## Resources

A few different resources and documents used to develop this package.

### Getting Started with ARM and Assembly

If you've (a) never written en emulator before or (b) want a tutorial on ARM
assembly (or both), these are for you.

- [ARM Assembly Basics](https://azeria-labs.com/writing-arm-assembly-part-1/):
  A tutorial and walkthrough explaining the basics of ARM assembly, written from
  the perspective of learning to write ARM shellcode for security purposes. A
  great "getting started" guide if you have never been exposed to writing
  assembly or want a quick refresher.

- [ARM THUMB Programmers Guide](doc/arm-thumb-programmers-model.pdf): A slide
  deck quickly explaining _Thumb_ ARM assembly. Very digestable when compared
  to the more exhaustive resources available explaining the specifications of
  ARM and Thumb.

### Advanced and/or Emulator Specific

These resources were necessary when writing this package.

- [ARM CPU Overview by GBATek](https://problemkaputt.de/gbatek.htm#armcpuoverview):
  A reference guide extracted from the `No$GBA` emulator, which is sometimes
  considered the most complete (and completely documetned and debuggable) GBA
  and NDS emulator. Contains a very digestable (if somewhat brief) overview of
  the ARM7/TDMI processor, ARM CPU, and instruction sets.

- [ARM Developer Suite Assembler Guide](doc/arm-assembler-guide.pdf): An
  official (And older) guide to learning and writing ARM and Thumb Assembly
  Language by ARM Limited. Most of the other references listed here very quickly
  explain syntax and formats, where this assembler guide goes much more into
  detail - I found it absolutely necessary when writing this package.

- [ARM7/TDMI Datasheet](doc/arm7tdmi-data-sheet.pdf): Official ARM reference for
  the processor we are emulating, the `ARM7/TDMI` (which _implements_ the
  `ARMv4T` instruction set, if you were wondering/confused). One of the more
  detailed resources (along with the assembler guide).

- [ARM7/TDMI Instruction Timings](doc/arm7tdmi-timings.pdf): A quick reference
  (<2 pages) of the instruction timings for the `ARM7/TDMI`.

### Other Emulators

Some other emulators that were referenced when writing this one. It's really
tricky to find emulators of sufficient quality in terms of development - e.g.
useful doc comments, tests, and documentation in general (hence one of the
reasons I wrote this package), but it's also nice to have at least _some_
code references when writing an emulator.

- [`arm-js` (JavaScript)](https://github.com/ozaki-r/arm-js)
- [`armulator` (C++)](https://github.com/nfsu/armulator)
- [`armv4t_emu` (Rust)](https://github.com/daniel5151/armv4t_emu)
- [`uARM` (C++)](https://github.com/mellotanica/uARM)
