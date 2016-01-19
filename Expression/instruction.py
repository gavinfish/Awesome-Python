from enum import Enum

ALL_INSTRUCT_TYPE = (
    "alloca", "store", "load", "ret", "add", "sub", "mul", "fmul", "sdiv", "ashr", "shl", "sext", "trunc", "sitofp",
    "fptosi", "preds", "br", "icmp", "call")


class InstructType(Enum):
    # Basic instruct
    ALLOCATE = ("alloca",)
    STORE = ("store",)
    LOAD = ("load",)
    RETURN = ("ret",)

    # Operator
    ADD = ("add",)
    SUB = ("sub",)
    MUL = ("mul", "fmul")
    DIV = ("sdiv",)
    ASHR = ("ashr",)
    SHL = ("shl",)

    # Support big number
    SEXT = ("sext",)
    TRUNC = ("trunc",)
    SITOFP = ("sitofp",)
    FPTOSI = ("fptosi",)

    # Piecewise
    LABEL = ("preds",)  # This is very dangerous since this key word may be used any where
    BR = ("br",)
    CMP = ("icmp",)

    # Math function
    CALL = ("call",)


class Instruction(object):
    def refresh_variable(self, variable_map):
        None


class InstructionFactory(object):
    @staticmethod
    def parse(instruct):
        # Purify the instruct line
        instruct = instruct.strip()
        # Remove debug info
        try:
            last_comma_index = instruct.rindex("!dbg")
            instruct = instruct[:last_comma_index]
        except ValueError:
            # Nope, it is ok to have no comma
            None
        # Remove excess commas
        instruct = instruct.replace(",", "")

        parts = instruct.strip().split()
        for i in ALL_INSTRUCT_TYPE:
            if i in parts:
                if i in InstructType.ALLOCATE.value:
                    return AllocateInstruction(parts)
                elif i in InstructType.LOAD.value:
                    return LoadInstruction(parts)
                elif i in InstructType.STORE.value:
                    return StoreInstruction(parts)
                elif i in InstructType.RETURN.value:
                    return ReturnInstruction(parts)
                elif i in InstructType.ADD.value:
                    return ADDInstruction(parts)
                elif i in InstructType.SUB.value:
                    return SUBInstruction(parts)
                elif i in InstructType.MUL.value:
                    return MULInstruction(parts)
                elif i in InstructType.DIV.value:
                    return DIVInstruction(parts)
                elif i in InstructType.LABEL.value:
                    return LABELInstruction(parts)
                elif i in InstructType.BR.value:
                    return BRInstruction(parts)
                elif i in InstructType.CMP.value:
                    return CMPInstruction(parts)
                elif i in InstructType.SHL.value:
                    return SHLInstruction(parts)
                elif i in InstructType.SEXT.value:
                    return SEXTInstruction(parts)
                elif i in InstructType.TRUNC.value:
                    return TRUNCInstruction(parts)
                elif i in InstructType.SITOFP.value:
                    return SITOFPInstruction(parts)
                elif i in InstructType.FPTOSI.value:
                    return FPTOSIInstruction(parts)
                elif i in InstructType.ASHR.value:
                    return ASHRInstruction(parts)
                # Ignore call method that doesn't effort variables
                elif i in InstructType.CALL.value and '=' in parts:
                    return CALLInstruction(parts)


class AllocateInstruction(Instruction):
    # Example: %1 = alloca i32 align 4

    def __init__(self, values):
        self.target = values[0]
        self.type = values[3]
        self.align_width = values[-1]

    def refresh_variable(self, variable_map):
        variable_map[self.target] = self.target

    def __str__(self):
        description = "allocate " + self.target
        return description


class StoreInstruction(Instruction):
    # Example: store i32 %x i32* %1 align 4

    def __init__(self, values):
        self.source = values[2]
        self.source_type = values[1]
        self.target = values[4]
        self.target_type = values[3]
        self.align_width = values[-1]

    def refresh_variable(self, variable_map):
        r = self.source if self.source not in variable_map else variable_map[self.source]
        # variable_map[self.target] = variable_map[self.target].replace(self.target, r)
        # TODO recheck if it is safe
        variable_map[self.target] = r

    def __str__(self):
        description = "store " + self.source + " to " + self.target
        return description


class LoadInstruction(Instruction):
    # Example: %2 = load i32* %1 align 4

    def __init__(self, values):
        self.target = values[0]
        self.source = values[4]
        self.source_type = values[3]
        self.aligh_width = values[-1]

    def refresh_variable(self, variable_map):
        variable_map[self.target] = variable_map[self.source]

    def __str__(self):
        description = "load " + self.target + " from " + self.source
        return description


class ReturnInstruction(Instruction):
    # Example: ret i32 %4

    def __init__(self, values):
        self.target = values[-1]
        self.type = values[1]
        self.result = ""

    def refresh_variable(self, variable_map):
        description = "return " + self.target
        expression = variable_map[self.target].replace("%", "")
        if expression[0] is "(" and expression[-1] is ")":
            expression = expression[1:-1]
        self.result = "y = " + expression

    def __str__(self):
        return self.result


class ADDInstruction(Instruction):
    #  Example: %3 = add nsw i32 %2 10

    def __init__(self, values):
        self.target = values[0]
        self.left = values[-2]
        self.right = values[-1]

    def refresh_variable(self, variable_map):
        l = self.left if self.left not in variable_map else variable_map[self.left]
        r = self.right if self.right not in variable_map else variable_map[self.right]
        if (str.isdecimal(l) and str.isdecimal(r)) and (
                    (str.isdecimal(self.left) and not str.isdecimal(self.right)) or (
                            not str.isdecimal(self.left) and str.isdecimal(self.right))):
            variable_map[self.target] = str(int(l) + int(r))
        else:
            variable_map[self.target] = "(" + l + "+" + r + ")"

    def __str__(self):
        description = "(" + self.left + "+" + self.right + ")"
        return description


class SUBInstruction(Instruction):
    # Example: %3 = sub nsw i32 %2 12

    def __init__(self, values):
        self.target = values[0]
        self.left = values[-2]
        self.right = values[-1]

    def refresh_variable(self, variable_map):
        l = self.left if self.left not in variable_map else variable_map[self.left]
        r = self.right if self.right not in variable_map else variable_map[self.right]
        if (str.isdecimal(l) and str.isdecimal(r)) and (
                    (str.isdecimal(self.left) and not str.isdecimal(self.right)) or (
                            not str.isdecimal(self.left) and str.isdecimal(self.right))):
            variable_map[self.target] = str(int(l) - int(r))
        else:
            variable_map[self.target] = "(" + l + "-" + r + ")"

    def __str__(self):
        description = "(" + self.left + "-" + self.right + ")"
        return description


class MULInstruction(Instruction):
    # Example:   %4 = mul nsw i64 %3 123333333333

    def __init__(self, values):
        self.target = values[0]
        self.left = values[-2]
        self.right = values[-1]

    def refresh_variable(self, variable_map):
        l = self.left if self.left not in variable_map else variable_map[self.left]
        r = self.right if self.right not in variable_map else variable_map[self.right]
        if (str.isdecimal(l) and str.isdecimal(r)) and (
                    (str.isdecimal(self.left) and not str.isdecimal(self.right)) or (
                            not str.isdecimal(self.left) and str.isdecimal(self.right))):
            variable_map[self.target] = str(int(l) * int(r))
        else:
            variable_map[self.target] = l + "*" + r

    def __str__(self):
        description = "(" + self.left + "*" + self.right + ")"
        return description


class DIVInstruction(Instruction):
    # Example: %3 = sdiv i32 %2 12

    def __init__(self, values):
        self.target = values[0]
        self.left = values[-2]
        self.right = values[-1]

    def refresh_variable(self, variable_map):
        l = self.left if self.left not in variable_map else variable_map[self.left]
        r = self.right if self.right not in variable_map else variable_map[self.right]
        if (str.isdecimal(l) and str.isdecimal(r)) and (
                    (str.isdecimal(self.left) and not str.isdecimal(self.right)) or (
                            not str.isdecimal(self.left) and str.isdecimal(self.right))):
            variable_map[self.target] = str(int(l) / int(r))
        else:
            variable_map[self.target] = l + "/" + r

    def __str__(self):
        description = "(" + self.left + "/" + self.right + ")"
        return description


class SEXTInstruction(Instruction):
    # Example: %3 = sext i32 %2 to i64

    def __init__(self, values):
        self.target = values[0]
        self.source = values[4]

    def refresh_variable(self, variable_map):
        variable_map[self.target] = variable_map[self.source]

    def __str__(self):
        description = "sext from " + self.source + " to " + self.target
        return description


class TRUNCInstruction(Instruction):
    # Example: %5 = trunc i64 %4 to i32

    def __init__(self, values):
        self.target = values[0]
        self.source = values[4]

    def refresh_variable(self, variable_map):
        variable_map[self.target] = variable_map[self.source]

    def __str__(self):
        description = "truncate from " + self.source + " to " + self.target
        return description


class SITOFPInstruction(Instruction):
    # Example: %5 = sitofp i32 %4 to double

    def __init__(self, values):
        self.target = values[0]
        self.source = values[4]

    def refresh_variable(self, variable_map):
        variable_map[self.target] = variable_map[self.source]

    def __str__(self):
        description = "sitofp from " + self.source + " to " + self.target
        return description


class FPTOSIInstruction(Instruction):
    # Example: %7 = fptosi double %6 to i32

    def __init__(self, values):
        self.target = values[0]
        self.source = values[4]

    def refresh_variable(self, variable_map):
        variable_map[self.target] = variable_map[self.source]

    def __str__(self):
        description = "fptosi from " + self.source + " to " + self.target
        return description


class LABELInstruction(Instruction):
    # Example: ; <label>:11                                      ; preds = %9, %7

    def __init__(self, values):
        self.num = 0
        self.preds = []

        self.num = values[1].split(":")[-1]
        for i in range(values.index("=") + 1, len(values)):
            self.preds.append(values[i][1:])

    def __str__(self):
        description = "label " + self.num + " with preds " + ",".join(self.preds)
        return description


class BRInstruction(Instruction):
    # Example1: br i1 %5 label %7 label %9
    # Example2: br label %11

    # The shortest br instruction is like "br label num"
    SHORT_LENGTH = 3

    # If the br instruction just for jumping to a label
    def isdirect(self):
        return self.is_direct

    def __init__(self, values):
        if len(values) == self.SHORT_LENGTH:
            self.is_direct = True
            self.target = values[-1][1:]
        else:
            self.is_direct = False
            self.cmp = values[2]
            self.first_label = values[4][1:]
            self.second_label = values[-1][1:]

    def refresh_variable(self, variable_map):
        if not self.isdirect():
            self.cmp = self.cmp if self.cmp not in variable_map else variable_map[self.cmp].replace("%", "")

    def __str__(self):
        if self.isdirect():
            description = "this is  a direct br instruction to label " + self.target
        else:
            description = "this is a br instruction to label " + self.first_label + " or label " + self.second_label + " based on " + self.cmp
        return description


CMP_translate_map = {"slt": "<", "sgt": ">", "sle": "<=", "sge": ">=", "eq": "==", "ne": "!="}


class CMPInstruction(Instruction):
    # Example: %5 = icmp slt i32 %4 %5

    def __init__(self, values):
        self.target = values[0]
        self.type = values[3]
        self.left = values[-2]
        self.right = values[-1]

    def refresh_variable(self, variable_map):
        self.left = self.left if self.left not in variable_map else variable_map[self.left]
        self.right = self.right if self.right not in variable_map else variable_map[self.right]

        variable_map[self.target] = self.left + CMP_translate_map[self.type] + self.right

    def __str__(self):
        description = " ".join(["check if", self.left, CMP_translate_map[self.type], self.right]).replace("%", "")
        return description


class ASHRInstruction(Instruction):
    # Example: %3 = ashr i32 %2 5

    def __init__(self, values):
        self.target = values[0]
        self.left = values[-2]
        self.right = values[-1]

    def refresh_variable(self, variable_map):
        self.left = self.left if self.left not in variable_map else variable_map[self.left]
        self.right = self.right if self.right not in variable_map else variable_map[self.right]

        variable_map[self.target] = "(" + self.left + ">>" + self.right + ")"

    def __str__(self):
        description = self.left + ">>" + self.right
        return description


class SHLInstruction(Instruction):
    # Example: %8 = shl i32 %7 3

    def __init__(self, values):
        self.target = values[0]
        self.left = values[-2]
        self.right = values[-1]

    def refresh_variable(self, variable_map):
        self.left = self.left if self.left not in variable_map else variable_map[self.left]
        self.right = self.right if self.right not in variable_map else variable_map[self.right]

        variable_map[self.target] = "(" + self.left + "<<" + self.right + ")"

    def __str__(self):
        description = self.left + "<<" + self.right
        return description


class CALLInstruction(Instruction):
    # Example: %6 = call double @sqrt(double %5) #7

    def __init__(self, values):
        self.target = values[0]
        func = values[4]
        self.name = func[1:func.index('(')]
        self.argvs = []
        length = len(values)
        for i in range(5, length - 2):
            self.argvs.append(values[i])
        self.argvs.append(values[(length - 2)][:-1])

    def refresh_variable(self, variable_map):
        for i, argv in enumerate(self.argvs):
            self.argvs[i] = argv if argv not in variable_map else variable_map[argv]

        variable_map[self.target] = self.name + "(" + ",".join(self.argvs) + ")"

    def __str__(self):
        description = self.name + "(" + ",".join(self.argvs) + ")"
        return description
