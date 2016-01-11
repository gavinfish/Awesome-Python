from InstructionFactory import InstructionFactory
from ExprInterpreter import ExprInterpreter
from Instruction import variable_map
from Instruction import ReturnInstruction
from Instruction import Instruction

if __name__ == "__main__":
    interpreter = ExprInterpreter()
    data = interpreter.load_data("example-list.ll")
    m = interpreter.get_methods(data)
    for target in m:
        commands = interpreter.get_commands(target)
        for command in commands:
            instruct = InstructionFactory.parse(command)
            if isinstance(instruct,ReturnInstruction):
                print(instruct)