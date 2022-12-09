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
            trees[[x, y]] = {size: parseInt(tree), visible: false, score: 0}
        })
    })

    trees.width = file_data[0].length
    trees.height = file_data.length

    let top_score = 0
        
    for(let y = 1; y < 98; y++){
        for(let x = 1; x < 98; x++){
            let tree = trees[[x,y]]
            const score = scenicScore(x, y, trees)
            if(score > top_score){
                top_score = score
            }            
        }

    }

    console.log(top_score)

});

const scenicScore = (arg_x, arg_y, forest) => {
    console.log("Reading forest ", arg_x, ", ",arg_y)
    const tree = forest[[arg_x, arg_y]]
    let score_right = 0
    for(let x=arg_x+1; x < forest.width; x++){
        if(forest[[x, arg_y]].size < tree.size){
            score_right += 1
        } else {
            score_right += 1
            break
        }
    }
    let score_left = 0
    for(let x=arg_x-1; x >= 0 ; x--){
        if(forest[[x, arg_y]].size < tree.size){
            score_left += 1
        } else {
            score_left += 1
            break
        }
    }
    let score_down = 0
    for(let y=arg_y-1; y >= 0 ; y--){
        if(forest[[arg_x, y]].size < tree.size){
            score_down += 1
        } else {
            score_down += 1
            break
        }
    }
    let score_up = 0
    for(let y=arg_y+1; y < forest.height ; y++){
        if(forest[[arg_x, y]].size < tree.size){
            score_up += 1
        } else {
            score_up += 1
            break
        }
    }
    console.log(score_right * score_left * score_up * score_down)
    return score_right * score_left * score_up * score_down
}


