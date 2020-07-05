/// Handles the decoding (and some cases, encoding) of CPU instructions.
///
/// Clients that are writing their own debug tools, compilers, inspectors, or
/// extensions will need to import this library. Clients that are only
/// interested in the emulator components should use `armv4t.dart` instead.
library armvt.decode;

export 'src/common/binary.dart' show Uint2, Uint12, Uint24, Int24;
export 'src/common/union.dart' show Or2, Or3;
export 'src/decoder/arm/condition.dart' show Condition;
export 'src/decoder/arm/format.dart'
    show
        ArmFormat,
        ArmFormatDecoder,
        ArmFormatEncoder,
        ArmFormatVisitor,
        BlockDataTransferArmFormat,
        BranchArmFormat,
        BranchAndExchangeArmFormat,
        DataProcessingOrPsrTransferArmFormat,
        HalfwordDataTransferArmFormat,
        MultiplyArmFormat,
        MultiplyLongArmFormat,
        SingleDataSwapArmFormat,
        SingleDataTransferArmFormat,
        SoftwareInterruptArmFormat;
