require 'set'
require 'debug'
file = File.open("dummy.txt")

file_data = file.read

file_data = file_data.split("\r\n")

alphabet = "abcdefghijklmnopqrstuvwxyz"

converted_data = []

for line in file_data
    converted_line = []

    line.each_char do |char|
        converted_line.push(alphabet.index(char))
    end
    converted_data.push(converted_line)
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

open_set.add(player)

searching = true
cycle = 0

while searching
    debugger if cycle > 30000
    cycle += 1
    holder_set = Set.new()
    open_set.each do |tile|

        closed_set.add(tile)
        
        tile_height = tile[2]
        

        up_coordinate = [tile[0], tile[1]+1]
        down_coordinate = [tile[0], tile[1]-1]
        right_coordinate = [tile[0]+1, tile[1]]
        left_coordinate = [tile[0]-1, tile[1]]

        begin
            up_height = converted_data[up_coordinate[1]][up_coordinate[0]]
        rescue
            up_height = nil
        end
        begin
            right_height = converted_data[right_coordinate[1]][right_coordinate[0]]
        rescue
            right_height = nil
        end
        begin    
            down_height = converted_data[down_coordinate[1]][down_coordinate[0]]
        rescue
            down_height = nil
        end
        begin    
            left_height = converted_data[left_coordinate[1]][left_coordinate[0]]
        rescue
            left_height = nil
        end

        if up_height and [0, 1].include?(up_height - tile_height) and up_coordinate == [target[0], target[1]]
            holder_set.add(up_coordinate+[up_height])
            searching = false
        end
        if down_height and [0, 1].include?(down_height - tile_height) and down_coordinate == [target[0], target[1]]
            holder_set.add(down_coordinate+[down_height])
            searching = false
        end
        if right_height and [0, 1].include?(right_height - tile_height) and right_coordinate == [target[0], target[1]]
            holder_set.add(right_coordinate+[right_height])
            searching = false
        end
        if left_height and [0, 1].include?(left_height - tile_height) and left_coordinate == [target[0], target[1]]
            holder_set.add(left_coordinate+[left_height])
            searching = false
        end

        if up_height and [0, 1].include?(up_height - tile_height) and !closed_set.include?([up_coordinate]) and searching
            holder_set.add(up_coordinate+[up_height])
        end

        if down_height and [0, 1].include?(down_height - tile_height) and !closed_set.include?([down_coordinate]) and searching
            holder_set.add(down_coordinate+[down_height])
        end

        if right_height and [0, 1].include?(right_height - tile_height) and !closed_set.include?([right_coordinate]) and searching
            holder_set.add(right_coordinate+[right_height])
        end

        if left_height and [0, 1].include?(left_height - tile_height) and !closed_set.include?([left_coordinate]) and searching
            holder_set.add(left_coordinate+[left_height])
        end
    end

    open_set = holder_set
end

p player
puts
p target