with open ("data.txt", "r") as myfile:
    data = myfile.read().splitlines()


data = list(map(lambda x: x.split(","), data))
count = 0;

zones = list()

for zone in data:
    zones.append(list(map(lambda x: x.split("-"), zone)))

for zone in zones:
    first_start = int(zone[0][0])
    first_end = int(zone[0][1])
    second_start = int(zone[1][0])
    second_end = int(zone[1][1])

    if first_start >= second_start and first_end <= second_end:
        count += 1

    elif first_start <= second_start and first_end >= second_end:
        count += 1

    elif first_start <= second_start and first_end >= second_start:
        count += 1

    elif first_start <= second_end and first_end >= second_end:
        count += 1

print(count)

