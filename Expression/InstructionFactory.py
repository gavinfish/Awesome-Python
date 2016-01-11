from Instruction import *


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
