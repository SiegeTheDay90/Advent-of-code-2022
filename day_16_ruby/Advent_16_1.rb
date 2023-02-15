require "byebug"
require "set"
class PipeGraph
    attr_accessor :head, :total_released, :total_rate, :time_remaining, :order, :pipes, :name, :order
    
    def initialize(file_name, head)
        @total_released = 0
        @total_rate = 0
        @pipes = Hash.new()
        @time_remaining = 30
        @order = []
        @name = "#{self.object_id}"
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
            # p line
            # p raw_outs
            for out in raw_outs
                @pipes[name].outs << @pipes[out.slice(0, 2)]
            end
        end

        @head = @pipes[head]
    end
    
    def report
        puts "Time Remaining: #{@time_remaining}"
        puts "Total Rate: #{@total_rate}"
        puts "Total Released: #{@total_released}"
        # print "Order: #{@order}"
    end

    def run
        while @pipes.any?{|key, pipe| !pipe.open? && pipe.rate > 0} && @time_remaining > 0
            target = @pipes[self.choose_target()]

            if target
                @head.distance(target).times do
                    self.step(target.name)
                end
                self.open()
            else
                self.step()
            end
        end

        while @time_remaining > 0
            self.step()
        end
        self.report()
    end

    def choose_target


        holder = {}
        @pipes.each_value do |pipe|
            holder[pipe.name] = self.delta(pipe) unless @head == pipe || pipe.rate < 1 || pipe.open? || @head.distance(pipe)+1 > @time_remaining
        end

        

        values = holder.values.sort
        running = true

        while running
            return nil unless values[0]
            candidate = @pipes[holder.key(values.shift)]

            @pipes.values.reject{|pipe| pipe == candidate || pipe.open?}.each do |pipe|
                running = false
                if (candidate.distance(pipe)*2 + 1) * candidate.rate < pipe.rate
                    running = true
                    break
                end
            end
        end
        return candidate.name
    end
    
    def delta(target_node)
        total = 0
        @pipes.each_value do |pipe|
            if pipe == target_node
                next
            end
            total += @head.value(pipe) unless pipe.open?
        end

        new_total = 0
        remaining = @time_remaining - @head.distance(target_node) - 1

        @pipes.each_value do |pipe|
            if pipe == target_node
                next
            end
            new_total += target_node.value(pipe, false, remaining) unless pipe.open?
        end

        delta = total - new_total

        if !@head.open?
            self_value = remaining * target_node.rate
        else
            self_value = 0
        end

        return delta - self_value

        # if self_value - delta < 0
        #     return Float::INFINITY
        # else
        #     return delta
        # end

    end

    def value(target_node)
        distance = @head.distance(target_node)
        elapsed = distance + 1
        # @pipes.each_value do |pipe|
        #     puts "#{pipe.name} #{target_node.value(pipe, true, @time_remaining - elapsed)}"
        # end
        if target_node.rate > 0 && !target_node.open?
            values = @pipes.values.map{|pipe| 
                target_node.value(pipe, true, @time_remaining - elapsed)
            }
            values << target_node.rate * (@time_remaining - elapsed)
        else
            values = [0]
        end

        puts "Total of #{target_node.name}: #{values.sum}"
    end

    def open()
        unless @head.open? || @time_remaining < 1
            self.step()
            @head.open!()
            @order << "Open #{@head.name}"
        end
    end

    def inspect
        return "#{self.class} #{self.name}"
    end

    def step(next_node_name = nil)
        if @time_remaining < 1
            puts "Time Over"
            return
        end
        @time_remaining -= 1
        @pipes.each_value {|pipe| pipe.step()}
        if next_node_name
            @head = @pipes[next_node_name]
            @order << "Step to #{next_node_name}"
        end
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
        # puts "Found #{target_node.name} in #{counter} steps."
        return counter
    end

    def value(target_node, mock_open = false, time_remaining = @graph.time_remaining)
        if target_node.open? || target_node.rate == 0 || (mock_open && target_node == self)
            return 0
        else
            distance = self.distance(target_node)
            # rate_holder = @graph.total_rate + (mock_open ? self.rate : 0)
            return (time_remaining - distance-1) * target_node.rate #+ (distance+1) * rate_holder
            
        end
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

puts
puts "TEST"
a = PipeGraph.new("dummy.txt", "AA")
a.run
puts

puts "PUZZLE"
a = PipeGraph.new("data.txt", "NQ")
a.run
puts