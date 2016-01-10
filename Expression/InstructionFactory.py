from enum import Enum
from AllocateInstuction import AllocateInstruction


class InstructType(Enum):
    ALLOCATE = "alloca"
    STORE = "store"
    LOAD = "load"
    RETURN = "ret"


class InstructionFactory(object):
    @staticmethod
    def parse( instruct):
        parts = instruct.strip().split(" ")
        for i in InstructType:
            if i.value in parts:
                if i is InstructType.ALLOCATE:
                    return AllocateInstruction(parts)
