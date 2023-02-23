require "byebug"
require "set"
class PipeGraph
    attr_accessor :head, :total_released, :total_rate, :time_remaining, :pipes, :name, :visited
    def initialize(file_name, head, parent = nil, visited = nil)
        @parent = parent
        @visited = visited ? visited : []
        @total_released = 0
        @total_rate = 0
        @pipes = Hash.new()
        @time_remaining = parent ? parent.time_remaining : 30
        @name = "#{self.object_id}"
        @child_moves = []

        unless false
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
    end

    def build_move_tree

        queue = [self]

        until queue.empty?
            # puts queue.length
            state = queue.shift
            puts state.time_remaining
            if state.time_remaining > 0
                for neighbor in state.head.outs
                    if state.visited.count(neighbor.name) > 2
                        next
                    end
                    new_state = PipeGraph.new("dummy.txt", state.head.name, state, state.visited + [neighbor.name])
                    new_state.step(neighbor.name)
                    queue.push(new_state)
                end
                if !state.head.open? && state.head.rate > 0
                    new_state = PipeGraph.new("dummy.txt", state.head.name, state)
                    new_state.open()
                    queue.push(new_state)
                end
            end
        end
    end
    
    def report
        puts "Time Remaining: #{@time_remaining}"
        puts "Total Rate: #{@total_rate}"
        puts "Total Released: #{@total_released}"
    end

    def sim
        until @time_remaining == 0
            self.step(self.choose_target2)
            self.open() unless @head.open?
        end
        self.report()
    end

    def run
        while @pipes.any?{|key, pipe| !pipe.open? && pipe.rate > 0} && @time_remaining > 0
            original_time = @time_remaining
            target = @pipes[self.choose_target()]
            # puts "#{target.name} with rate #{target.rate}" if target
            # puts "No target" unless target
            # puts "Distance: #{@head.distance(target)}" if target

            if target && @head.distance(target) <= @time_remaining
                self.step(target.name)
                self.open()
            else
                self.step()
            end
            # puts "Time elapsed: #{original_time - @time_remaining}"
            # puts "Time Remaining after opening #{target.name}: #{@time_remaining}" if target
            # puts
        end

        while @time_remaining > 0
            self.step()
        end
        self.report()
    end

    def choose_target2
        candidates = []

        @pipes.to_a.each do |name, pipe|
            if pipe.rate == 0 || pipe.open? || @head.distance(pipe)+2 > @time_remaining
                next
            end

            candidates.push([@head.value(pipe), pipe])
        end
        candidates.sort_by!{|ele| -ele[0]}
        
        running = true

        while running
            running = false

            candidate = candidates.shift
            return nil unless candidate
            distance = @head.distance(candidate[1])
            time_elapsed = distance + 1

            candidates.each do |value, pipe|
                hypothetical_value = candidate[1].value(pipe, false, @time_remaining - time_elapsed)
                hypothetical_loss = value - hypothetical_value

                alternative_candidate_value = pipe.value(candidate[1], false, @time_remaining - @head.distance(pipe) - 1)
                alternative_candidate_loss = candidate[0] - alternative_candidate_value

                if alternative_candidate_loss < hypothetical_loss
                    running = true
                end
            end
        end
        return candidate[1].name
    end

    def choose_target

        holder = {}
        @pipes.values.reject{|pipe| @head == pipe || pipe.rate < 1 || pipe.open? || @head.distance(pipe)+2 > @time_remaining}.each do |pipe|
            holder[pipe.name] = self.delta(pipe)
        end

        

        values = holder.values.sort.reverse
        running = true
        # puts "CHECK THE HOLDER AND VALUES"
        # puts "THE VALUES ARE DELTAS, REPRESENT LOSS, LESS IS BETTER"
        queue = [@pipes[holder.key(values.shift)]]
        while queue[0] && running
            return nil unless values[0]
            candidate = queue.shift
            checked =[]

            pipes_to_check = @pipes.values.reject{|pipe| pipe == candidate || pipe.open? || pipe.rate < 1 || @head.distance(pipe)+1 > @time_remaining}.sort_by{|pipe| @head.value(pipe)}
            return candidate.name if pipes_to_check.empty?
            pipes_to_check.each do |pipe|
                running = false


                # if (candidate.distance(pipe)*2 + 1) * candidate.rate < pipe.rate
                #     running = true
                #     break
                # end

                if running
                    next
                end
                #Candidate JJ
                #Pipe BB

                original_value = @head.value(pipe)
                remaining = @time_remaining - @head.distance(candidate) - 1
                new_value = candidate.value(pipe, false, remaining)
                candidate_loss = original_value - new_value # If I move to candidate

                original_value = @head.value(candidate)
                remaining = @time_remaining - @head.distance(pipe) - 1
                new_value = pipe.value(candidate, false, remaining)
                alt_loss = original_value - new_value #if I move to alt

                if alt_loss < candidate_loss
                    # return pipe.name if @head.distance(pipe)+1 < @time_remaining
                    queue.push(pipe) unless checked.include?(pipe)
                    checked.push(pipe)
                    running = true
                    break
                end
            end
        end
        return candidate ? candidate.name : nil
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
            if pipe == target_node || pipe.open? || pipe.rate == 0
                next
            end
            new_total += target_node.value(pipe, false, remaining)
        end

        delta = total - new_total
        # if !target_node.open?
        #     self_value = remaining * target_node.rate
        # else
        #     self_value = 0.0
        # end
        
        return delta
        # return ((self_value + 0.0)/delta)

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
            puts "#{@head.name} open"
        end
    end

    def inspect
        return "#{self.class} #{self.name}"
    end

    def step(next_node_name = nil)
        if next_node_name
            distance = @head.distance(@pipes[next_node_name])
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

    def open!(loud = false)
        unless @open
            @open = true
            puts "#{@name} open" if loud
            @graph.total_rate += @rate
        end
    end

end

# puts
# puts "TEST"
# a = PipeGraph.new("dummy.txt", "AA")
# a.run
puts



puts "TEST Run"
a = PipeGraph.new("dummy.txt", "AA")
a.run
puts

puts "TEST Sim"
a = PipeGraph.new("dummy.txt", "AA")
a.sim
puts

# puts "PUZZLE Run"
# a = PipeGraph.new("data.txt", "NQ")
# a.run
# puts

puts "PUZZLE Sim"
a = PipeGraph.new("data.txt", "AA")
a.sim
puts