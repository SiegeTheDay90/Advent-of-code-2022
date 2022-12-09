from collections import deque

def solution():
    with open ("data.txt", "r") as myfile:
        data = myfile.read()

    queue = [data[0], data[1], data[2], data[3]]
    counter = 4

    if queueCheck(queue):
        return 4

    for index in range(4, len(data)):
        counter += 1
        queue = deque(queue)
        queue.popleft()
        queue.append(data[index])
        queue = list(queue)
        if queueCheck(queue):
            return counter



def queueCheck(queue):
    for index, char in enumerate(queue):
        arr = queue[0:index] + queue[index+1:4]
        if char in arr:
            return False
    return True

print(solution())