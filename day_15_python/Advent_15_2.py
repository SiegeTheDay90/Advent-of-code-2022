from multiprocessing import Pool
from time import time
start = time()
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
        self.id = Sensor.count
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


    def scanline(y):
        count = 0
        for x in range (0, 4000001):
            flag = False
            if (x, y) in Sensor.beacon_positions:
                continue
            for sensor in Sensor.sensors:
                if sensor.in_range((x, y)) and not flag:
                    flag = True
                    count += 1
            if not flag:
                print(x, y)
                print(time() - start)
                pass
        return False


def manhattan_distance(sensor_pos, beacon_pos):
    return abs(sensor_pos[0]-beacon_pos[0]) + abs(sensor_pos[1]-beacon_pos[1])



parsed_data = parse_data(data)

def pool_handler():
    p = Pool(4)
    lines = range(0, 4000001)
    p.map(Sensor.scanline, lines)

if __name__ == '__main__':
    pool_handler()


# sensor = Sensor((0, 11), (2, 10))
# print(Sensor.scanned_positions)
# print(Sensor.scanline(10))

# threads = dict()
# for i in range(0, 100):
#     threads[i] = multiprocessing.Process(target=Sensor.scanline, args=(i,))
#     threads[i].start()

# for i in threads: 
#     threads[i].join()
# if __name__ == '__main__':
#     for i in range(0, 1000):
#         Sensor.scanline(i)


