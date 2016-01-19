import re
from log import gen_log
from piecewise import PiecewiseContext


class ExprInterpreter(object):
    def interpret(self):
        interpreter = ExprInterpreter()
        data = interpreter.load_data("example-list.ll")
        m = interpreter.get_methods(data)
        for target in m:
            commands = ExprInterpreter.get_commands(target)
            context = PiecewiseContext()
            context.interpret(commands)

    @staticmethod
    def load_data(path):
        with open(path) as f:
            data = f.read()
            gen_log.info("log file " + path + " successfully")

        return data

    @staticmethod
    def get_methods(source):
        method_pattern = re.compile("(; Function Attrs:.*?)}", re.S)

        methods = re.findall(method_pattern, source)
        return methods

    @staticmethod
    def get_method_name(method):
        name_pattern = re.compile("@.*?\(")
        result = re.search(name_pattern, method)
        if not result:
            gen_log.error("cannot find method name in method: " + method)
        else:
            name = result.group()[1:-1]
            return name

    @staticmethod
    def get_commands(method):
        body_pattern = re.compile("{\n.*", re.S)
        result = re.search(body_pattern, method)
        commands_list = []
        if not result:
            gen_log.error("cannot find commands in method: " + method)
        else:
            commands = result.group()[2:]
            commands_list = commands.split("\n")
            # Skip blank line
            commands_list = [line for line in commands_list if line]
        return commands_list
