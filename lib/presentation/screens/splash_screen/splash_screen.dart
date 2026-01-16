import 'package:flutter/material.dart';
import 'package:axel_tech/presentation/routes/page_list.dart';
import '../../../data/repositories/account_repo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 2)); // optional splash delay

    final user = AccountRepository().getUser();

    if (user != null) {
      // Navigate to Home/Account Screen
      Navigator.pushReplacementNamed(context, PageList.home);
    } else {
      // Navigate to Login Screen
      Navigator.pushReplacementNamed(context, PageList.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
