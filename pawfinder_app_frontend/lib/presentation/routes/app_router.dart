import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/app_bottom_nav.dart';
import '../pages/splash_page.dart';
import '../pages/onboarding_page.dart';
import '../pages/home_page.dart';
import '../pages/create_alert_page.dart';
import '../pages/alert_detail_page.dart';
import '../pages/messaging_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/profile_page.dart';
import '../pages/leaderboard_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/alerts',
              builder: (context, state) => const _AlertsPlaceholderPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/report',
              builder: (context, state) => const _ReportPlaceholderPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/messages',
              builder: (context, state) => const _MessagesPlaceholderPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/create-alert',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CreateAlertPage(),
    ),
    GoRoute(
      path: '/alert/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return const AlertDetailPage();
      },
    ),
    GoRoute(
      path: '/messages/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return const MessagingPage();
      },
    ),
    GoRoute(
      path: '/dashboard',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/leaderboard',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LeaderboardPage(),
    ),
  ],
);

class _AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _AppShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

class _AlertsPlaceholderPage extends StatelessWidget {
  const _AlertsPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Alerts',
          style: AppTypography.h2.copyWith(color: AppColors.ink900),
        ),
      ),
      body: const Center(
        child: Text('Alerts page coming soon'),
      ),
    );
  }
}

class _ReportPlaceholderPage extends StatelessWidget {
  const _ReportPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Report',
          style: AppTypography.h2.copyWith(color: AppColors.ink900),
        ),
      ),
      body: const Center(
        child: Text('Report page coming soon'),
      ),
    );
  }
}

class _MessagesPlaceholderPage extends StatelessWidget {
  const _MessagesPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Messages',
          style: AppTypography.h2.copyWith(color: AppColors.ink900),
        ),
      ),
      body: const Center(
        child: Text('Messages page coming soon'),
      ),
    );
  }
}
