require 'debug'
require 'json'
# file = File.open("dummy.txt")
file = File.open("data.txt")
# file = File.open("sorted.txt")

file_data = file.read

file_data = file_data.split("\n")

file_data = file_data.select{|line| line.strip != ""}

puts "Parsing #{file_data.length/2} pairs."

def correct_order(pair)
    left = pair[0]
    right = pair[1]

    length = [pair[0].length, pair[1].length].max

    return nil if length <= 0

    (0...length).each do |i|
        if !left[i] && right[i]
            return true
        elsif left[i] && !right[i]
            return false
        end

        if left[i].class == Integer && right[i].class == Integer
            if left[i] < right[i]
                return true
            elsif left[i] > right[i]
                return false
            end

        elsif left[i].class == Array || right[i].class == Array
            result = correct_order(
                [left[i].class == Integer ? [left[i]] : left[i],
                right[i].class == Integer ? [right[i]] : right[i]]
            )

            return result if [true, false].include?(result)

        else
            return nil
        end
    end
end

def swap(arr, idx_1, idx_2)
    arr[idx_1], arr[idx_2] = arr[idx_2], arr[idx_1]
end

def is_sorted?(arr)
    (0...arr.length-1).each do |i|
        return false unless correct_order([arr[i], arr[i+1]])
    end
    return true
end

line_number = 1
current_pair = []
parsed_data = []

file_data.each do |str|
    line = JSON.parse(str.strip)
    parsed_data.push(line)
end

parsed_data += [[2], [6]]


until is_sorted?(parsed_data)
    for i in (0...parsed_data.length-1)
        swap(parsed_data, i, i+1) unless correct_order([parsed_data[i], parsed_data[i+1]])
    end
end

puts (parsed_data.index([2])+1) * (parsed_data.index([6])+1)



# file_data.each_with_index do |line, y|
# end
# puts








