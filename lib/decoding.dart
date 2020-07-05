/// Handles the decoding (and some cases, encoding) of CPU instructions.
///
/// Clients that are writing their own debug tools, compilers, inspectors, or
/// extensions will need to import this library. Clients that are only
/// interested in the emulator components should use `armv4t.dart` instead.
library armvt.decoding;

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
