
def rps(str)
    score = 0
    moves = str.split(" ")
    score += 1 if moves[1] == "X"
    score += 2 if moves[1] == "Y"
    score += 3 if moves[1] == "Z"
    
    if moves[0] == "A"
        if moves[1] == "X"
            score += 3
        elsif moves[1] == "Y"
            score += 6
        else
            score += 0
        end
    end
    
    if moves[0] == "B"
        if moves[1] == "X"
            score += 0
        elsif moves[1] == "Y"
            score += 3
        else
            score += 6
        end
    end

    if moves[0] == "C"
        if moves[1] == "X"
            score += 6
        elsif moves[1] == "Y"
            score += 0
        else
            score += 3
        end
    end

    return score   
    
end

file = File.open("data.txt")

file_data = file.read

file_data = file_data.split("\r\n")

scores = file_data.map{|ele| rps(ele)}

print scores.sum


