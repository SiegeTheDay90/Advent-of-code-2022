with open ("data.txt", "r") as myfile:
    data = myfile.read().splitlines()

snake = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
head = snake[0]
tail = snake[9]
visited = set()
visited.add(tuple(tail))

for line in data:
    parts = line.split(" ")
    direction = parts[0]
    times = int(parts[1])

    for i in range(times):
        #Move the head of the snake
        if direction == "R":
            snake[0] = [snake[0][0]+1, snake[0][1]]
        elif direction == "L":
            snake[0] = [snake[0][0]-1, snake[0][1]]
        elif direction == "U":
            snake[0] = [snake[0][0], snake[0][1]+1]
        elif direction == "D":
            snake[0] = [snake[0][0], snake[0][1]-1]
        print(snake[0])
        
        #The head and each subsequent part "pull" their respective tails behind them
        for i in range(0,9):
            if (abs(snake[i][0] - snake[i+1][0]) > 1 or abs(snake[i][1] - snake[i+1][1]) > 1) and (abs(snake[i][0] - snake[i+1][0]) == 1 or abs(snake[i][1] - snake[i+1][1]) == 1):
                if snake[i][0] > snake[i+1][0]:
                    snake[i+1][0] += 1
                if snake[i][0] < snake[i+1][0]:
                    snake[i+1][0] -= 1
                if snake[i][1] > snake[i+1][1]:
                    snake[i+1][1] += 1
                if snake[i][1] < snake[i+1][1]:
                    snake[i+1][1] -= 1

            elif abs(snake[i][0] - snake[i+1][0]) > 1 or abs(snake[i][1] - snake[i+1][1]) > 1:
                if snake[i][0] > snake[i+1][0]:
                    snake[i+1][0] += 1
                elif snake[i][0] < snake[i+1][0]:
                    snake[i+1][0] -= 1
                if snake[i][1] > snake[i+1][1]:
                    snake[i+1][1] += 1
                elif snake[i][1] < snake[i+1][1]:
                    snake[i+1][1] -= 1
            if i == 8:
                #store the tail position, not counting repeats
                visited.add(tuple(tail))

print(len(visited))