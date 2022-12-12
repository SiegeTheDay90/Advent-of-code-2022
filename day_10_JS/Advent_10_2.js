"use strict"

const fs = require('fs');

let file_data;

fs.readFile('data.txt', 'utf8', (err, data) => {
    if(err) throw err;
    file_data = data.split("\n");
    let cycle = 0
    let x = 2
    let screen_rows = ["Start","","","","","","","End"]
    let screen_row_index = 0
    let reading = true
    let index = 0
    let processing = false

    while(reading){
        cycle += 1
        console.log("Cycle: ", cycle)
        if(cycle%40 == 1){
            screen_row_index += 1
        }

        if([x-1, x, x+1].includes(cycle%40)){
            screen_rows[screen_row_index] += "#"
        }else{
            screen_rows[screen_row_index] += "."
        }
        
        let line = file_data[index]
        if(!line){
            console.log(screen_rows)
            return
        }
        console.log("Command: ", line)
        console.log("X: ", x)
        console.log()
        if(line[0] == "n"){
            index += 1
            continue
        } else if(line[0] == "a" && processing){
            processing = false
            x += parseInt(line.split(" ")[1])
            index += 1
        } else if(line[0] == "a" && !processing){
            console.log(x)
            processing = true
        }
        if(!file_data[index]){
            reading = false
        }
        console.log(screen_rows[screen_row_index])

    }

    

})