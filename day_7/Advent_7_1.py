# with open ("dummy.txt", "r") as myfile:
with open ("data.txt", "r") as myfile:
    data = myfile.read().splitlines()

class DirNode:
  def __init__(self, name, data, depth = 0, parent = False, debug = False):
    self.name = name
    self.parent = parent
    self.directories = []
    self.dirs = dict()
    self.files = []
    self.depth = depth
    self.size = 0
    self.debug = debug

    self.path = parent.path + name +"/" if parent else name

    reading = False
    lineCount = 0
    if debug:
        print(self.path)
    for line in data:
        if lineCount < 100 and debug and reading:
            if line[0:4] == "$ ls":
                True
            else:
                _ = "/" if line[0:3] == "dir" else ""
                print("   "*(depth)  + line.split(" ")[1] + _)
                False
        if not reading:
            if line[5:] == self.name:
                # print("Reading", self.path)
                reading = True
        else:
            if line[0] == "d" and reading:
                self.directories.append(line.split(" ")[1])
            elif line[0] in "0123456789" and reading:
                self.files.append(line)
                file_size = int(line.split(" ")[0])
                self.size += file_size
            elif line[0:4] == "$ cd":
                break
        
        lineCount += 1
    
    for dir in self.directories:
        self.dirs[dir] = DirNode(dir, data[lineCount:], depth+1, self) 
           

    # if True:
    # if self.total_size() <= 100000:
    #     print(self.total_size())
    #     print() 



  def find_by_size(self, limit):
    holder = dict()
    totalSize = self.total_size()
    if totalSize <= limit:
        holder[self.path] = (totalSize)
        print(self.depth, totalSize, self.path)
    
    for dir in self.directories:
        holder[dir] = (self.dirs[dir].find_by_size(limit))
    return holder


  def total_size(self):
    sum = self.size
    for dir in self.directories:
        sum += self.dirs[dir].total_size()
    
    return sum



root = DirNode('/', data)

print(root.total_size())
# print(root.dirs['a'].total_size())
# print(root.dirs['a'].dirs['e'].total_size())
# print(root.dirs['d'].total_size())



def flatten(my_dict):
    result = {}
    for key, value in my_dict.items():
        if isinstance(value, dict):
            result.update(flatten(value))
        else:
            result[key] = value 
    return result

print()
print(sum(flatten(root.find_by_size(100000)).values()))
# print(sum(root.find_by_size(100000)))
    

