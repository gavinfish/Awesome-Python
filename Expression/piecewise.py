from instruction import *
from log import gen_log


class PiecewiseContext(object):
    def __init__(self):
        self.variable_map = {}
        self.instructs = []
        # {label num:instructions index}
        self.labels = {}
        self.brs = []
        self.labels_index = []

    def interpret(self, commands):
        for i, command in enumerate(commands):
            instruct = InstructionFactory.parse(command)
            self.instructs.append(command)
            if instruct:
                instruct.refresh_variable(self.variable_map)
                if isinstance(instruct, BRInstruction):
                    self.brs.append(instruct)
                elif isinstance(instruct, LABELInstruction):
                    self.labels[instruct.num] = i
                    self.labels_index.append(i)
            else:
                gen_log.warning("cannot parse command: " + command)

        for br in self.brs:
            if not br.isdirect():
                first_label = br.first_label
                second_label = br.second_label
                first_result = self.__scan_instructs_next(first_label)
                second_result = self.__scan_instructs_next(second_label)
                print(first_result + "," + br.cmp)
                print(second_result + "," + self.reverse_cmp_condition(br.cmp))

    @staticmethod
    def reverse_cmp_condition(cmp):
        result = ""
        if ">=" in cmp:
            result = cmp.replace(">=", "<")
        elif "=<" in cmp:
            result = cmp.replace("<=", ">")
        elif ">" in cmp:
            result = cmp.replace(">", "<=")
        elif "<" in cmp:
            result = cmp.replace("<", ">=")
        return result

    def __scan_instructs_next(self, label):
        for i in range(self.labels[label], self.__get_next_label_index(label)):
            instruct = InstructionFactory.parse(self.instructs[i])
            if instruct:
                instruct.refresh_variable(self.variable_map)
                if isinstance(instruct, BRInstruction):
                    if instruct.isdirect():
                        for j in range(self.labels[instruct.target], len(self.instructs)):
                            instruct = InstructionFactory.parse(self.instructs[j])
                            if instruct:
                                instruct.refresh_variable(self.variable_map)
                            if isinstance(instruct, ReturnInstruction):
                                return instruct.result

    def __get_next_label_index(self, label_num):
        index = self.labels_index.index(self.labels[label_num])
        return self.labels_index[index + 1]
