import 'dart:io';

import 'package:glob/glob.dart';
import 'package:path/path.dart' as path;

/// Uses the bundled FASMARM compile (third_party/fasmarm) to build outputs.
void main() {
  var didError = false;
  var didWrite = false;

  for (final glob in _build) {
    for (final source in glob.listSync().map((f) => f.path)) {
      if (source.endsWith('.golden.asm')) {
        continue;
      }
      final output = '${path.withoutExtension(source)}.bin';
      stdout.writeln('$_tool $source $output');
      final result = Process.runSync(_tool, [
        source,
        output,
      ]);
      if (result.stdout != null) {
        stdout.writeln(result.stdout);
        didWrite = true;
      }
      if (result.exitCode != 0) {
        stderr.writeln('${result.exitCode}: ${result.stderr}');
        didError = true;
      }
    }
  }

  if (didError) {
    stderr.writeln('One or more errors occurred.');
    exitCode = 1;
  } else if (!didWrite) {
    stderr.writeln('No output. Something is wrong: $_build');
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

final _build = [
  path.posix.join('test', 'decoder', 'arm', 'fasmarm', '*.asm'),
  path.posix.join('test', 'decoder', 'thumb', '*.asm'),
  path.posix.join('test', 'e2e', '*.asm'),
  path.posix.join('test', 'e2e', 'data', '*.asm'),
].map((p) => Glob(p)).toSet();
