const fs = require('fs');

const todos = JSON.parse(
    fs.readFileSync(`./dev-data/data/todosData.json`)
);

exports.checkId = (req, res, next) => {
    if (req.params.id > todos.length)
    {
        res.status(404).json({
            status: "error",
            message: "id not found :("
        })
    }
}

exports.getAlltodos = ((req, res) => {
    res.status(200).json( {
        status: "success",
        data: {
            todos
        }
    })
})

exports.createTodo = ((req, res) => {
    const newId = todos[todos.length - 1].id + 1;
    const newtodo = Object.assign({id: newId}, req.body);
    
    todos.push(newtodo);
    fs.writeFile(`./dev-data/data/todosData.json`, JSON.stringify(todos), err => {
        res.status(201).json({
            status: "success",
            data: {
                todo: newtodo
            }
        })
    })
})

exports.getTodo = ((req, res) => {
    const id = req.params.id * 1;
    const todo = todos.find(el => el.id === id);

    res.status(200).json( {
        status: "success",
        data: {
            todo
        }
    })
})

exports.updateTodo = ((req, res) => {
    const id = req.params.id * 1;
    const todo = todos.find(el => el.id === id);
    const updatedTodo = Object.assign(todo, req.body);

    fs.writeFile('./dev-data/data/todosData.json', JSON.stringify(todos), err => {
        res.status(200).json({
            status: "success",
            data: {
                todo: updatedTodo
            }
        })
    })
})

exports.deleteTodo = ((req, res) => {
    const id = req.params.id * 1;
    const todo = todos.findIndex(el => el.id === id);

    todos.splice(todo, 1);
    fs.writeFile('./dev-data/data/todosData.json', JSON.stringify(todos), err => {
        res.status(200).json({
            status: "success",
            data: {
                todos
            }
        })
    })
})