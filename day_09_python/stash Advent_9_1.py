with open ("text.txt", "r") as myfile:
    data = myfile.read().splitlines()

class Head:
    def __init__(self):
        self.position = [0, 0]
        self.tail_position = [0, 0]
        self.visited = set()
        self.visited.add((0, 0))
        self.in_order = list()
        self.in_order.append((0, 0))


    def move(self, direction, times=1):
        for i in range(times):
            overlap = self.position == self.tail_position
            if direction == "R":
                self.position = [self.position[0]+1, self.position[1]]
            if direction == "L":
                self.position = [self.position[0]-1, self.position[1]]
            if direction == "U":
                self.position = [self.position[0], self.position[1]+1]
            if direction == "D":
                self.position = [self.position[0], self.position[1]-1]
            if not overlap:
                self.move_tail()
    
    def move_tail(self):
        if self.tail_position[0] == self.position[0] or self.tail_position[1] == self.position[1]:
            if self.position[0] - self.tail_position[0] > 1:
                self.tail_position[0] += 1
            elif self.position[0] - self.tail_position[0] < -1:
                self.tail_position[0] -= 1
            elif self.position[1] - self.tail_position[1] > 1:
                self.tail_position[1] += 1
            elif self.position[1] - self.tail_position[1] < 1:
                self.tail_position[1] -= 1
        elif abs(self.position[1] - self.tail_position[1]) > 1 or abs(self.position[0] - self.tail_position[0]) > 1:
            if self.position[0] > self.tail_position[0]:
                self.tail_position[0] += 1
            elif self.position[0] < self.tail_position[0]:
                self.tail_position[0] -= 1
            if self.position[1] > self.tail_position[1]:
                self.tail_position[1] += 1
            elif self.position[1] < self.tail_position[1]:
                self.tail_position[1] -= 1
        
        self.visited.add(tuple(self.tail_position))
        self.in_order.append(tuple(self.tail_position))


start = Head()
# print(start.position)

for line in data:
    # print(line)
    parts = line.split(" ")
    direction = parts[0]
    times = int(parts[1])
    start.move(direction, times)
    # print(start.position)
    # print(start.tail_position)

# print(start.position)
# print(start.tail_position)
# print(len(start.visited))
print(start.visited)
print()
print(start.in_order)
# for move in start.in_order:
#     print(move)