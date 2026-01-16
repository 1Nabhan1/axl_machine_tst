abstract class TodoEvent {}
class SearchTodos extends TodoEvent {
  final String query;
  SearchTodos(this.query);
}

class FetchTodos extends TodoEvent {
}

class RefreshTodos extends TodoEvent {}

class ToggleFavorite extends TodoEvent {
  final int todoId;


  ToggleFavorite(this.todoId, );
}
