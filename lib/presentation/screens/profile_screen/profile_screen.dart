import 'package:axel_tech/logic/profile/profile_event.dart';
import 'package:axel_tech/presentation/screens/profile_screen/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/profile/profile_bloc.dart';
import '../../../logic/profile/profile_state.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<AccountBloc>().add(LoadAccount());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountLoaded) {
            final user = state.user;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ProfileHeader(user: user),
                const SizedBox(height: 24),
                ProfileCompletion(user: user),
                const SizedBox(height: 32),
                SettingsSection(),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
