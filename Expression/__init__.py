from instruction import InstructionFactory
from exprInterpreter import ExprInterpreter
from instruction import ReturnInstruction
from instruction import Instruction
from log import gen_log
from piecewise import PiecewiseContext


def test_basic_expression():
    interpreter = ExprInterpreter()
    data = interpreter.load_data("example-list.ll")
    m = interpreter.get_methods(data)
    for target in m:
        commands = interpreter.get_commands(target)
        for command in commands:
            instruct = InstructionFactory.parse(command)
            if isinstance(instruct, ReturnInstruction):
                print(instruct)


if __name__ == "__main__":
    data = '''; Function Attrs: nounwind uwtable
define i32 @get_sign(i32 %x) #0 {
  %1 = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %x, i32* %1, align 4
  %2 = load i32* %1, align 4, !dbg !131
  %3 = mul nsw i32 %2, 2, !dbg !131
  store i32 %3, i32* %r, align 4, !dbg !131
  %4 = load i32* %r, align 4, !dbg !132
  %5 = icmp slt i32 %4, 0, !dbg !132
  %6 = load i32* %r, align 4, !dbg !134
  br i1 %5, label %7, label %9, !dbg !132

; <label>:7                                       ; preds = %0
  %8 = add nsw i32 %6, 3, !dbg !134
  store i32 %8, i32* %r, align 4, !dbg !134
  br label %11, !dbg !136

; <label>:9                                       ; preds = %0
  %10 = sub nsw i32 %6, 3, !dbg !137
  store i32 %10, i32* %r, align 4, !dbg !137
  br label %11

; <label>:11                                      ; preds = %9, %7
  %12 = load i32* %r, align 4, !dbg !139
  ret i32 %12, !dbg !139
}'''
    m = ExprInterpreter.get_methods(data)
    commands = ExprInterpreter.get_commands(m[0])
    context = PiecewiseContext()
    context.interpret(commands)
    print(context.variable_map)

    # e = ExprInterpreter()
    # e.interpret()
