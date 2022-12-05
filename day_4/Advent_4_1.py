with open ("data.txt", "r") as myfile:
    data = myfile.read().splitlines()


data = list(map(lambda x: x.split(","), data))
count = 0;

zones = list()

for zone in data:
    zones.append(list(map(lambda x: x.split("-"), zone)))

for zone in zones:
    if int(zone[0][0]) >= int(zone[1][0]) and int(zone[0][1]) <= int(zone[1][1]):
        count += 1
    elif int(zone[1][0]) >= int(zone[0][0]) and int(zone[1][1]) <= int(zone[0][1]):
        count += 1

print(count)

