from enum import Enum


class InstructType(Enum):
    # Basic instruct
    ALLOCATE = "alloca"
    STORE = "store"
    LOAD = "load"
    RETURN = "ret"

    # Operator
    ADD = "add"
    SUB = "sub"
    MUL = "mul"
    DIV = "sdiv"

    # Support big number
    SEXT = "sext"
    TRUNC = "trunc"


variable_map = {}


class Instruction(object):
    None


class InstructionFactory(object):
    @staticmethod
    def parse(instruct):
        # Purify the instruct line
        instruct = instruct.strip()
        # Remove debug info
        try:
            last_comma_index = instruct.rindex(",")
            instruct = instruct[:last_comma_index]
        except ValueError:
            # Nope, it is ok to have no comma
            None
        # Remove excess commas
        instruct = instruct.replace(",", "")

        parts = instruct.strip().split(" ")
        for i in InstructType:
            if i.value in parts:
                if i is InstructType.ALLOCATE:
                    return AllocateInstruction(parts)
                elif i is InstructType.LOAD:
                    return LoadInstruction(parts)
                elif i is InstructType.STORE:
                    return StoreInstruction(parts)
                elif i is InstructType.RETURN:
                    return ReturnInstruction(parts)
                elif i is InstructType.ADD:
                    return ADDInstruction(parts)
                elif i is InstructType.SUB:
                    return SUBInstruction(parts)
                elif i is InstructType.MUL:
                    return MULInstruction(parts)
                elif i is InstructType.DIV:
                    return DIVInstruction(parts)
                elif i is InstructType.SEXT:
                    return SEXTInstruction(parts)
                elif i is InstructType.TRUNC:
                    return TRUNCInstruction(parts)


class AllocateInstruction(Instruction):
    # Example: %1 = alloca i32 align 4

    target = ""
    type = ""
    align_width = 0

    def __init__(self, values):
        self.target = values[0]
        self.type = values[3]
        self.align_width = values[-1]

        variable_map[self.target] = self.target

    def __str__(self):
        description = "allocate " + self.target
        return description


class StoreInstruction(Instruction):
    # Example: store i32 %x i32* %1 align 4
    source = ""
    source_type = ""
    target = ""
    target_type = ""
    align_width = 0

    def __init__(self, values):
        self.source = values[2]
        self.source_type = values[1]
        self.target = values[4]
        self.target_type = values[3]
        self.align_width = values[-1]

        r = self.source if self.source not in variable_map else variable_map[self.source]
        variable_map[self.target] = variable_map[self.target].replace(self.target, r)

    def __str__(self):
        description = "store " + self.source + " to " + self.target
        return description


class LoadInstruction(Instruction):
    # Example: %2 = load i32* %1 align 4

    target = ""
    source = ""
    source_type = ""
    aligh_width = 0

    def __init__(self, values):
        self.target = values[0]
        self.source = values[4]
        self.source_type = values[3]
        self.aligh_width = values[-1]

        variable_map[self.target] = variable_map[self.source]

    def __str__(self):
        description = "load " + self.target + " from " + self.source
        return description


class ReturnInstruction(Instruction):
    # Example: ret i32 %4

    target = ""
    type = ""

    def __init__(self, values):
        self.target = values[-1]
        self.type = values[1]

    def __str__(self):
        # description = "return " + self.target
        expression = variable_map[self.target].replace("%", "")
        if expression[0] is "(" and expression[-1] is ")":
            expression = expression[1:-1]
        description = "y = " + expression

        return description


class ADDInstruction(Instruction):
    #  Example: %3 = add nsw i32 %2 10
    left = ""
    right = ""
    type = ""
    target = ""

    def __init__(self, values):
        self.target = values[0]
        self.left = values[-2]
        self.right = values[-1]

        l = self.left if self.left not in variable_map else variable_map[self.left]
        r = self.right if self.right not in variable_map else variable_map[self.right]
        variable_map[self.target] = "(" + l + "+" + r + ")"

    def __str__(self):
        description = "(" + self.left + "+" + self.right + ")"
        return description


class SUBInstruction(Instruction):
    # Example: %3 = sub nsw i32 %2 12
    left = ""
    right = ""
    type = ""
    target = ""

    def __init__(self, values):
        self.target = values[0]
        self.left = values[-2]
        self.right = values[-1]

        l = self.left if self.left not in variable_map else variable_map[self.left]
        r = self.right if self.right not in variable_map else variable_map[self.right]
        variable_map[self.target] = "(" + l + "-" + r + ")"

    def __str__(self):
        description = "(" + self.left + "-" + self.right + ")"
        return description


class MULInstruction(Instruction):
    # Example:   %4 = mul nsw i64 %3 123333333333
    left = ""
    right = ""
    type = ""
    target = ""

    def __init__(self, values):
        self.target = values[0]
        self.left = values[-2]
        self.right = values[-1]

        l = self.left if self.left not in variable_map else variable_map[self.left]
        r = self.right if self.right not in variable_map else variable_map[self.right]
        variable_map[self.target] = l + "*" + r

    def __str__(self):
        description = "(" + self.left + "*" + self.right + ")"
        return description


class DIVInstruction(Instruction):
    # Example: %3 = sdiv i32 %2 12
    left = ""
    right = ""
    type = ""
    target = ""

    def __init__(self, values):
        self.target = values[0]
        self.left = values[-2]
        self.right = values[-1]

        l = self.left if self.left not in variable_map else variable_map[self.left]
        r = self.right if self.right not in variable_map else variable_map[self.right]
        variable_map[self.target] = "(" + l + "/" + r + ")"

    def __str__(self):
        description = "(" + self.left + "/" + self.right + ")"
        return description


class SEXTInstruction(Instruction):
    # Example: %3 = sext i32 %2 to i64
    target = ""
    target_type = ""
    source = ""
    source_type = ""

    def __init__(self, values):
        self.target = values[0]
        self.source = values[4]

        variable_map[self.target] = variable_map[self.source]

    def __str__(self):
        description = "sext from " + self.source + " to " + self.target
        return description


class TRUNCInstruction(Instruction):
    # Example: %5 = trunc i64 %4 to i32
    target = ""
    target_type = ""
    source = ""
    source_type = ""

    def __init__(self, values):
        self.target = values[0]
        self.source = values[4]

        variable_map[self.target] = variable_map[self.source]

    def __str__(self):
        description = "truncate from " + self.source + " to " + self.target
        return description
