import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_ui/shared_ui.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.value == null) {
      return const _AuthScreen();
    }

    return Scaffold(
      backgroundColor: AniTrackColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(ref),
            const SizedBox(height: AniTrackSpacing.xl),
            _buildStatsSection(ref),
            const SizedBox(height: AniTrackSpacing.xl),
            _buildSettingsMenu(context, ref),
            const SizedBox(height: AniTrackSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    
    return profileAsync.when(
      data: (profile) {
        if (profile == null) return const SizedBox.shrink();
        
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
        // Cover Photo
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://i.pinimg.com/1200x/bc/6d/d2/bc6dd2b4d115ee409f53676ed8a3edfa.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AniTrackColors.background.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),
        
        // Avatar and Name
        Positioned(
          bottom: -60,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AniTrackColors.background, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AniTrackColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profile.avatarUrl),
                ),
              ),
              const SizedBox(height: AniTrackSpacing.sm),
              Text(
                profile.name,
                style: AniTrackTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AniTrackColors.onBackground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${profile.id} • Joined ${profile.joinedDate}',
                style: AniTrackTypography.bodyMedium.copyWith(
                  color: AniTrackColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                profile.bio,
                style: AniTrackTypography.bodyLarge.copyWith(
                  color: AniTrackColors.onBackground,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AniTrackSpacing.lg),
            ],
          ),
        ),
      ],
    );
  },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Lỗi: $e', style: const TextStyle(color: Colors.red))),
    );
  }

  Widget _buildStatsSection(WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final profile = profileAsync.value;
    
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: AniTrackSpacing.xl, right: AniTrackSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatCard('Anime', '${profile?.animeCount ?? 0}', Icons.movie_outlined),
          _buildStatCard('Episodes', '${profile?.episodesCount ?? 0}', Icons.play_circle_outline),
          _buildStatCard('Days', '${profile?.daysCount ?? 0.0}', Icons.timer_outlined),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AniTrackSpacing.md, horizontal: AniTrackSpacing.lg),
      decoration: BoxDecoration(
        color: AniTrackColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AniTrackColors.primary, size: 28),
          const SizedBox(height: AniTrackSpacing.xs),
          Text(
            value,
            style: AniTrackTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AniTrackColors.onSurface,
            ),
          ),
          Text(
            label,
            style: AniTrackTypography.labelMedium.copyWith(
              color: AniTrackColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenu(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AniTrackSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              'Settings',
              style: AniTrackTypography.titleMedium.copyWith(
                color: AniTrackColors.textMuted,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Material(
            color: AniTrackColors.surface,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _buildMenuItem(Icons.person_outline, 'Account Settings', onTap: () => _showEditProfileDialog(context, ref)),
                _buildDivider(),
                _buildMenuItem(
                  Icons.logout, 
                  'Log Out', 
                  isDestructive: true,
                  onTap: () {
                    ref.read(authProvider.notifier).logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {String? trailing, bool isDestructive = false, VoidCallback? onTap}) {
    final color = isDestructive ? AniTrackColors.error : AniTrackColors.onSurface;
    
    return ListTile(
      leading: Icon(icon, color: isDestructive ? AniTrackColors.error : AniTrackColors.secondary),
      title: Text(
        title,
        style: AniTrackTypography.bodyLarge.copyWith(
          color: color,
          fontWeight: isDestructive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: trailing != null 
          ? Text(trailing, style: AniTrackTypography.bodyMedium.copyWith(color: AniTrackColors.textMuted))
          : const Icon(Icons.chevron_right, color: AniTrackColors.textMuted),
      onTap: onTap ?? () {
        // Mock action
      },
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.read(userProfileProvider);
    if (profileAsync.value == null) return;
    final profile = profileAsync.value!;
    
    final nameController = TextEditingController(text: profile.name);
    final bioController = TextEditingController(text: profile.bio);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AniTrackColors.surface,
          title: Text('Edit Profile', style: TextStyle(color: AniTrackColors.onSurface)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: TextStyle(color: AniTrackColors.onSurface),
                  decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: AniTrackColors.textMuted)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: bioController,
                  style: TextStyle(color: AniTrackColors.onSurface),
                  decoration: const InputDecoration(labelText: 'Bio', labelStyle: TextStyle(color: AniTrackColors.textMuted)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(userProfileProvider.notifier).updateProfile(
                  name: nameController.text,
                  bio: bioController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56, color: AniTrackColors.border);
  }

}

class _AuthScreen extends ConsumerStatefulWidget {
  const _AuthScreen();

  @override
  ConsumerState<_AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<_AuthScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu')),
      );
      return;
    }

    try {
      if (_isLoginMode) {
        await ref.read(authProvider.notifier).login(username, password);
      } else {
        await ref.read(authProvider.notifier).register(username, password);
      }
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AniTrackColors.background,
      appBar: AppBar(
        title: Text(_isLoginMode ? 'Đăng nhập' : 'Đăng ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AniTrackSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.account_circle, size: 100, color: AniTrackColors.primary),
            const SizedBox(height: 32),
            TextField(
              controller: _usernameController,
              enabled: !isLoading,
              style: const TextStyle(color: AniTrackColors.onSurface),
              decoration: InputDecoration(
                labelText: 'Tên đăng nhập',
                labelStyle: const TextStyle(color: AniTrackColors.textMuted),
                filled: true,
                fillColor: AniTrackColors.surfaceVariant,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              enabled: !isLoading,
              obscureText: true,
              style: const TextStyle(color: AniTrackColors.onSurface),
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                labelStyle: const TextStyle(color: AniTrackColors.textMuted),
                filled: true,
                fillColor: AniTrackColors.surfaceVariant,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AniTrackColors.primary,
                foregroundColor: AniTrackColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: isLoading 
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(_isLoginMode ? 'Đăng nhập' : 'Đăng ký'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: isLoading ? null : () {
                setState(() {
                  _isLoginMode = !_isLoginMode;
                });
              },
              child: Text(
                _isLoginMode ? 'Chưa có tài khoản? Đăng ký ngay' : 'Đã có tài khoản? Đăng nhập', 
                style: const TextStyle(color: AniTrackColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
