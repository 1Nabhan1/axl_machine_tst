import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/home/home_bloc.dart';
import '../../../logic/home/home_event.dart';
import '../../../logic/home/home_state.dart';
import '../profile_screen/profile_screen.dart';
import '../todo_screen/todo_screen.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  final List<Widget> _screens = const [TodoScreen(), AccountScreen()];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(index: state.currentIndex, children: _screens),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
              context.read<HomeBloc>().add(TabChanged(index));
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.checklist),
                label: 'Todos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
          ),
        );
      },
    );
  }
}
