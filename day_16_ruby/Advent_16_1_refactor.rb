require "byebug"
class PipeGraph
    attr_accessor :head, :total_released, :potential, :total_rate, :time_remaining, :pipes, :name, :visited, :parent, :earned
    def initialize(file_name, head, parent = nil, visited = nil)
        @parent = parent
        @file_name = file_name
        @visited = visited ? visited : []
        @total_released = 0
        @total_rate = 0
        @potential = 0
        @earned = parent ? parent.earned : 0
        @pipes = Hash.new()
        @time_remaining = parent ? parent.time_remaining : 30
        @name = "#{self.object_id}"
        @child_moves = []

        file = File.open(file_name)
        
        file_data = file.read()

        file_data = file_data.split("\r\n")

        file_data.each do |line|
            name = line.split(" ")[1]
            rate = line.split(" ")[4][5..-1].to_i
            Pipe.new(name, rate, self)
        end

        file_data.each do |line|
            name = line.split(" ")[1]
            raw_outs = line.split(" ")[9..-1]
            for out in raw_outs
                @pipes[name].outs << @pipes[out.slice(0, 2)]
            end
        end

        @head = @pipes[head]

        if parent
            for pipe in @pipes.values
                if parent.pipes[pipe.name].open?
                    pipe.open!
                end
                until pipe.released == parent.pipes[pipe.name].released
                    pipe.step()
                end
            end
        end

        @pipes.each_value do |pipe|
            @potential += value(pipe)
        end

    end

    def run
        visited = [@head]
        while @pipes.values.any?{|pipe| self.value(pipe) > 0} && @time_remaining > 0
            target = @pipes[self.choose_target(visited)]
            # debugger if target == @pipes["AA"]
            self.step(target.name)
            visited << @head

            next_target = @pipes[self.choose_target]

            if next_target.rate >= (distance(next_target)*2+1)*@head.rate
                next
            else
                self.open!(true)
                visited = [@head]
            end
        end
        until @time_remaining == 0
            self.step()
        end
        self.report()
    end

    def potential!
        @potential = 0
        @pipes.each_value do |pipe|
            if distance(pipe) + 1 >= @time_remaining
                next
            end
            @potential += value(pipe)
        end
        @potential + @earned
    end

    def report
        puts "Time Remaining: #{@time_remaining}"
        puts "Total Earned: #{@earned}"
        puts "Total Potential: #{potential!}"
    end

    def open!(loud = false)
        unless @head.open? || @time_remaining < 1
            self.step()
            @head.open!()
            puts "#{@head.name} open" if loud
            @earned += @head.rate * @time_remaining
        end
        # self.report if loud
    end

    def inspect 
        "#{self.class} #{self.name}"
    end

    def to_s
        inspect()
    end

    def step(next_node_name = nil)
        if next_node_name
            distance = distance(@head, @pipes[next_node_name])
            distance.times do 
                @time_remaining -= 1
                @pipes.each_value {|pipe| pipe.step()}
            end
            @head = @pipes[next_node_name]
        else
            @time_remaining -= 1
            @pipes.each_value {|pipe| pipe.step()}
        end
    end
    
    def distance(node_1, node_2 = @head)
        if node_1.class == String
            node_1 = @pipes[node_1]
        end
        if node_2.class == String
            node_2 = @pipes[node_2]
        end
        on_deck = Set.new([node_1])
        visited = Set.new
        counter = 0
        running = true

        if node_1 == node_2
            return 0
        end

        while running
            holder = []
            counter += 1
            for node in on_deck
                visited.add(node)
                on_deck.delete(node)
                for child in node.outs
                    if !visited.include?(child)
                        if child == node_2
                            running = false;
                        end
                        holder.push(child)
                    end
                end
            end
            for child in holder
                on_deck.add(child)
            end
        end
        # puts "Found #{target_node.name} in #{counter} steps."
        return counter
    end

    '''The choose_target algorithm will pick a node based on the potential after stepping to the node and opening it. However the node EE has more potential than HH only because it is closer... Shouldnt opening the node and recalculating potential account for this? 
    
    If not, we can imagine opening the node as -1RU and compare that to the -(2d+1)RU of moving away and opening an alternate node

    We can further optimize by only checking nodes to which we have moved closer after choosing the target. This may need to be solved recursively.
    '''

    def value(time_remaining = @time_remaining, source_node = @head, target_node)
        if target_node.class == String
            target_node = @pipes[target_node]
        end
        return 0 if target_node.open?
        distance = self.distance(source_node, target_node)
        elapsed_time = distance + 1
        return (time_remaining - elapsed_time) * target_node.rate
    end

    def choose_target(visited = [])
        holder = Hash.new
        @pipes.each_value do |pipe|
            next if @head == pipe || pipe.open? || visited.include?(pipe)
            temp = PipeGraph.new(@file_name, @head.name, self)
            temp.step(pipe.name)
            temp.open!
            holder[pipe.name] = temp.potential!
        end

        result = holder.to_a.sort_by{|key, value| value}[-1][0]
        # debugger if result == "EE"
        debugger
        return result
    end
end

class Pipe < PipeGraph
    attr_reader :open, :name, :outs, :released, :rate
    def initialize(name, rate, graph)
        @name = name
        @rate = rate
        @released = 0
        @open = false
        @outs = []
        @graph = graph
        graph.pipes[name] = self
    end

    def open?
        @open
    end

    def step()
        if @open
            @released += @rate
            @graph.total_released += @rate
        end
    end

    def open!()
        unless @open
            @open = true
            @graph.total_rate += @rate
        end
    end

end

# puts
# puts "TEST"
# a = PipeGraph.new("dummy.txt", "AA")
# a.run
puts

puts "PUZZLE"
a = PipeGraph.new("data.txt", "NQ")
a.run
puts