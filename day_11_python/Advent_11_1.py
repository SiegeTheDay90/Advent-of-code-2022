import pprint
# from collections import deque
from math import floor

with open ("dummy.txt", "r") as myfile:
    data = myfile.read().splitlines()

class Monkey:
    def __init__(self, number: int, items: list, operation, test, true_target, false_target):
        self.items = items
        self.number = number
        self.operation = operation
        self.test = test
        self.true_target = true_target
        self.false_target = false_target
        self.inspected = 0

    def throw(self):
        for index in range(len(self.items)):
            self.items[index] = self.operation(self.items[index])
            self.items[index] = floor(self.items[index]/3)
            self.inspected += 1
            if(self.test(self.items[index])):
                monkeys[self.true_target].items.append(self.items[index])
            else:
                monkeys[self.false_target].items.append(self.items[index])
        
        self.items = []


monkeys = list()

monkeys.extend([
Monkey(0, [84,72,58,51], lambda x: x*3, lambda x: x%13 == 0, 1, 7),
Monkey(1, [88, 58, 58], lambda x: x+8, lambda x: x%2 == 0, 7, 5),
Monkey(2, [93,82,71,77,83,53,71,89], lambda x: x*x, lambda x: x%7 == 0, 3, 4),
Monkey(3, [81, 68, 65, 81, 73, 77, 96], lambda x: x+2, lambda x: x%17 == 0, 4, 6),
Monkey(4, [75,80,50,73,88], lambda x: x+3, lambda x: x%5 == 0, 6, 0),
Monkey(5, [59,72,99,87,91,81], lambda x: x*17, lambda x: x%11 == 0, 2, 3),
Monkey(6, [86,69], lambda x: x+6, lambda x: x%3 == 0, 1, 0),
Monkey(7, [91], lambda x: x+1, lambda x: x%19 == 0, 2, 5)
])

for i in range(20):
    monkeys[0].throw()
    monkeys[1].throw()
    monkeys[2].throw()
    monkeys[3].throw()
    monkeys[4].throw()
    monkeys[5].throw()
    monkeys[6].throw()
    monkeys[7].throw()






pp = pprint.PrettyPrinter()
pp.pprint(monkeys[0].inspected)
pp.pprint(monkeys[1].inspected)
pp.pprint(monkeys[2].inspected)
pp.pprint(monkeys[3].inspected)
pp.pprint(monkeys[4].inspected)
pp.pprint(monkeys[5].inspected)
pp.pprint(monkeys[6].inspected)
pp.pprint(monkeys[7].inspected)
# pp.pprint(monkeys[0].inspected*monkeys[1].inspected*monkeys[2].inspected*monkeys[3].inspected*monkeys[4].inspected*monkeys[5].inspected*monkeys[6].inspected*monkeys[7].inspected)

pp.pprint(234*237)
