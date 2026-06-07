import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AniTrackColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: AniTrackSpacing.xl),
            _buildStatsSection(),
            const SizedBox(height: AniTrackSpacing.xl),
            _buildSettingsMenu(),
            const SizedBox(height: AniTrackSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
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
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://i.pinimg.com/736x/21/df/b8/21dfb85e054457e5e34b9d038a8e3f94.jpg'),
                ),
              ),
              const SizedBox(height: AniTrackSpacing.sm),
              Text(
                'AniFan2026',
                style: AniTrackTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AniTrackColors.onBackground,
                ),
              ),
              Text(
                'ID: 8934521 • Joined March 2026',
                style: AniTrackTypography.bodyMedium.copyWith(
                  color: AniTrackColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: AniTrackSpacing.xl, right: AniTrackSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatCard('Anime', '125', Icons.movie_outlined),
          _buildStatCard('Episodes', '2,340', Icons.play_circle_outline),
          _buildStatCard('Days', '42.5', Icons.timer_outlined),
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

  Widget _buildSettingsMenu() {
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
          Container(
            decoration: BoxDecoration(
              color: AniTrackColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildMenuItem(Icons.person_outline, 'Account Settings'),
                _buildDivider(),
                _buildMenuItem(Icons.palette_outlined, 'Appearance'),
                _buildDivider(),
                _buildMenuItem(Icons.notifications_none, 'Notifications'),
                _buildDivider(),
                _buildMenuItem(Icons.language, 'Language', trailing: 'English'),
              ],
            ),
          ),
          const SizedBox(height: AniTrackSpacing.xl),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              'About',
              style: AniTrackTypography.titleMedium.copyWith(
                color: AniTrackColors.textMuted,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AniTrackColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildMenuItem(Icons.help_outline, 'Help & Support'),
                _buildDivider(),
                _buildMenuItem(Icons.info_outline, 'About AniTrack', trailing: 'v1.0.0'),
                _buildDivider(),
                _buildMenuItem(Icons.logout, 'Log Out', isDestructive: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {String? trailing, bool isDestructive = false}) {
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
      onTap: () {
        // Mock action
      },
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56, color: AniTrackColors.border);
  }
}
