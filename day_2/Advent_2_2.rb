
def rps(str)
    score = 0
    moves = str.split(" ")
    score += 0 if moves[1] == "X"
    score += 3 if moves[1] == "Y"
    score += 6 if moves[1] == "Z"
    
    if moves[0] == "A"
        if moves[1] == "X"
            score += 3
        elsif moves[1] == "Y"
            score += 1
        else
            score += 2
        end
    end
    
    if moves[0] == "B"
        if moves[1] == "X"
            score += 1
        elsif moves[1] == "Y"
            score += 2
        else
            score += 3
        end
    end

    if moves[0] == "C"
        if moves[1] == "X"
            score += 2
        elsif moves[1] == "Y"
            score += 3
        else
            score += 1
        end
    end

    return score   
    
end

file = File.open("data.txt")

file_data = file.read

file_data = file_data.split("\r\n")

scores = file_data.map{|ele| rps(ele)}

print scores.sum


