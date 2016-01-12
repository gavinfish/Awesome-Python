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
  %2 = load i32* %1, align 4, !dbg !123
  %3 = mul nsw i32 %2, 2, !dbg !123
  store i32 %3, i32* %r, align 4, !dbg !123
  %4 = load i32* %r, align 4, !dbg !124
  %5 = icmp slt i32 %4, 0, !dbg !124
  %6 = load i32* %r, align 4, !dbg !126
  br i1 %5, label %7, label %9, !dbg !124

; <label>:7                                       ; preds = %0
  %8 = add nsw i32 %6, 3, !dbg !126
  store i32 %8, i32* %r, align 4, !dbg !126
  br label %16, !dbg !128

; <label>:9                                       ; preds = %0
  %10 = icmp sgt i32 %6, 0, !dbg !129
  %11 = load i32* %r, align 4, !dbg !131
  br i1 %10, label %12, label %14, !dbg !129

; <label>:12                                      ; preds = %9
  %13 = sub nsw i32 %11, 3, !dbg !131
  store i32 %13, i32* %r, align 4, !dbg !131
  br label %16, !dbg !133

; <label>:14                                      ; preds = %9
  %15 = mul nsw i32 %11, 10, !dbg !134
  store i32 %15, i32* %r, align 4, !dbg !134
  br label %16

; <label>:16                                      ; preds = %12, %14, %7
  %17 = load i32* %r, align 4, !dbg !136
  ret i32 %17, !dbg !136
}'''
    m = ExprInterpreter.get_methods(data)
    commands = ExprInterpreter.get_commands(m[0])
    context = PiecewiseContext()
    context.interpret(commands)
    print(context.variable_map)

    # e = ExprInterpreter()
    # e.interpret()
