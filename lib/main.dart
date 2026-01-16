import 'package:axel_tech/logic/theme/theme_cubit.dart';
import 'package:axel_tech/presentation/routes/app_routes.dart';
import 'package:axel_tech/presentation/routes/page_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import 'data/providers/multi_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('todos');
  await Hive.openBox('user');
  await Hive.openBox('favorites');
  await Hive.openBox('settings');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: MultiBlocProviders.providers,
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Axel MT',
            themeMode: themeMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
              pageTransitionsTheme: PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android:
                      PredictiveBackPageTransitionsBuilder(),
                },
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              pageTransitionsTheme: PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android:
                      PredictiveBackPageTransitionsBuilder(),
                },
              ),
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: PageList.splash,
            routes: AppRoutes.routes,
            // home: LoginScreen(),
          );
        },
      ),
    );
  }
}
