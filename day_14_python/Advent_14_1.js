"use strict"

const fs = require('fs');

let file_data;

fs.readFile('data.txt', 'utf8', (err, data) => {
    if(err) throw err;
    file_data = data.split("\r\n");
    

    console.log(file_data.length)

    file_data = file_data.map((line) => {
        return line.split(" -> ").map((ele) => JSON.parse("["+ele+"]"))
    })

    const walls = Set()

    file_data.forEach((line) => {
        let i = 0

        while(line[i+1]){
            let pos = line[i]
            walls.add(pos)


            let idx = line[i][0] == line[i+1][0] ? 1 : 0;

            if(line[i][idx] > line[i+1][idx]){
                for(let c = line[i][idx]; c >= line[i+1][idx]; c--){
                    
                }
            } else {

            }
        }



    })
});