#coding=utf-8
class Rule:
    """所有规则的基类"""
    def action(self, block, handler):
        handler.start(self.type)
        handler.feed(block)
        handler.end(self.type)
        return True


class HeadingRule(Rule):
    """标题占一行，最多70个字符，并且不以冒号结尾"""
    type = 'heading'
    def condition(self, block):
        return not '\n' in block and len(block) <= 70 and not block[-1] == ':'


class TitleRule(HeadingRule):
    """题目是文档的第一个块，但前提是它是大标题"""
    type = 'title'
    first = True
    def condition(self, block):
        if not self.first:
            return False
        self.first = False
        return HeadingRule.condition(self, block)


class ListItemRule(Rule):
    """列表项是以连字符开始的段落，作为格式化的一部分，要移除连字符"""
    type = 'listitem'
    def condition(self, block):
        return block[0] == '-'

    def action(self, block, handler):
        handler.start(self.type)
        handler.feed(block[1:].strip())
        handler.end(self.type)
        return True


class ListRule(ListItemRule):
    """列表从不是列表项的块和随后的列表项之间，在最后一个连续列表项之后结束"""
    type = 'list'
    inside = False
    def condition(self, block):
        return True

    def action(self, block, handler):
        if not self.inside and ListItemRule.condition(self, block):
            handler.start(self.type)
            self.inside = True
        elif self.inside and not ListItemRule.condition(self, block):
            handler.end(self.type)
            self.inside = False
        return False


class ParagraphRule(Rule):
    """段落只是其他规则没有覆盖到的块"""
    type = 'paragraph'
    def condition(self, block):
        return True
