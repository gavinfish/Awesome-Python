from Instruction import Instruction


class AllocateInstruction(Instruction):
    # example: %1 = alloca i32, align 4

    target = ""
    type = ""
    align_width = 0

    def __init__(self, values):
        self.target = values[0]
        self.type = values[3]
        self.align_width = values[-1]

    def __str__(self):
        return "AllocatInstruction " + self.target + " with type " + self.type
