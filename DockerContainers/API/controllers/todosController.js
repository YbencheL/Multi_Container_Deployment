const todoModule = require('../models/todosModel')

exports.getAlltodos = async(req, res) => {

    try {
        const todos = await todoModule.find();

        res.status(200).json( {
            status: "success",
            data: {
                todos
            }
        })
    } catch (err) {
        res.status(500).json({
            status: 'fail',
            message: err.message
        })
    }
};

exports.createTodo = async (req, res) => {
    try {
        const newtodo = await todoModule.create(req.body);
        
        if (!newtodo)
        {
            return res.status(404).json({
                status: "failed",
                message: 'data is empty'
            })
        }
        res.status(201).json({
            status: "success",
            data: {
                todo: newtodo
            }
        })
    } catch (err) {
        res.status(400).json({
            status: 'fail',
            message: err.message
        })
    }

}

exports.getTodo = async (req, res) => {

    try {
        const todo = await todoModule.findById(req.params.id);
        
        if (!todo)
        {
            return res.status(404).json({
                status: 'failed',
                message: 'id not found'
            })
        }
        res.status(200).json( {
            status: "success",
            data: {
                todo
            }
        })  
    } catch (err) {
        const statusCode = err.name === "CastError" ? 400 :
            err.name === "ValidationError" ? 400 : 500;
        res.status(statusCode).json({
            status: 'fail',
            message: err.message
        })
    }

}

exports.updateTodo = async (req, res) => {
    try {
        const updatedTodo = await todoModule.findByIdAndUpdate(req.params.id,
            req.body, {
            new: true,
            runValidators: true
        });
        if (!updatedTodo)
        {
            return res.status(404).json({
                status: "failed",
                message: 'id not found'
            })
        }
        res.status(200).json({
            status: "success",
            data: {
                todo: updatedTodo
            }
        })
    } catch (err) {
        const statusCode = err.name === "CastError" ? 400 :
            err.name === "ValidationError" ? 400 : 500;
        res.status(statusCode).json({
            status: 'fail',
            message: err.message
        })
    }
}

exports.deleteTodo = async (req, res) => {

    try {
        const todo = await todoModule.findByIdAndDelete(req.params.id);
        if (!todo)
        {
            return res.status(404).json({
                status: "failed",
                message: 'id not found'
            })
        }
        res.status(200).json({
            status: "success",
            data: {
                todo: null
            }
        })
        res.status(204);
    } catch (err) {
        const statusCode = err.name === "CastError" ? 400 :
            err.name === "ValidationError" ? 400 : 500;
        res.status(statusCode).json({
            status: 'fail',
            message: err.message
        })
    }

}