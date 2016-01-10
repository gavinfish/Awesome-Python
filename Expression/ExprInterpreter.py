import re


class ExprInterpreter(object):
    methods = []

    def load_data(self, path):
        with open("assembly.ll") as f:
            data = f.read()
        return data

    def get_methods(self, source):
        method_pattern = re.compile("(; Function Attrs:.*?)}", re.S)
        methods = re.findall(method_pattern, source)
        return methods

    def get_method_name(self, method):
        name_pattern = re.compile("@.*?\(")
        result = re.search(name_pattern, method)
        if not result:
            print("cannot find method name in method: " + method)
        else:
            name = result.group()[1:-1]
            return name

    def get_commands(self, methd):
        body_pattern = re.compile("{\n.*", re.S)
        result = re.search(body_pattern, methd)
        if not result:
            print("cannot find commands in method: " + methd)
        else:
            commands = result.group()[2:]
            commands_list = commands.split("\n")
            return commands_list



if __name__ == "__main__":
    expreinter = ExprInterpreter()
    data = expreinter.load_data("")
    m = expreinter.get_methods(data)
    target = m[0]
    commands = expreinter.get_commands(target)
    print(commands)
