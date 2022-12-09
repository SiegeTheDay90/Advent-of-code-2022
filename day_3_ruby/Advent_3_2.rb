

file = File.open("data.txt")

file_data = file.read

file_data = file_data.split("\r\n")

priorities = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

total = 0

counter = -3;

file_data.each_with_index do |line, idx|

    next unless idx % 3 == 0

    line.each_char do |char|
        if file_data[idx+1].include?(char) && file_data[idx+2].include?(char)
            priority = priorities.index(char)
            total += priority
            break
        end
    end
    
end
    



p total


