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

    // print(trip.max_value(30))

    // print(pipes["DD"].total_value(pipes, 28))
    // pipes["DD"].open()
    // print(pipes["AA"].total_value(pipes, 26))
    // print(pipes["BB"].total_value(pipes, 25))
    pipes["AA"].next_node(pipes, 30)
    // pipes["DD"].open()
    // pipes["DD"].next_node(pipes, 28)
    // print(pipes["EE"].total_value(pipes, 26))
    print(pipes["DD"].value(pipes["EE"]), 28)
    
});

class Pipe {
    constructor(name, rate){
        this.name = name;
        this.rate = rate;
        this.outs = [];
        this.is_open = false;
        this.released = 0;
    }
    
    open(){
        this.is_open = true;
    }
    
    step(n=1){
        if(this.is_open){this.released += this.rate * n}
    }
    
    path(target, open=new Set([this]), closed=new Set()){
        let running = true;
        let counter = 0;
        if(target == this.name){
            return null
        }
        
        while(running){
            const holder = []
            counter += 1;
            for(const node of open){
                closed.add(node.name)
                open.delete(node)
                for(const child of node.outs){
                    if(!(child.name in closed)){
                        if(child.name == target){
                            running = false;
                        }
                        holder.push(child)
                    }
                }
            }
            
            for(const child of holder){
                open.add(child)
            }
        }
        // print(`Found ${target} in ${counter} steps.`)
        return counter
    }
    
    value(target_node, time_left=30){
        const distance = this.path(target_node.name)
        
        if(distance == null){
            return {name: target_node.name, distance: 0, value: target_node.rate * time_left, open: target_node.is_open}
        }
        let value = 0;
        if(!target_node.is_open){
            time_left -= distance + 1
            value += time_left * target_node.rate
        }
        
        return { name: target_node.name, distance: distance, value, open: target_node.is_open}
    }
    
    total_value(pipes, time_left=30){
        let sum = 0;
        for(const name of Object.keys(pipes)){
            if(!pipes[name].is_open){
                const result = pipes[this.name].value(pipes[name], time_left)
                sum += result.value
            }
        }
        return sum
    }
    
    next_node(pipes, time_left=30){
        let max = {pipe: null, value: -1};
        for(const name of Object.keys(pipes).filter((name) => name != this.name)){
            const distance = this.path(pipes[name].name)
            const result = pipes[name].total_value(pipes, time_left - distance-1)
            print(name, result)
            if(result > max.value && name != this.name && pipes[name].rate > 0 && !pipes[name].is_open){
                max = {pipe: pipes[name], value: result}
            } else {
                // print(name, result)
            }
        }
        return max
    }
}

class Trip {
    constructor(graph, head){
        this.graph = graph
        this.head = graph[head]
        this.total_released = 0; 
        this.total_rate = 0;
        this.total_opened = 0; 
    }
    
    max_value(time_left=30){
        while (time_left > 1){
            let next_node = this.head.next_node(this.graph, time_left).pipe
            print(this.head.name)
            print(this.head.is_open)
            let time_elapsed = this.head.path(next_node.name) + 1
            time_left -= time_elapsed
            this.total_released += this.total_rate * time_elapsed
            next_node.open()
            this.total_rate += next_node.rate
            this.total_opened += 1
            this.head = next_node
        }

        print(`Loop break with ${this.time_left} minutes left.`)
        return this.total_released
        
    }
    
    
}


function print(...x){
    console.log(...x)
}

