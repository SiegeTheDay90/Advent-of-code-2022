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

    const trip = new Trip(pipes, "AA")

    print(pipes["AA"].traverse())

});

let pipecount = 0
class Pipe {
    constructor(name, rate){
        pipecount += 1
        this.id = pipecount
        this.name = name;
        this.rate = rate;
        this.outs = [];
        this.is_open = false;
        this.released = 0;
    }

    open(){
        this.is_open = true;
    }

    step(){
        if(this.is_open){this.released += this.rate}
    }

    traverse(visited=new Set(), step=1){
        const head = this
        let value = 0;
        let total_released = 0;
        let total_rate = 0;
        let steps = 0;
        
        if(visited.has(head.name)){
            print(`Already visited ${head.name}`)
            return 0;
        }
        visited.add(head.name)
        value += head.rate
        print(`Visit ${head.name} in ${step} steps -> ${value}`)
        
        for(const out of head.outs){
            // if(!visited.has(out.name)){
                // print(`${out.name} adds ${out.rate}`)
                value += out.traverse(visited, step + 1)
            // }
        }
        
        return value
    }
}

class Trip {
    constructor(graph, head){
        this.graph = graph
        this.head = graph[head]
        this.total_released = 0; 
        this.minutes = 0; 
        this.total_rate = 0;
        this.total_opened = 0; 
        this.tunnels_traveled = 0;
        this.nodes_visited = new Set()
    }

    step_to(node){
        this.head = node;
        this.minutes++;
        this.tunnels_traveled++;
        this.nodes_visited.add(this.head.name)
        this.total_released += this.total_rate
    }

    open_head(){
        if(this.head.is_open){return}
        this.head.open();
        this.total_rate += this.head.rate;
        this.minutes++;
        this.total_opened++;
    }

    distance_to(pipe){
        let distance = this.head.traverse("CC").distance

    }


}


function print(x){
    console.log(x)
}

// function DFS(head){
//     const start = head;
//     let total = 0;

//     for(const out in head.outs)
// }