"use strict"

const fs = require('fs');

let file_data;

fs.readFile('data.txt', 'utf8', (err, data) => {
    if(err) throw err;
    file_data = data.split("\n");
    file_data = file_data.filter(line => !!line)

    console.log(file_data.length);
    
    // file_data.forEach((row) => {
        

    // });
})
    