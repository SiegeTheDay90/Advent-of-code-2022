from collections import defaultdict

with open ("dummy.txt", "r") as myfile:
    dummy = myfile.read().splitlines()
with open ("data.txt", "r") as myfile:
    data = myfile.read().splitlines()


class Solution:
    def __init__(self, data):
        self.nodes = dict()
        self.value_nodes = set()
        self.edges = self.parse_data(data)
        self.dp = dict()

    def parse_data(self, data: list) -> dict:
        bit = 0
        raw_edges = defaultdict(dict)
        for line in data:
            words = line.split(" ")
            name = words[1]
            rate = int(words[4][5:-1])
            self.nodes[name] = rate
            if rate > 0:
                self.value_nodes.add(name)
                bit += 1
            raw_outs = words[9:]
            for out in raw_outs:
                raw_edges[name][out.replace(',', '')] = 1

        compressed_edges = defaultdict(dict)
        

        for node in self.nodes:

            for other_node in self.nodes:
                if self.nodes[other_node] > 0:
                    compressed_edges[node][other_node] = self.distance(
                        node,
                        other_node,
                        raw_edges
                    )
        
            
        return compressed_edges
    
    def distance(self, src, dst, edges):
        if src == dst:
            return 0
        counter = 0
        onDeck = list(edges[src])
        closed = set()

        while onDeck:
            counter += 1
            holder = list()
            for node in onDeck:
                closed.add(node)
                if node == dst:
                    return counter
                else:
                    holder += list(filter(
                        lambda edge: edge not in closed, 
                        list(edges[node])
                    ))
            onDeck = holder
        return -1
    
    
    
    def solve(self, current = "AA", time_left = 30, open_set = set()):
    
        
        maximum = 0

        for node in (self.value_nodes - open_set):
            
            if self.edges[current][node] >= time_left:
                continue

            copy_set = open_set.copy()
            copy_set.add(node)

            total = sum([self.nodes[x]*(self.edges[current][node]+1) for x in open_set])
            current_total = (
                total + self.solve(
                    node, 
                    time_left - self.edges[current][node]-1, 
                    copy_set
                    )
                )

            if current_total > maximum:
                maximum = current_total

        return max([
            maximum, 
            sum([self.nodes[node]*time_left for node in open_set])
        ])


            
       


test = Solution(dummy)

real = Solution(data)

# print(s.nodes)
# print(s.edges)
print(test.solve("AA"))
print(real.solve("NQ"))