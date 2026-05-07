const express = require('express');
const todosController = require('./../controllers/todosController');

const router = express.Router();

router.param('id', todosController.checkId);

router.route('/')
     .get(todosController.getAlltodos)
     .post(todosController.createTodo);

router.route('/:id')
     .get(todosController.getTodo)
     .put(todosController.updateTodo)
     .delete(todosController.deleteTodo);

module.exports = router;