import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/todo_model.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _preference;

  static Future init() async {
    _preference = await SharedPreferences.getInstance();
  }

  static const String _keyTodos = 'todos';

  //Create To Do

  static Future saveToDo(Todo todo) async {
    // get data from storage
    final List<String> todos = _preference?.getStringList(_keyTodos) ?? [];
    // converting list of string to JSON type
    final todoJson = json.encode(todo.toJson());
    // add converted JSON to our todos
    todos.add(todoJson);
    // save to our local storage
    await _preference?.setStringList(_keyTodos, todos);
  }

  // Read To dos or Get List of Todos
  static List<Todo> getTodos() {
    final List<String> todos = _preference?.getStringList(_keyTodos) ?? [];
    return todos.map((todo) {
      return Todo.fromJson(json.decode(todo));
    }).toList();
  }

  // Update To Do
  static Future updateTodo(Todo updatedTodo) async {
    final todos = getTodos();
    final todoIndex = todos.indexWhere((todo) => todo.id == updatedTodo.id);

    if (todoIndex != -1) {
      todos[todoIndex] = updatedTodo;
      final todosJson = todos.map((todo) {
        return json.encode(todo.toJson());
      }).toList();
      await _preference?.setStringList(_keyTodos, todosJson);
    }
  }

  // Delete To Do
  static Future deleteTodo(String id) async {
    final todos = getTodos();
    todos.removeWhere((todo) => todo.id == id);
    final todosJson = todos.map((todo) {
      return json.encode(todo.toJson());
    }).toList();
    await _preference?.setStringList(_keyTodos, todosJson);
  }

}
