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
    count = 0
    def __init__(self, pos, beacon):
        Sensor.count += 1
        self.pos = pos
        self.beacon = beacon
        self.distance = manhattan_distance(pos, beacon)
        self.id = Sensor.count + 0
        self.scan()

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
        for pos in Sensor.scanned_positions:
            if pos[1] == y:
                count += 1
        return count


def manhattan_distance(sensor_pos, beacon_pos):
    return abs(sensor_pos[0]-beacon_pos[0]) + abs(sensor_pos[1]-beacon_pos[1])



parsed_data = parse_data(data)
# sensor = Sensor((0, 11), (2, 10))
# print(Sensor.scanned_positions)
print(Sensor.scanline(2000000))


