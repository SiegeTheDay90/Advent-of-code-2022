require 'debug'

file = File.open("data.txt")

file_data = file.read

file_data = file_data.split("\r\n\r\n")

file_data = file_data.map do |ele| 
    split = ele.split("\r\n")
end

file_data = file_data[0]



directory = Hash.new(Hash.new())

head = directory['Root']
head['parent'] = false
head['path'] = ''
head['has_child'] = true
head['children'] = []


file_data.each do |line|
    if line[0..3] == "$ cd" && line != "$ cd .."
        parent = head
        parent['has_child'] = true
        head[line[5..-1]] = Hash.new(Hash.new())
        head = head[line[5..-1]]
        parent['children'] += [head]
        head['name'] = line[5..-1]
        head['parent'] = parent
        head['path'] = parent['path'] + head['name'] +"/"
        # puts head['path']
        head['size'] = 0
        head['has_child'] = false
        head['children'] = []
    
    elsif line == "$ cd .."
        size = head['size']
        head = head['parent']
        head['size'] += size
        # puts head['size']
    elsif line == "$ ls"
        next
    elsif "0123456789".include?(line[0])
        parts = line.split(" ")
        size = parts[0].to_i
        name = parts[1]
        head['files'][name] = size
        head['size'] += size
    end
end

while head['parent']['parent']
    size = head['size']
    head = head['parent']
    head['size'] += size
end

def find_by_size(head, size = 100000)
    holder = []
    if head['size'] <= size
        holder.push(head['size'])
    end

    if head['has_child']
        for child in head['children'] do
            holder += find_by_size(child)
        end
    end
    return holder
end
puts head['name']
# puts find_by_size(head) 
needed_space = 30000000 - (70000000 - head['size'])
puts "Needs #{needed_space}"

def find_closest_size(head, size=4376732)
    holder = []
    if head['size'] >= size
        holder.push(head['size'])
    end

    if head['has_child']
        for child in head['children'] do
            holder += find_closest_size(child, size)
        end
    end
    return holder
end

puts find_closest_size(head).min()
# puts head['size']
