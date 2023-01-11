require 'debug'
require 'json'
# file = File.open("dummy.txt")
file = File.open("data.txt")

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

line_number = 1
total = 0
current_pair = []

file_data.each do |str|
    line = JSON.parse(str.strip)
    current_pair.push(line)

    if line_number % 2 == 0
        valid = correct_order(current_pair)
        # debugger if valid.class == Range
        puts valid
        if valid
            total += line_number/2
        end
        current_pair = []
    end

    line_number += 1
end

puts total



# file_data.each_with_index do |line, y|
# end
# puts








