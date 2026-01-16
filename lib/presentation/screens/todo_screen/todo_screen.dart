import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/todo/todo_bloc.dart';
import '../../../logic/todo/todo_event.dart';
import '../../../logic/todo/todo_state.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(FetchTodos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search todos...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                context.read<TodoBloc>().add(SearchTodos(value));
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TodoError) {
            return Center(child: Text(state.message));
          }

          if (state is TodoLoaded) {
            final todos = state.visibleTodos; // ✅ FIX

            if (todos.isEmpty) {
              return const Center(child: Text('No todos found'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TodoBloc>().add(RefreshTodos());
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];

                  return ListTile(
                    leading: Checkbox(
                      value: todo.completed,
                      onChanged: (_) {},
                    ),
                    title: Text(todo.title),
                    trailing: IconButton(
                      icon: Icon(
                        todo.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: todo.isFavorite
                            ? Colors.red
                            : Colors.grey,
                      ),
                      onPressed: () {
                        context
                            .read<TodoBloc>()
                            .add(ToggleFavorite(todo.id));
                      },
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

