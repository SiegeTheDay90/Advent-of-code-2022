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

class Sensor:
    scanned_positions = set()
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

        if self.pos[0] - self.distance < Sensor.boundary[0]:
            Sensor.boundary[0] = self.pos[0] - self.distance

        if self.pos[0] + self.distance > Sensor.boundary[1]:
            Sensor.boundary[1] = self.pos[0] + self.distance

        if self.pos[1] - self.distance < Sensor.boundary[2]:
            Sensor.boundary[2] = self.pos[1] - self.distance

        if self.pos[1] + self.distance > Sensor.boundary[3]:
            Sensor.boundary[3] = self.pos[1] + self.distance
        Sensor.sensors.append(self)
        # self.scan()

    def in_range(self, pos):
        return manhattan_distance(self.pos, pos) <= self.distance

    def __str__(self):
        return "Sensor #"+str(self.id)

    def scan(self):
        print(self, "scanning")
        print("At distance " + str(self.distance))
        for x in range(self.pos[0]-(self.distance), self.pos[0]+self.distance+1):
            x_dist = abs(self.pos[0] - x)
            for y in range(self.pos[1]-(self.distance-x_dist), self.pos[1]+(self.distance-x_dist)):
                Sensor.scanned_positions.add((x, y))
                print(x, y)

        # print(len(Sensor.scanned_positions))

    def scanline(y):
        count = 0
        # print(Sensor.boundary[1]+1, Sensor.boundary[0])
        # for x in range(Sensor.boundary[0], Sensor.boundary[1]+1):
        # print(Sensor.boundary[0], Sensor.boundary[1])
        for x in range(1000000, 2000001):
            # print("X: ", x)
            # print("Count: ", count)
            flag = False
            if (x, y) in Sensor.beacon_positions:
                # print("That's a sensor.")
                count += 1
                continue
            for sensor in Sensor.sensors:
                if sensor.in_range((x, y)):
                    # print(x, y)
                    flag = True
                    count += 1

                    break
            if not flag:
                print("Found at: ", x,y)
                pass

        return count


def manhattan_distance(sensor_pos, beacon_pos):
    return abs(sensor_pos[0]-beacon_pos[0]) + abs(sensor_pos[1]-beacon_pos[1])



parsed_data = parse_data(data)
# sensor = Sensor((0, 11), (2, 10))
# print(Sensor.scanned_positions)
# for i in range(0,21):
#     print(Sensor.scanline(i))
from time import time

start = time()
readings = []
for i in range(1000000, 2000001):
    readings.append(Sensor.scanline(i))
    # print(i)
    # print(readings[-1])

print(time() - start)