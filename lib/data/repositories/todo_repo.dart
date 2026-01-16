import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/todo_model.dart';
import 'package:http/http.dart' as http;

import 'account_repo.dart';

class TodoRepository {
  final Box _todoBox = Hive.box('todos');
  final Box _favBox = Hive.box('favorites');

  // Fetch todos with user-specific favorites
  Future<List<Todo>> fetchTodos() async {
    try {
      final username = AccountRepository().getUser()?.username ?? '';
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
      );

      if (response.statusCode != 200) throw Exception('API error');

      final List data = jsonDecode(response.body);

      final todos = data.map((e) {
        final id = e['id'];

        // 🔹 Get user-specific favorite
        final isFavorite = _favBox.get('$username-$id', defaultValue: false);

        return Todo.fromJson(e).copyWith(isFavorite: isFavorite);
      }).toList();

      await _cacheTodos(todos);
      return todos;
    } catch (_) {
      return _getCachedTodos();
    }
  }

  // Toggle favorite for specific user
  Future<void> toggleFavorite(int id, bool value) async {
    final username = AccountRepository().getUser()?.username ?? '';
    await _favBox.put('$username-$id', value);
  }

  Future<void> updateTodo(Todo todo) async {
    await _todoBox.put(todo.id, todo.toMap());
  }

  Future<void> _cacheTodos(List<Todo> todos) async {
    if (_todoBox.isEmpty) {
      for (var todo in todos) {
        await _todoBox.put(todo.id, todo.toMap());
      }
    }
  }

  // Load cached todos and merge user favorites
  List<Todo> _getCachedTodos() {
    final username = AccountRepository().getUser()?.username ?? '';

    return _todoBox.values.map((e) {
      final todo = Todo.fromJson(Map<String, dynamic>.from(e));
      final isFav = _favBox.get('$username-${todo.id}', defaultValue: false);
      return todo.copyWith(isFavorite: isFav);
    }).toList();
  }
}
