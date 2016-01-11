import re


class ExprInterpreter(object):
    methods = []

    def load_data(self, path):
        with open(path) as f:
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

    def get_commands(self, method):
        body_pattern = re.compile("{\n.*", re.S)
        result = re.search(body_pattern, method)
        commands_list = []
        if not result:
            print("cannot find commands in method: " + method)
        else:
            commands = result.group()[2:]
            commands_list = commands.split("\n")
            # Skip blank line
            commands_list = [line for line in commands_list if line]
        return commands_list