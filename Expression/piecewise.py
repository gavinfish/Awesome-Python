from instruction import *
from log import gen_log
import copy

# This should be in order, preventing missing two char cmp
CMP_LIST = ["<=", ">=", "==", "!=", "<", ">"]


class PiecewiseContext(object):
    def __init__(self):
        self.variable_map = {}
        self.commands = []
        # {label num:instructions index}
        self.labels = {}
        self.brs_index = []
        self.labels_index = []

    def interpret(self, commands):
        # Scan all the commands to get the structure
        for i, command in enumerate(commands):
            instruct = InstructionFactory.parse(command)
            self.commands.append(command)
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

        if self.brs_index:
            # Load and parse all commands before the first br instruction
            for i in range(self.brs_index[0] + 1):
                instruct = InstructionFactory.parse(self.commands[i])
                if instruct:
                    instruct.refresh_variable(self.variable_map)

            # Make copy for the values since they have to been changed in different branches
            temp_map = copy.deepcopy(self.variable_map)
            self.__scan_util_br(self.brs_index[0], temp_map)
        else:
            # Expression without branches
            for command in self.commands:
                instruct = InstructionFactory.parse(command)
                if instruct:
                    instruct.refresh_variable(self.variable_map)
                    if isinstance(instruct, ReturnInstruction):
                        print(instruct)

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
        gen_log.debug(vmap)
        br = InstructionFactory.parse(self.commands[br_index])
        br.refresh_variable(vmap)
        if not br.isdirect():
            gen_log.debug(br.cmp)
            result = self.is_cmp_valid(br.cmp)
            first_result = None
            second_result = None
            if result[0]:
                cmp_result = self.is_cmp_true(result[1], result[2], result[3])
                if cmp_result:
                    first_label = br.first_label
                    temp_map = copy.deepcopy(vmap)
                    first_result = self.__scan_instructs_left(first_label, temp_map)
                else:
                    second_label = br.second_label
                    temp_map = copy.deepcopy(vmap)
                    second_result = self.__scan_instructs_left(second_label, temp_map)
            else:
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

    # Check if cmp is computable, not containing variable
    @staticmethod
    def is_cmp_valid(cmp_str):
        for cmp in CMP_LIST:
            if cmp in cmp_str:
                parts = cmp_str.split(cmp)
                left = parts[0]
                right = parts[1]
                if left.isdecimal() and right.isdecimal():
                    # Result like this is disgusting, but it just works
                    return [True, cmp, left, right]
                return [False, cmp, left, right]
        gen_log.debug("There is no match cmp in " + cmp_str)
        return [False, None, None, None]

    @staticmethod
    def is_cmp_true(cmp, left, right):
        if "<=" == cmp:
            return float(left) <= float(right)
        elif ">=" == cmp:
            return float(left) >= float(right)
        elif "==" == cmp:
            return float(left) == float(right)
        elif "!=" == cmp:
            return float(left) != float(right)
        elif "<" == cmp:
            return float(left) < float(right)
        elif ">" == cmp:
            return float(left) > float(right)
        else:
            return None

    # Deal with instructions from the label that br instruction points to util next label
    def __scan_instructs_left(self, label, temp_map):
        for i in range(self.labels[label], self.__get_next_label_index(label)):
            instruct = InstructionFactory.parse(self.commands[i])
            if instruct:
                # If there is still br instructions, recursive solution
                if isinstance(instruct, BRInstruction):
                    return self.__scan_util_br(i, temp_map)
                else:
                    instruct.refresh_variable(temp_map)
                    if isinstance(instruct, ReturnInstruction):
                        return instruct.result

    # Get the index of the the next label
    def __get_next_label_index(self, label_num):
        index = self.labels_index.index(self.labels[label_num])
        return self.labels_index[index + 1]
