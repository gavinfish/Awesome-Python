from instruction import *
from log import gen_log
import copy


class PiecewiseContext(object):
    def __init__(self):
        self.variable_map = {}
        self.instructs = []
        # {label num:instructions index}
        self.labels = {}
        self.brs_index = []
        self.labels_index = []

    def interpret(self, commands):
        # Scan all the commands to get the structure
        for i, command in enumerate(commands):
            instruct = InstructionFactory.parse(command)
            self.instructs.append(command)
            if instruct:
                # instruct.refresh_variable(self.variable_map)
                if isinstance(instruct, BRInstruction):
                    self.brs_index.append(i)
                elif isinstance(instruct, LABELInstruction):
                    self.labels[instruct.num] = i
                    self.labels_index.append(i)
            else:
                gen_log.warning("cannot parse command: " + command)

        # Load all commands before the first branch
        for i in range(self.brs_index[0] + 1):
            instruct = InstructionFactory.parse(self.instructs[i])
            if instruct:
                instruct.refresh_variable(self.variable_map)

        # for i in self.brs_index:
        #     temp_map = copy.deepcopy(self.variable_map)
        #     print(temp_map)
        #     br = InstructionFactory.parse(self.instructs[i])
        #     if not br.isdirect():
        #         first_label = br.first_label
        #         second_label = br.second_label
        #         first_result = self.__scan_instructs_left(first_label, temp_map)
        #         second_result = self.__scan_instructs_left(second_label, temp_map)
        #         print(first_result + "," + br.cmp)
        #         if second_result:
        #             print(second_result + "," + self.reverse_cmp_condition(br.cmp))
        #     print(temp_map)
        temp_map = copy.deepcopy(self.variable_map)
        # for i in self.brs_index:
        self.__scan_util_br(self.brs_index[0], temp_map)

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

    def __scan_util_br(self, br_index, vmap):
        temp_map = copy.deepcopy(vmap)
        br = InstructionFactory.parse(self.instructs[br_index])
        if not br.isdirect():
            first_label = br.first_label
            second_label = br.second_label
            first_result = self.__scan_instructs_left(first_label, temp_map)
            second_result = self.__scan_instructs_left(second_label, temp_map)
            if first_result:
                print(first_result + "," + br.cmp)
            if second_result:
                print(second_result + "," + self.reverse_cmp_condition(br.cmp))

    def __scan_instructs_left(self, label, temp_map):
        t = copy.deepcopy(temp_map)
        for i in range(self.labels[label], self.__get_next_label_index(label)):
            instruct = InstructionFactory.parse(self.instructs[i])
            if instruct:
                instruct.refresh_variable(temp_map)
                if isinstance(instruct, BRInstruction):
                    if instruct.isdirect():
                        for j in range(self.labels[instruct.target], len(self.instructs)):
                            instruct = InstructionFactory.parse(self.instructs[j])
                            if instruct:
                                instruct.refresh_variable(temp_map)
                            if isinstance(instruct, ReturnInstruction):
                                print(temp_map)
                                return instruct.result
                    else:
                        self.__scan_util_br(i, t)

    def __get_next_label_index(self, label_num):
        index = self.labels_index.index(self.labels[label_num])
        return self.labels_index[index + 1]
