"use strict"

const fs = require('fs');

let file_data;

fs.readFile('data.txt', 'utf8', (err, data) => {
    if(err) throw err;
    file_data = data.split("\n");
    let cycle = 1
    let x = 1
    let signal_strength = 0

    file_data.forEach((row) => {
        if(cycle%20 == 0 && cycle%40 != 0){
            signal_strength += x * cycle
        }
        let split = row.split(" ")
        if(split[0] == "noop"){
            cycle += 1
        } else {
            cycle += 1
            if(cycle%20 == 0 && cycle%40 != 0){
                signal_strength += x * cycle
            }
            cycle += 1
            x += parseInt(split[1])
        }
    })
    
    console.log(cycle)
    console.log(x)
    console.log(signal_strength)
});