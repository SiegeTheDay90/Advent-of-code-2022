file = File.open("data.txt")

file_data = file.read

file_data = file_data.split("\r\n\r\n")

file_data = file_data.map do |ele| 
    split = ele.split("\r\n")
    split.map {|ele| ele.to_i}
end

sums = file_data.map {|ele| ele.sum}

# max = file_data.max {|ele| ele.sum}

# p file_data
# p sums.count
first = sums.delete(sums.max)
second  = sums.delete(sums.max)
third = sums.delete(sums.max)

p first + second + third
# split_data = file_data.split("\n\n")

# elves = split_data.map do |elve|
#     elve.split("\n")
# end

# print elves