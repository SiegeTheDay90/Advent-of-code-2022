

file = File.open("data.txt")

file_data = file.read

file_data = file_data.split("\r\n")

priorities = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"


total = 0

file_data.each do |line|
    left = line[0...line.length/2]
    right = line[(line.length/2)..-1]
    p left +" "+ right

    left.each_char do |char|
        if right.include?(char)
            priority = priorities.index(char)
            p "#{char} is repeated with priority #{priority}"
            total += priority
            p "Total: #{total}"
            break
        end
    end
end

p total


