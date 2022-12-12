"use strict"

const fs = require('fs');

let file_data;

fs.readFile('data.txt', 'utf8', (err, data) => {
    if(err) throw err;
    file_data = data.split("\r\n");

    let trees = {}

    file_data.forEach((row, y) => {
        let split = row.split("")
        split.forEach((tree, x) => {
            trees[[x, y]] = {size: parseInt(tree), visible: false}
        })
    })

    let width = file_data[0].length
    let height = file_data.length

        
    for(let y = 1; y < 98; y++){
        let tallest_from_left = trees[[0, y]].size
        trees[[0, y]].visible = true
        for(let x = 1; x < 98; x++){
            if(trees[[x, y]].size > tallest_from_left){
                tallest_from_left = trees[[x, y]].size
                trees[[x, y]].visible = true
            } 
        }
    }
    for(let y = 1; y < 98; y++){
        let tallest_from_right = trees[[98, y]].size
        trees[[98, y]].visible = true
        for(let x = 97; x >= 0; x--){
            if(trees[[x, y]].size > tallest_from_right){
                tallest_from_right = trees[[x, y]].size
                trees[[x, y]].visible = true
            } 
        }
    }
    for(let x = 1; x < 98; x++){
        let tallest_from_left = trees[[x, 0]].size
        trees[[x, 0]].visible = true
        for(let y = 1; y < 98; y++){
            if(trees[[x, y]].size > tallest_from_left){
                tallest_from_left = trees[[x, y]].size
                trees[[x, y]].visible = true
            } 
        }
    }
    for(let x = 1; x < 98; x++){
        let tallest_from_right = trees[[x, 98]].size
        trees[[x, 98]].visible = true
        for(let y = 97; y >= 0; y--){
            if(trees[[x, y]].size > tallest_from_right){
                tallest_from_right = trees[[x, y]].size
                trees[[x, y]].visible = true
            } 
        }
    }

    let count = 4
    

    Object.values(trees).forEach((tree) => {
        if(tree.visible){
            count +=1
        }
    })

    console.log(count)
});


