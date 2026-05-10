const mongoose = require('mongoose');

const todosSchema = new mongoose.Schema({
    title: {
        type: String,
        required: [true, 'A title must be set'],
        unique: true
    },
    description: {
        type: String
    },
    priority: {
        type: String,
        default: 'medium'
    },
    completed: {
        type: Boolean,
        default: false
    }
});

const todoModule = mongoose.model('todo', todosSchema);

module.exports = todoModule;