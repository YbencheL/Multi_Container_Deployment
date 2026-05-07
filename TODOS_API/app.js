const express = require('express');
const morgan = require('morgan');
const todosRouter = require('./routes/todosRouter');

const app = express();

app.use(morgan('dev'));
app.use(express.json());

app.use('/todos', todosRouter);
app.use('/todos/:id', todosRouter);

module.exports = app;