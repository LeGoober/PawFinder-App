import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../di/injection.dart';
import '../blocs/auth/auth_cubit.dart';
import '../widgets/app_bottom_nav.dart';
import '../pages/splash_page.dart';
import '../pages/onboarding_page.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/alerts_page.dart';
import '../pages/report_sighting_page.dart';
import '../pages/conversations_page.dart';
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
  redirect: _authGuard,
  routes: [
    // ── Public routes (no auth required) ─────────────────────
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    // ── Authenticated shell (bottom nav) ─────────────────────
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
              builder: (context, state) => const AlertsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/report',
              builder: (context, state) => const ReportSightingPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/messages',
              builder: (context, state) => const ConversationsPage(),
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

    // ── Full-screen authenticated routes ─────────────────────
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
        return AlertDetailPage(alertId: id);
      },
    ),
    GoRoute(
      path: '/messages/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return MessagingPage(conversationId: id);
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

/// Auth guard — redirect unauthenticated users away from protected routes.
String? _authGuard(BuildContext context, GoRouterState state) {
  final location = state.uri.toString();

  // Public paths — no auth required
  const publicPaths = ['/', '/onboarding', '/login'];
  if (publicPaths.contains(location)) return null;

  // Check if user is authenticated
  final authCubit = getIt<AuthCubit>();
  if (!authCubit.isAuthenticated) {
    return '/onboarding';
  }

  return null;
}

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
