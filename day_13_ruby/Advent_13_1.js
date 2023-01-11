"use strict"

function main(){

    const fs = require('fs');



    let file_data;

    // fs.readFile('data.txt', 'utf8', (err, data) => {
    // fs.readFile('dummy.txt', 'utf8', (err, data) => {
    // fs.readFile('small.txt', 'utf8', (err, data) => {
    fs.readFile('sorted.txt', 'utf8', (err, data) => {
        if(err) throw err;

        // file_data = data.split("\n");
        file_data = data.split("\r\n");
        console.log(`\nParsing ${file_data.length} lines.\n`);
        
        file_data = file_data.filter(line => line);
        console.log(`\nParsing ${file_data.length/2} pairs.\n`);
        
        function correct_order(current_pair){
            let left = current_pair[0]
            let right = current_pair[1]
            for(let i = 0; i < Math.max(left.length, right.length); i++){

                if(!left[i] && right[i]){
                    return true
                } else if (left[i] && !right[i]) {
                    return false
                }

                if(typeof(left[i]) == 'number' && typeof(right[i]) == 'number'){
                    if (left[i] < right[i]) {
                        return true
                        
                    } else  if(left[i] > right[i]) {
                        return false
                        
                    }
                } else if (
                    typeof(left[i]) == 'object' || typeof(right[i]) == 'object') {
                    const result = correct_order([
                        typeof(left[i]) == 'number' ? [left[i]] : left[i], 
                        typeof(right[i]) == 'number' ? [right[i]] : right[i]
                    ])

                    if(result == true || result == false){return result}

                }
            }
                
        }
    



        let line_number = 1;
        let total = 0;
        let current_pair = [];
       
        file_data.forEach((line) => {
            current_pair.push(JSON.parse(line));
            

            if(line_number % 2 == 0){
                
                let valid = correct_order(current_pair);

                console.log(`Reading pair ${line_number/2} as ${valid}`);

                if(valid){
                    total += line_number/2
                }
                current_pair = [];

            }
            
            line_number +=1;
        });

        console.log(total);
    })
}

main();