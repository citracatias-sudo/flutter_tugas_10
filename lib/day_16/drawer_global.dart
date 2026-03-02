import 'package:flutter/material.dart';

class DrawerGlobal16 extends StatefulWidget {
  const DrawerGlobal16({super.key});

  @override
  State<DrawerGlobal16> createState() => _DrawerGlobal16State();
}

class _DrawerGlobal16State extends State<DrawerGlobal16> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          // Custom Drawer Header with theme colors
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.onPrimary.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.account_circle,
                    size: 56,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Flutter App',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'user@example.com',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          // Drawer Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _DrawerItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: _selectedIndex == 0,
                  onTap: () {
                    setState(() => _selectedIndex = 0);
                    Navigator.pop(context);
                  },
                ),
                _DrawerItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isSelected: _selectedIndex == 1,
                  onTap: () {
                    setState(() => _selectedIndex = 1);
                    Navigator.pop(context);
                  },
                ),
                _DrawerItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  isSelected: _selectedIndex == 2,
                  onTap: () {
                    setState(() => _selectedIndex = 2);
                    Navigator.pop(context);
                  },
                ),
                _DrawerItem(
                  icon: Icons.info_rounded,
                  label: 'About',
                  isSelected: _selectedIndex == 3,
                  onTap: () {
                    setState(() => _selectedIndex = 3);
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 16),
                _DrawerItem(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Text(
              'v1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDestructive;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: Icon(
            icon,
            color: isDestructive
                ? colorScheme.error
                : isSelected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
          title: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isDestructive
                  ? colorScheme.error
                  : isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
        ),
      ),
    );
  }
}
