require 'set'
require 'debug'
# file = File.open("dummy.txt")
file = File.open("data.txt")

file_data = file.read

file_data = file_data.split("\r\n")

alphabet = "abcdefghijklmnopqrstuvwxyz"

converted_data = {}
starting_points = []
file_data.each_with_index do |line, y|
    # puts line

    line.each_char.with_index do |char, x|
        converted_data[[x,y]] = {char: char, height: alphabet.index(char), up: nil, left: nil, right: nil, down: nil}
        if char == "S"
            converted_data[[x,y]][:height] = 0
        elsif char == "E"
            converted_data[[x,y]][:height] = 25
        end

        if ["S", "a"].include?(char)
            starting_points.push([x, y])
        end
            
    end
end

puts

for y in (0...file_data.length)
    for x in (0...file_data[0].length)
        converted_data[[x, y]][:up] = converted_data[[x, y+1]]
        converted_data[[x, y]][:down] = converted_data[[x, y-1]]
        converted_data[[x, y]][:right] = converted_data[[x+1, y]]
        converted_data[[x, y]][:left] = converted_data[[x-1, y]]

    end
end

player = [0, 0, 0]
target = [1, 1, 25]

file_data.each_with_index do |line, index|
    if line.include?("S")
        player[1] = index
        player[0] = line.index("S")
    end

    if line.include?("E")
        target[1] = index
        target[0] = line.index("E")
    end
end



lengths = []
for start in starting_points
    puts "Starting with #{start}"
    open_set = Set.new()
    closed_set = Set.new()
    open_set.add(converted_data[start])
    running = true
    counter = 0
    while running
        holder = []
        counter += 1
        running = false if counter >= 500
        for pos in open_set
    
            closed_set.add(pos)
            open_set.delete(pos)
    
            for dir in [:up, :down, :left, :right]
                if pos[dir] && pos[:height] + 1 >= pos[dir][:height] && !closed_set.include?(pos[dir])
                    if pos[dir][:char] == "E"
                        puts "Found one after #{counter}"
                        puts
                        # puts open_set.length
                        # puts closed_set.length
                        lengths.push(counter)
                        running = false
                    end 
                    holder.push(pos[dir])
                end
            end
        end
        open_set.merge(holder)
    end
end

puts lengths.min






