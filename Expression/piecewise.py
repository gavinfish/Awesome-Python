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
                # Record br and label instruction
                if isinstance(instruct, BRInstruction):
                    self.brs_index.append(i)
                elif isinstance(instruct, LABELInstruction):
                    self.labels[instruct.num] = i
                    self.labels_index.append(i)
            else:
                gen_log.warning("cannot parse command: " + command)

        # Add stop label index
        self.labels_index.append(len(commands))

        # Load and parse all commands before the first br instruction
        for i in range(self.brs_index[0] + 1):
            instruct = InstructionFactory.parse(self.instructs[i])
            if instruct:
                instruct.refresh_variable(self.variable_map)

        # Make copy for the values since they have to been changed in different branches
        temp_map = copy.deepcopy(self.variable_map)
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

    # Deal with the br instruction
    def __scan_util_br(self, br_index, vmap):
        br = InstructionFactory.parse(self.instructs[br_index])
        br.refresh_variable(vmap)
        if not br.isdirect():
            # Deal with different branches
            first_label = br.first_label
            second_label = br.second_label
            temp_map = copy.deepcopy(vmap)
            first_result = self.__scan_instructs_left(first_label, temp_map)
            temp_map = copy.deepcopy(vmap)
            second_result = self.__scan_instructs_left(second_label, temp_map)
            if first_result:
                print(first_result + "," + br.cmp)
            if second_result:
                # print(second_result + "," + self.reverse_cmp_condition(br.cmp))
                # TODO Adjust to support more than two branches
                print(second_result)
        else:
            return self.__scan_instructs_left(br.target, vmap)

    # Deal with instructions from the label that br instruction points to util next label
    def __scan_instructs_left(self, label, temp_map):
        for i in range(self.labels[label], self.__get_next_label_index(label)):
            instruct = InstructionFactory.parse(self.instructs[i])
            if instruct:
                instruct.refresh_variable(temp_map)
                # If there is still br instructions, recursive solution
                if isinstance(instruct, BRInstruction):
                    if instruct.isdirect():
                        return self.__scan_instructs_left(instruct.target, temp_map)
                    else:
                        self.__scan_util_br(i, temp_map)
                elif isinstance(instruct, ReturnInstruction):
                    return instruct.result

    # Get the index of the the next label
    def __get_next_label_index(self, label_num):
        index = self.labels_index.index(self.labels[label_num])
        return self.labels_index[index + 1]