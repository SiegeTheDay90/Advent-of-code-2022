import json
with open ("data.txt", "r") as myfile:
# with open ("dummy.txt", "r") as myfile:
    data = myfile.read().splitlines()



def cleanup(line):
    holder = line.strip().split(" -> ")

    def arrayify(str):
        return json.loads("["+str+"]")

    return list(map(arrayify, holder))

file_data = list(map(cleanup, data))

walls = set()

for line in file_data:
    reading = line[:]

    walls.add(tuple(reading[0]))
    last = reading.pop(0)

    while len(reading):
        pos = reading.pop(0)

        if last[0] == pos[0]:
            if last[1] < pos[1]:
                for y in range(last[1], pos[1]+1):
                    walls.add(tuple([last[0], y]))
            elif last[1] > pos[1]:
                for y in range(pos[1], last[1]+1):
                    walls.add(tuple([last[0], y]))
        
        if last[1] == pos[1]:
            if last[0] < pos[0]:
                for x in range(last[0], pos[0]+1):
                    walls.add(tuple([x, last[1]]))
            elif last[0] > pos[0]:
                for x in range(pos[0], last[0]+1):
                    walls.add(tuple([x, last[1]]))
        
        last = pos
# print(len(walls))
class Sand:
    count = 0
    def __init__(self):
        self.pos = [500, 0]
        self.falling = True
        Sand.count += 1
    
    def drop(self, walls):
        steps = 0
        while self.falling:
            steps += 1
            if steps > 750:
                # print("Fallen")
                return False
            if tuple([self.pos[0], self.pos[1]+1]) not in walls:
                self.pos[1] += 1
            elif tuple([self.pos[0]-1, self.pos[1]+1]) not in walls:
                self.pos[0] -= 1
                self.pos[1] += 1
            elif tuple([self.pos[0]+1, self.pos[1]+1]) not in walls:
                self.pos[0] += 1
                self.pos[1] += 1
            else:
                self.falling = False
                walls.add(tuple(self.pos))
                # print("Rest")
                # print(Sand.count)
                # print(self.pos)
                # print()
                return True
        
sand = Sand()

# print(sand) 
while sand.drop(walls):
    sand = Sand()

print(Sand.count - 1)

