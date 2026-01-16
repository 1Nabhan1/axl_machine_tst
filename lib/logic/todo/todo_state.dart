import '../../data/models/todo_model.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> allTodos;      // SOURCE
  final List<Todo> visibleTodos; // FILTERED / UI
  final String searchQuery;      // CURRENT FILTER STATE

  TodoLoaded({
    required this.allTodos,
    required this.visibleTodos,
    this.searchQuery = '',
  });
}

class TodoError extends TodoState {
  final String message;
  TodoError(this.message);
}
