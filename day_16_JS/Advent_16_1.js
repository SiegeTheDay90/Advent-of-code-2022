"use strict"

const fs = require('fs');

let file_data;
const file = "dummy.txt"
// const file = "data.txt"
fs.readFile(file, 'utf8', (err, data) => {
    if(err) throw err;
    file_data = data.split("\r\n")

    const pipes = {}

    for(let line = 0; line < file_data.length; line++){
        let name = file_data[line].split(" ")[1];
        let rate = parseInt(file_data[line].split(" ")[4].slice(5, -1));
        pipes[name] = new Pipe(name, rate)
    }
    for(let line = 0; line < file_data.length; line++){
        let name = file_data[line].split(" ")[1];
        let raw_outs = file_data[line].split(" ").slice(9)
        for(const out of raw_outs){
            pipes[name].outs.push(pipes[out.slice(0,2)])
        }
    }

    console.log(pipes['AA'])
});

class Pipe {
    constructor(name, rate){
        this.name = name;
        this.rate = rate;
        this.outs = [];
        this.is_open = false;
    }

    open(){
        this.is_open = true;
    }




}


// function DFS(head){
//     const start = head;
//     let total = 0;

//     for(const out in head.outs)
// }