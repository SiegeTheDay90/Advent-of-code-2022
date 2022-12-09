require 'debug'

file = File.open("data.txt")

file_data = file.read

file_data = file_data.split("\r\n\r\n")

file_data = file_data.map do |ele| 
    split = ele.split("\r\n")
end

file_data = file_data[0]

class DirNode

    attr_reader :name, :path, :size, :parent, :total_size, :directory_nodes, :file_names, :directory_names

    def initialize(name, data, depth = 0, parent = false, debug = false)
        @name = name
        @data = data
        @depth = depth
        @parent = parent
        @debug = debug

        @directory_names = []
        @directory_nodes = {}
        @file_names = {}
        @size = 0
        @total_size = 0

        @path = parent ? parent.path + name + "/" : name

        reading = false
        line_count = 0

        debugger

        @data.each do |line|
            # puts line if @debug
            breakpoint = false
            if line == "$ cd "+name
                reading = true
                line_count += 1
                next
            end

            if reading
                if line[0] == "d"
                    @directory_names.push(line.split(" ")[1..-1].join(" "))
                
                elsif "0123456789".include?(line[0])
                    parts = line.split(" ")
                    size = parts[0].to_i
                    name = parts[1..-1].join(" ")
                    @file_names[name] = size
                    @size += size
                    @total_size += size

                elsif line[0..3] == "$ cd" && line != "$ cd .."
                    breakpoint = true
                end
            end

            break if breakpoint
            line_count += 1
        end


        @directory_names.each do |dir|
            @directory_nodes[dir] = DirNode.new(dir, data, depth + 1, self, debug)
        end

        @directory_nodes.each do |k, v|
            @total_size += v.total_size
        end

        if @debug && @total_size <= 100000
            print "#{@path} "
            print "#{@total_size} "
            print "\n"
            puts
        end

        def find_by_size(size = 100000)
            holder = []

            if @total_size <= size
                holder.push(@total_size)
            end

            @directory_nodes.each do |k, v|
                holder += v.find_by_size()
            end

            return holder
        end

    end

end

root = DirNode.new("/", file_data, 0, nil, true)

puts root.find_by_size().sum()


