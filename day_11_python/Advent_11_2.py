with open ("dummy.txt", "r") as myfile:
    data = myfile.read().splitlines()

class Monkey:
    item_id = 0

    def __init__(self,number, items: list, operation, divisor, true_target, false_target, debug = False):
        self.items = dict()
        self.primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149]

        for item in items:
            self.items[Monkey.item_id] = dict()
            for prime in self.primes:
                self.items[Monkey.item_id][prime] = item%prime
            Monkey.item_id += 1
    

        self.number = number
        self.operation = operation
        self.divisor = divisor
        self.true_target = true_target
        self.false_target = false_target
        self.inspected = 0 
        self.debug = debug

    def throw(self):

        for item_id in self.items.keys(): # Perform an operation on, test, and throw each item

            for prime in self.primes:
                self.items[item_id][prime] = self.operation(self.items[item_id][prime])%prime
            self.inspected += 1 # Increment the number of items this monkey has inspected (Monkey Business)

            if(self.items[item_id][self.divisor] == 0):
                monkeys[self.true_target].items[item_id] = self.items[item_id]
                if self.debug: print("Monkey ", self.number," passes to ",self.true_target)
            else:
                monkeys[self.false_target].items[item_id] = self.items[item_id]
                if self.debug: print("Monkey ", self.number," passes to ",self.false_target)
        
        self.items = dict() # All Items have been thrown away



monkeys = list()

# Puzzle Input
monkeys.extend([
Monkey(0, [84,72,58,51], lambda x: x*3, 13, 1, 7),
Monkey(1, [88,58,58], lambda x: x+8, 2, 7, 5),
Monkey(2, [93,82,71,77,83,53,71,89], lambda x: x*x, 7, 3, 4),
Monkey(3, [81,68, 65, 81, 73, 77, 96], lambda x: x+2, 17, 4, 6),
Monkey(4, [75,80,50,73,88], lambda x: x+3, 5, 6, 0),
Monkey(5, [59,72,99,87,91,81], lambda x: x*17, 11, 2, 3),
Monkey(6, [86,69], lambda x: x+6, 3, 1, 0),
Monkey(7, [91], lambda x: x+1, 19, 2, 5)
])

# Test Input
# monkeys.extend([
# Monkey(0, [79, 98], lambda x: x*19, 23, 2, 3),
# Monkey(1, [54, 65, 75, 74], lambda x: x+6, 19, 2, 0),
# Monkey(2, [79, 60, 97], lambda x: x*x, 13, 1, 3),
# Monkey(3, [74], lambda x: x+3, 17, 0, 1),
# ])

for i in range(10000):
    monkeys[0].throw()
    monkeys[1].throw()
    monkeys[2].throw()
    monkeys[3].throw()
    monkeys[4].throw()
    monkeys[5].throw()
    monkeys[6].throw()
    monkeys[7].throw()






print(monkeys[0].inspected)
print(monkeys[1].inspected)
print(monkeys[2].inspected)
print(monkeys[3].inspected)
print(monkeys[4].inspected)
print(monkeys[5].inspected)
print(monkeys[6].inspected)
print(monkeys[7].inspected)

