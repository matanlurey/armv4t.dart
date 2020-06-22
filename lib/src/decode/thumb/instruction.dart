/// An **internal** representation of a decoded `THUMB` instruction.
abstract class ThumbInstruction {}

abstract class DataProcessingThumbInstruction extends ThumbInstruction {}

class Move extends DataProcessingThumbInstruction {}

class MoveNot extends DataProcessingThumbInstruction {}

class LoadWord extends DataProcessingThumbInstruction {}

class LoadByte extends DataProcessingThumbInstruction {}

class LoadHalfWord extends DataProcessingThumbInstruction {}

class LoadSignedBytes extends DataProcessingThumbInstruction {}

class LoadMultiple extends DataProcessingThumbInstruction {}

class StoreWord extends DataProcessingThumbInstruction {}

class StoreByte extends DataProcessingThumbInstruction {}

class StoreHalfWord extends DataProcessingThumbInstruction {}

class StoreMultiple extends DataProcessingThumbInstruction {}

abstract class ArithmeticThumbInstruction extends ThumbInstruction {}

class Add extends ArithmeticThumbInstruction {}

class AddWithCarry extends ArithmeticThumbInstruction {}
