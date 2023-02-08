require "set"
class PipeGraph
    attr_accessor :head
    @@total_released = 0
    @@pipes = Hash.new()
    @@time_remaining = 30

    def pipes
        @@pipes
    end

    def initialize(file_name, head)
        file = File.open(file_name)

        file_data = file.read()

        file_data = file_data.split("\r\n")

        file_data.each do |line|
            name = line.split(" ")[1]
            rate = line.split(" ")[4][5..-1].to_i
            Pipe.new(name, rate)
        end

        file_data.each do |line|
            name = line.split(" ")[1]
            raw_outs = line.split(" ")[9..-1]
            p line
            p raw_outs
            for out in raw_outs
                @@pipes[name].outs << @@pipes[out.slice(0, 2)]
            end
        end

        @head = @@pipes[head]
    end

    def open()
        @head.open!() unless @head.open?
    end


    def self.step()
        @@time_remaining -= 1
        @@pipes.each {|pipe| pipe.step()}
    end
end

class Pipe < PipeGraph
    attr_reader :open, :name, :outs, :released, :rate
    def initialize(name, rate)
        @name = name
        @rate = rate
        @released = 0
        @open = false
        @outs = []
        @@pipes[name] = self
    end

    def open?
        @open
    end

    def distance(target_node)
        on_deck = Set.new([self])
        visited = Set.new
        counter = 0
        running = true

        if target_node == self
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
                        if child == target_node
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
        puts "Found #{target_node.name} in #{counter} steps."
        return counter
    end

    def value(target_node)
        if target_node.open?
            return 0
        else
            return (@@time_remaining - self.distance(target_node)-1) * target_node.rate
        end
    end

    def step()
        if @open
            @released += @rate
            @@total_released += @rate
        end
    end

    # def value(target_node)
    #     return time_remaining * @rate
    # end

    def open!()
        @open = true
    end

end

graph = PipeGraph.new("dummy.txt", "AA")