import 'dart:io';

import 'package:axel_tech/logic/auth/auth_state.dart';
import 'package:axel_tech/presentation/routes/page_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../../data/models/user_model.dart';
import '../../../../data/services/session_manager/cache_service.dart';
import '../../../../logic/auth/auth_bloc.dart';
import '../../../../logic/auth/auth_event.dart';
import '../../../../logic/theme/theme_cubit.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundImage: FileImage(File(user.profileImagePath)),
          child: null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                user.username,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, PageList.editProfile);
          },
        ),
      ],
    );
  }
}

class ProfileCompletion extends StatelessWidget {
  final UserModel user;

  const ProfileCompletion({super.key, required this.user});

  double _calculateCompletion() {
    int filled = 0;
    if (user.username.isNotEmpty) filled++;
    if (user.fullName.isNotEmpty) filled++;
    if (user.dob != null) filled++;
    if (user.profileImagePath != null) filled++;

    return filled / 4;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateCompletion();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Completion',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: progress),
        const SizedBox(height: 4),
        Text('${(progress * 100).toInt()}% completed'),
      ],
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        /// Theme Toggle
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) {
            return SwitchListTile(
              title: const Text('Dark Mode'),
              value: mode == ThemeMode.dark,
              onChanged: (_) {
                context.read<ThemeCubit>().toggleTheme();
              },
            );
          },
        ),

        /// Clear Cache
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('Clear Cached Data'),
          onTap: () async {
            await CacheService.clearAll(false);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Cache cleared')));
          },
        ),

        /// Logout
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                PageList.login,
                (route) => false,
              );
            }
          },
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ),
      ],
    );
  }
}
