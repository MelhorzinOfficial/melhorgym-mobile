import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../navigation/route_names.dart';

class AppBottomNavBar extends StatelessWidget {
  final Widget child;

  const AppBottomNavBar({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(RouteNames.trainings)) return 1;
    if (location.startsWith(RouteNames.profile)) return 2;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    lightHaptic();
    switch (index) {
      case 0:
        context.go(RouteNames.home);
      case 1:
        context.go(RouteNames.trainings);
      case 2:
        context.go(RouteNames.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.card.withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(
              color: AppColors.divider.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Início',
                isActive: selectedIndex == 0,
                onTap: () => _onItemTapped(context, 0),
                color: AppColors.primary,
              ),
              _NavItem(
                icon: Icons.fitness_center_outlined,
                activeIcon: Icons.fitness_center_rounded,
                label: 'Treinos',
                isActive: selectedIndex == 1,
                onTap: () => _onItemTapped(context, 1),
                color: AppColors.accent,
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Perfil',
                isActive: selectedIndex == 2,
                onTap: () => _onItemTapped(context, 2),
                color: AppColors.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color color;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 20 : 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? color : AppColors.textTertiary,
              size: 22,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
