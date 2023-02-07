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

    def self.step()
        @@time_remaining -= 1
        @@pipes.each {|pipe| pipe.step()}
    end
end

class Pipe < PipeGraph
    attr_reader :open, :name, :outs, :released
    def initialize(name, rate)
        @name = name
        @rate = rate
        @released = 0
        @open = false
        @outs = []
        @@pipes[name] = self
    end

    def step()
        if @open
            @released += @rate
            @@total_released += @rate
            @value = @@time_remaining * @rate
        end
    end

    def value(time_remaining = @@time_remaining)
        return time_remaining * @rate
    end

    def open!()
        @open = true
    end

end

graph = PipeGraph.new("dummy.txt", "AA")