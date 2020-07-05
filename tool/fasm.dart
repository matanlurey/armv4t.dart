import 'dart:io';

import 'package:path/path.dart' as path;

/// Uses the bundled FASMARM compile (third_party/fasmarm) to build outputs.
void main() {
  var didError = false;
  _build.forEach((source, output) {
    stdout.writeln('$_tool: $source -> $output');
    final result = Process.runSync(_tool, [
      source,
      output,
    ]);
    if (result.stdout != null) {
      stdout.writeln(result.stdout);
    }
    if (result.stderr != null) {
      stderr.writeln(result.stderr);
      didError = true;
    }
  });
  if (didError) {
    exitCode = 1;
  }
}

final _fasmarm = path.join('third_party', 'fasmarm');

final _tool = (() {
  if (Platform.isWindows) {
    return path.join(_fasmarm, 'FASMARM.exe');
  } else if (Platform.isLinux) {
    return path.join(_fasmarm, 'fasmarm');
  } else {
    throw UnsupportedError(Platform.operatingSystem);
  }
})();

final _build = {
  // test/decoder/arm/fasmarm/arithmetic.asm
  path.join(
    'test',
    'decoder',
    'arm',
    'fasmarm',
    'arithmetic.asm',
  ): path.join(
    'test',
    'decoder',
    'arm',
    'fasmarm',
    'arithmetic.bin',
  ),

  // test/decoder/arm/fasmarm/logical.asm
  path.join(
    'test',
    'decoder',
    'arm',
    'fasmarm',
    'logical.asm',
  ): path.join(
    'test',
    'decoder',
    'arm',
    'fasmarm',
    'logical.bin',
  ),

  // test/decoder/asm/fasmarm/memory.asm
  path.join(
    'test',
    'decoder',
    'arm',
    'fasmarm',
    'memory.asm',
  ): path.join(
    'test',
    'decoder',
    'arm',
    'fasmarm',
    'memory.bin',
  ),

  // test/decoder/asm/fasmarm/multiply.asm
  path.join(
    'test',
    'decoder',
    'arm',
    'fasmarm',
    'multiply.asm',
  ): path.join(
    'test',
    'decoder',
    'arm',
    'fasmarm',
    'multiply.bin',
  ),

  // test/decoder/asm/fasmarm/others.asm
  path.join(
    'test',
    'decoder',
    'arm',
    'fasmarm',
    'others.asm',
  ): path.join(
    'test',
    'decoder',
    'arm',
    'fasmarm',
    'others.bin',
  ),
};
