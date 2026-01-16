import 'package:axel_tech/presentation/routes/page_list.dart';
import 'package:axel_tech/presentation/screens/home_shell/home_shell.dart';
import 'package:axel_tech/presentation/screens/login/login_screen.dart';
import 'package:axel_tech/presentation/screens/registration/registration_screen.dart';
import 'package:axel_tech/presentation/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

import '../screens/edit_profile/edit_profile.dart';

class AppRoutes {
  static const initial = PageList.register;

  static Map<String, Widget Function(BuildContext)> routes = {
    PageList.splash:(context)=>SplashScreen(),
    PageList.login: (context) => LoginScreen(),
    PageList.register: (context) => SignupScreen(),
    PageList.home: (context) => HomeShell(),
    PageList.editProfile: (context) => EditProfileScreen(),

  };
}
