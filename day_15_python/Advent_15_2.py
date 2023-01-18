import pdb
from time import time
from collections import deque
from os import system


def build_span(spans):

    empty_indices = deque()
    # print(spans)

    for index, span in enumerate(spans):
        if len(span) == 0:
            empty_indices.appendleft(index)

    for index in empty_indices:
        spans.pop(index)

    spans = sorted(spans, key=lambda x: x[0], reverse=False)

    combined = []

    combined.append(spans.pop(0))
    # pdb.set_trace()
    for index, span in enumerate(spans):

        if combined[-1][-1]+1 >= spans[index][0]:
            if spans[index][-1] > combined[-1][-1]:
                combined[-1] = range(combined[-1][0], spans[index][-1]+2)
            else:
                continue
        else:
            combined.append(spans[index])
            

    
    return combined


with open ("data.txt", "r") as myfile:
# with open ("dummy.txt", "r") as myfile:
    data = myfile.read().splitlines()

def parse_data(data: list) -> list:
    holder = list()
    for line in data:
        words = line.split(" ")
        sensor_pos = (
            int(words[2][2:-1]),
            int(words[3][2:-1])
        )
        beacon_pos = (
            int(words[-2][2:-1]),
            int(words[-1][2:])
        )
        holder.append(
            Sensor(sensor_pos, beacon_pos)
        )

    return holder

def manhattan_distance(sensor_pos, beacon_pos):
    return abs(sensor_pos[0]-beacon_pos[0]) + abs(sensor_pos[1]-beacon_pos[1])

class Sensor:
    sensors = []
    beacon_positions= set()
    boundary = [float('inf'), float('-inf'), float('inf'), float('-inf')] #Left, Right, Up, Down

    count = 0
    def __init__(self, pos, beacon):
        Sensor.count += 1
        self.pos = pos
        Sensor.beacon_positions.add(beacon)
        self.beacon = beacon
        self.distance = manhattan_distance(pos, beacon)
        self.id = Sensor.count + 0
        print(self)

        if self.pos[0] - self.distance < Sensor.boundary[0]:
            Sensor.boundary[0] = self.pos[0] - self.distance

        if self.pos[0] + self.distance > Sensor.boundary[1]:
            Sensor.boundary[1] = self.pos[0] + self.distance

        if self.pos[1] - self.distance < Sensor.boundary[2]:
            Sensor.boundary[2] = self.pos[1] - self.distance

        if self.pos[1] + self.distance > Sensor.boundary[3]:
            Sensor.boundary[3] = self.pos[1] + self.distance
        Sensor.sensors.append(self)


    def in_range(self, pos):
        return manhattan_distance(self.pos, pos) <= self.distance

    def __str__(self):
        return "Sensor #"+str(self.id)

    def x_bound(self, y):
        y_dist = abs(self.pos[1] - y)
        return range(
            self.pos[0]-(self.distance-y_dist),
            self.pos[0]+(self.distance-y_dist)
        )


start = time()
parsed_data = parse_data(data)
final = []

for y in range(0, 4000001):
    # system('clear')
    print("Building for y =", y)
    # print("Final:", final)
    spans = []
    for sensor in parsed_data:
        spans.append(sensor.x_bound(y))
    
    combined = build_span(spans)
    if y == 1235:
        pdb.set_trace()
    if len(combined) >= 2:
        print(y, ":", combined)
        final.append(combined)
        pdb.set_trace()
print("")
print(time()-start)

