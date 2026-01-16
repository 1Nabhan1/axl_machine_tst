import 'package:axel_tech/data/repositories/account_repo.dart';
import 'package:axel_tech/data/repositories/todo_repo.dart';
import 'package:axel_tech/logic/auth/auth_bloc.dart';
import 'package:axel_tech/logic/profile/profile_event.dart';
import 'package:axel_tech/logic/theme/theme_cubit.dart';
import 'package:axel_tech/logic/todo/todo_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:provider/single_child_widget.dart';

import '../../logic/home/home_bloc.dart';
import '../../logic/profile/profile_bloc.dart';
import '../../logic/todo/todo_event.dart';

abstract class MultiBlocProviders {
  static final List<SingleChildWidget> providers = [
    BlocProvider(create: (context) => AuthBloc()),
    BlocProvider(create: (_) => HomeBloc()),
    BlocProvider(create: (_) => TodoBloc(TodoRepository())),
    BlocProvider(
      create: (_) => AccountBloc(AccountRepository()),
    ),
    BlocProvider(create: (context) => ThemeCubit(Hive.box('settings'))),
  ];
}
