with open ("data.txt", "r") as myfile:
    data = myfile.read().splitlines()

head = [0, 0]
tail = [0, 0]
visited = set()
visited.add(tuple(tail))

for line in data:
    parts = line.split(" ")
    direction = parts[0]
    times = int(parts[1])

    for i in range(times):
        if direction == "R":
            head = [head[0]+1, head[1]]
        elif direction == "L":
            head = [head[0]-1, head[1]]
        elif direction == "U":
            head = [head[0], head[1]+1]
        elif direction == "D":
            head = [head[0], head[1]-1]
        
        if (abs(head[0] - tail[0]) > 1 or abs(head[1] - tail[1]) > 1) and (abs(head[0] - tail[0]) == 1 or abs(head[1] - tail[1]) == 1):
            if head[0] > tail[0]:
                tail[0] += 1
            if head[0] < tail[0]:
                tail[0] -= 1
            if head[1] > tail[1]:
                tail[1] += 1
            if head[1] < tail[1]:
                tail[1] -= 1
        elif abs(head[0] - tail[0]) > 1 or abs(head[1] - tail[1]) > 1:
            if head[0] > tail[0]:
                tail[0] += 1
            elif head[0] < tail[0]:
                tail[0] -= 1
            if head[1] > tail[1]:
                tail[1] += 1
            elif head[1] < tail[1]:
                tail[1] -= 1
        visited.add(tuple(tail))  
print(len(visited))