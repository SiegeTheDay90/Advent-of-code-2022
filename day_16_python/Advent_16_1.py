from collections import defaultdict
import pdb

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
        self.max = 0

    def parse_data(self, data: list) -> dict:
        raw_edges = defaultdict(lambda: dict())
        for line in data:
            words = line.split(" ")
            name = words[1]
            rate = int(words[4][5:-1])
            self.nodes[name] = rate
            if rate > 0:
                self.value_nodes.add(name)
            raw_outs = words[9:]
            for out in raw_outs:
                raw_edges[name][out.replace(',', '')] = 1

        compressed_edges = defaultdict(lambda: dict())

        for node in self.nodes:
            others = filter(lambda x: x != node, self.nodes.keys())

            for other_node in others:
                if self.nodes[other_node] > 0:
                    compressed_edges[node][other_node] = self.distance(
                        node,
                        other_node,
                        raw_edges
                    )
            
        return compressed_edges
    
    def distance(self, src, dst, edges):
        counter = 0
        onDeck = list(edges[src])
        closed = set()
        # pdb.set_trace()

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
    
    def solve(self, current = "AA", order = (), time_left = 31, value = 0):
        if len(order) == len(self.value_nodes):
            return value + self.nodes[current] * (time_left - 1)
        
        order += tuple([current])
        most = 0
        self.dp[order] = value + self.nodes[current] * (time_left - 1)
        
        for node in self.value_nodes - set(order):
            memo = self.solve(
                node, 
                order, 
                time_left - self.edges[current][node] - 1, 
                self.dp[order]
            )
            if memo > most:
                most = memo

        return most
       


test = Solution(dummy)

real = Solution(data)

# print(s.nodes)
# print(s.edges)
print(test.solve())
# print(real.solve())