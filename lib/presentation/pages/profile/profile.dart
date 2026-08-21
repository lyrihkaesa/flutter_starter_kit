import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/app_theme/app_theme_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/custom_avatar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            unauthenticated: () {
              context.go('/login');
            },
          );
        },
        builder: (context, state) {
          final user = state.whenOrNull(authenticated: (user) => user);

          final username = user?.name ?? 'Pengguna';
          final email = user?.email ?? '-';
          final avatarUrl = user?.avatarUrl;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomAvatar(size: 80, username: username, imageUrl: avatarUrl),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(email, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Pengaturan App',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey),
                  ),
                ),
                BlocBuilder<AppThemeBloc, AppThemeState>(
                  builder: (context, state) {
                    final isDark = state.themeMode == ThemeMode.dark;
                    return ListTile(
                      title: Text('Mode Gelap', style: Theme.of(context).textTheme.titleSmall),
                      trailing: Switch(
                        value: isDark,
                        onChanged: (_) => context.read<AppThemeBloc>().add(const AppThemeEvent.toggled()),
                      ),
                      shape: const Border(top: BorderSide(color: Color.fromARGB(50, 0, 0, 0), width: 0.5)),
                    );
                  },
                ),
                ProfileListItem(title: 'Ubah Password', onTap: () {}),
                ProfileListItem(title: 'Bahasa / Language', subtitle: user?.locale ?? 'Indonesia', onTap: () {}),
                ProfileListItem(title: 'Kebijakan Privasi', onTap: () {}),
                ProfileListItem(
                  title: 'Keluar',
                  onTap: () {
                    context.read<AuthBloc>().add(const AuthEvent.logoutRequested());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final void Function()? onTap;

  const ProfileListItem({required this.title, this.subtitle, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.titleSmall),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color.fromARGB(175, 0, 0, 0)),
            )
          : null,
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
      shape: const Border(top: BorderSide(color: Color.fromARGB(50, 0, 0, 0), width: 0.5)),
      dense: subtitle != null,
    );
  }
}
