from InstructionFactory import InstructionFactory

if __name__ == "__main__":
    commands = ['  %1 = alloca i32, align 4', '  %r = alloca i32, align 4', '  store i32 %x, i32* %1, align 4',
                '  %2 = load i32* %1, align 4, !dbg !131', '  %3 = add nsw i32 %2, 10, !dbg !131',
                '  store i32 %3, i32* %r, align 4, !dbg !131', '  %4 = load i32* %r, align 4, !dbg !132',
                '  ret i32 %4, !dbg !132', '']
    command = commands[0]
    instruct = InstructionFactory.parse(command)
    print(instruct)
