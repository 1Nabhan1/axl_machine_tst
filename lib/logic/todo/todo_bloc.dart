import 'package:axel_tech/logic/todo/todo_event.dart';
import 'package:axel_tech/logic/todo/todo_state.dart';

import '../../data/repositories/todo_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc(this.repository) : super(TodoInitial()) {
    on<FetchTodos>(_onFetch);
    on<RefreshTodos>(_onFetch);
    on<ToggleFavorite>(_onToggleFavorite);
    on<SearchTodos>(_onSearch);
  }

  Future<void> _onFetch(TodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try { 
      final todos = await repository.fetchTodos();
      emit(TodoLoaded(allTodos: todos, visibleTodos: todos));
    } catch (_) {
      emit(TodoError('Failed to load todos'));
    }
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<TodoState> emit) {
    if (state is! TodoLoaded) return;

    final current = state as TodoLoaded;

    final updatedAll = current.allTodos.map((todo) {
      if (todo.id == event.todoId) {
        final newValue = !todo.isFavorite;

        // 🔥 persist favorite ONLY
        repository.toggleFavorite(todo.id, newValue);

        return todo.copyWith(isFavorite: newValue);
      }
      return todo;
    }).toList();

    // 🔥 Re-apply search filter if needed
    final updatedVisible = current.searchQuery.isEmpty
        ? updatedAll
        : updatedAll
              .where(
                (e) => e.title.toLowerCase().contains(
                  current.searchQuery.toLowerCase(),
                ),
              )
              .toList();

    emit(
      TodoLoaded(
        allTodos: updatedAll,
        visibleTodos: updatedVisible,
        searchQuery: current.searchQuery,
      ),
    );
  }

  void _onSearch(SearchTodos event, Emitter<TodoState> emit) {
    if (state is TodoLoaded) {
      final current = state as TodoLoaded;

      final filtered = current.allTodos
          .where(
            (e) => e.title.toLowerCase().contains(event.query.toLowerCase()),
          )
          .toList();

      emit(TodoLoaded(allTodos: current.allTodos, visibleTodos: filtered));
    }
  }
}
