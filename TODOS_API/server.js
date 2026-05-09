const dotenv = require('dotenv');
const mongoose = require('mongoose');
const app = require('./app');

dotenv.config({path: './config.env'});

const DB = process.env.DATABASE.replace('<PASSWORD>',process.env.DATABASE_PASSWORD);

mongoose.connect(DB).then(() => {
    console.log('Connection successful');
})

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

const todo = mongoose.model('todo', todosSchema);

const testTodo = new todo({
    title: 'Testing mongodb',
    completed: true,
    priority: 'high'
});

testTodo.save().catch(err => {
    console.log('ERROR: ', err);
});

const port = process.env.PORT;

app.listen(port, () => {
    console.log(`starting server on port ${port}`);
})
