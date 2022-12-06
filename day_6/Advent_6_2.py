from collections import deque

def solution():
    with open ("data.txt", "r") as myfile:
        data = myfile.read()

    queue = [*data[0:14]]
    counter = 14

    if queueCheck(queue):
        return 14

    for index in range(14, len(data)):
        counter += 1
        queue = deque(queue)
        queue.popleft()
        queue.append(data[index])
        queue = list(queue)
        if queueCheck(queue):
            return counter



def queueCheck(queue):
    for index, char in enumerate(queue):
        arr = queue[0:index] + queue[index+1:14]
        if char in arr:
            return False
    return True

print(solution())