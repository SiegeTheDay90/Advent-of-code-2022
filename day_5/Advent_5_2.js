"use strict"

const fs = require('fs');

let file_data;

const moveCrates = (times, from, to, stacks) => {
    const holder = [];

    for(let i = 0; i < times; i++){
        holder.unshift(stacks[from-1].pop());
    }

    stacks[to-1].push(...holder);

    return stacks;

}

fs.readFile('data.txt', 'utf8', (err, data) => {
    if(err) throw err;
    file_data = data.split("\r\n\r\n");
    let crates = file_data[0];
    let moves = file_data[1];
    
    const rows = crates.split("\r\n");
    const stacks = [[], [], [], [], [], [], [], [], []];
    
    rows.forEach((row) => {
        for(let column = 1; column <= 9; column++){
            if(row[(column-1)*4] === "["){
                stacks[column-1].unshift(row[(column-1)*4+1])
            }
        }
    })
    moves = moves.split("\r\n");

    moves.forEach((move) => {
        const parts = move.split(" ");

        moveCrates(parseInt(parts[1]), parseInt(parts[3]), parseInt(parts[5]), stacks)
    })

    let str = "";


    stacks.forEach((stack)=>{
        str += stack[stack.length - 1]
    })

    console.log(str);
    
});


