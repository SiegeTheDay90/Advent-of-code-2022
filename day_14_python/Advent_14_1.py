import json
with open ("data.txt", "r") as myfile:
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

    walls.add(reading[0])
    last = reading.pop(0)

    while reading[0]:
        pos = reading.pop(0)

        if 
        
    pass