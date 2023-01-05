require 'set'
require 'debug'
file = File.open("data.txt")

file_data = file.read

file_data = file_data.split("\r\n")

alphabet = "abcdefghijklmnopqrstuvwxyz"

converted_data = {}

file_data.each_with_index do |line, y|
    # puts line

    line.each_char.with_index do |char, x|
        converted_data[[x,y]] = {char: char, height: alphabet.index(char), up: nil, left: nil, right: nil, down: nil}
        if char == "S"
            converted_data[[x,y]][:height] = 0
        elsif char == "E"
            converted_data[[x,y]][:height] = 25
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



open_set = Set.new()
closed_set = Set.new()

open_set.add(converted_data[[player[0], player[1]]])
running = true
counter = 0
while running
    holder = []
    counter += 1
    for pos in open_set

        closed_set.add(pos)
        open_set.delete(pos)

        for dir in [:up, :down, :left, :right]
            if pos[dir] && pos[:height] + 1 >= pos[dir][:height] && !closed_set.include?(pos[dir])
                if pos[dir][:char] == "E"
                    print "That's that one!\n"
                    puts open_set.length
                    puts closed_set.length
                    puts counter
                    running = false
                end 
                holder.push(pos[dir])
            end
        end
    end

    open_set.merge(holder)
end





