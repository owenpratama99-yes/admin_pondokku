import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../landing/landing_page.dart';
import '../../employee/features/auth/employee_login_screen.dart';
import '../../employee/features/auth/forgot_password_screen.dart';
import '../../employee/features/dashboard/dashboard_screen.dart';
import '../../employee/features/attendance/attendance_screen.dart';
import '../../employee/features/tasks/tasks_screen.dart';
import '../../employee/features/ledger/ledger_screen.dart';
import '../../employee/features/profile/profile_screen.dart';
import '../../manager/features/auth/manager_login_screen.dart';
import '../../manager/features/auth/manager_forgot_password_screen.dart';
import '../../manager/features/dashboard/executive_dashboard.dart';
import '../../manager/features/task_review/task_review_screen.dart';
import '../../manager/features/points/manual_adjustment_screen.dart';
import '../../manager/features/roster/roster_screen.dart';
// Branches
import '../../manager/features/branches/branches_screen.dart';
import '../../manager/features/branches/branch_detail_screen.dart';
import '../../manager/features/branches/create_branch_screen.dart';
import '../../manager/features/branches/edit_branch_screen.dart';
// Employees
import '../../manager/features/employees/employees_screen.dart';
import '../../manager/features/employees/employee_detail_screen.dart';
import '../../manager/features/employees/create_employee_screen.dart';
import '../../manager/features/employees/edit_employee_screen.dart';
import '../../manager/features/employees/employee_performance_screen.dart';
// Warning Letters
import '../../manager/features/warning_letters/warning_letters_screen.dart';
import '../../manager/features/warning_letters/issue_sp_screen.dart';
import '../../manager/features/warning_letters/sp_detail_screen.dart';
// Point Reset
import '../../manager/features/point_reset/monthly_reset_screen.dart';
import '../../manager/features/point_reset/yearly_reset_screen.dart';
import '../../manager/features/point_reset/point_archive_screen.dart';
// Shifts
import '../../manager/features/shifts/shifts_screen.dart';
import '../../manager/features/shifts/create_shift_screen.dart';
import '../../manager/features/shifts/shift_swap_screen.dart';
import '../../manager/features/shifts/overtime_screen.dart';
// Inventory
import '../../manager/features/inventory/inventory_screen.dart';
import '../../manager/features/inventory/restock_request_screen.dart';
import '../../manager/features/inventory/stock_opname_screen.dart';
import '../../manager/features/inventory/waste_tracking_screen.dart';
// Reports
import '../../manager/features/reports/reports_screen.dart';
import '../../manager/features/reports/generate_report_screen.dart';
import '../../manager/features/reports/export_screen.dart';
// Announcements
import '../../manager/features/announcements/announcements_screen.dart';
import '../../manager/features/announcements/create_announcement_screen.dart';
import '../../manager/features/announcements/announcement_detail_screen.dart';
// Sales
import '../../manager/features/sales/sales_screen.dart';
import '../../manager/features/sales/record_sales_screen.dart';
import '../../manager/features/sales/sales_analytics_screen.dart';
// Achievements
import '../../manager/features/achievements/achievements_screen.dart';
import '../../manager/features/achievements/create_achievement_screen.dart';
import '../../manager/features/achievements/employee_achievements_screen.dart';
// Tasks
import '../../manager/features/tasks/task_templates_screen.dart';
import '../../manager/features/tasks/create_template_screen.dart';
// Chat
import '../../manager/features/chat/chat_screen.dart';
import '../../manager/features/chat/chat_room_screen.dart';
import '../../manager/features/chat/chat_history_screen.dart';
// Feedback
import '../../manager/features/feedback/feedback_screen.dart';
import '../../manager/features/feedback/feedback_analytics_screen.dart';
// Analytics
import '../../manager/features/analytics/analytics_dashboard_screen.dart';
import '../../manager/features/analytics/predictive_analytics_screen.dart';
// Settings
import '../../manager/features/settings/settings_screen.dart';
import '../../manager/features/settings/user_management_screen.dart';
import '../../manager/features/settings/audit_log_screen.dart';
import '../services/auth_service.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static String _determineInitialLocation() {
    try {
      final host = Uri.base.host.toLowerCase();
      if (host.contains('user.madjudjadja.com') || host.startsWith('user.')) {
        return '/employee/login';
      } else if (host.contains('hris.madjudjadja.com') || host.startsWith('hris.')) {
        return '/manager/login';
      }
    } catch (_) {}
    return '/';
  }

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: _determineInitialLocation(),
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final authService = AuthService();
      final isLoggedIn = await authService.isAuthenticated();
      final isLoginRoute = state.matchedLocation.contains('/login');
      final isForgotPasswordRoute = state.matchedLocation.contains('/forgot-password');

      // Jika sudah login dan mencoba akses login page, redirect ke dashboard
      if (isLoggedIn && (isLoginRoute || isForgotPasswordRoute)) {
        if (state.matchedLocation.contains('/employee')) {
          return '/employee/dashboard';
        } else if (state.matchedLocation.contains('/manager')) {
          return '/manager/dashboard';
        }
      }

      // Jika belum login dan mencoba akses protected route
      if (!isLoggedIn && !isLoginRoute && !isForgotPasswordRoute && state.matchedLocation != '/') {
        if (state.matchedLocation.contains('/employee')) {
          return '/employee/login';
        } else if (state.matchedLocation.contains('/manager')) {
          return '/manager/login';
        }
      }

      return null;
    },
    routes: [
      // ─── Landing Page ────────────────────────────────────────────────
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (context, state) => const LandingPage(),
      ),

      // ─── Employee Portal Routes ──────────────────────────────────────
      GoRoute(
        path: '/employee/login',
        name: 'employee-login',
        builder: (context, state) => const EmployeeLoginScreen(),
      ),
      GoRoute(
        path: '/employee/forgot-password',
        name: 'employee-forgot-password',
        builder: (context, state) => const EmployeeForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/employee/dashboard',
        name: 'employee-dashboard',
        builder: (context, state) => const EmployeeDashboardScreen(),
      ),
      GoRoute(
        path: '/employee/attendance',
        name: 'employee-attendance',
        builder: (context, state) => const AttendanceScreen(),
      ),
      GoRoute(
        path: '/employee/tasks',
        name: 'employee-tasks',
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: '/employee/ledger',
        name: 'employee-ledger',
        builder: (context, state) => const LedgerScreen(),
      ),
      GoRoute(
        path: '/employee/profile',
        name: 'employee-profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // ─── Manager Portal Routes ───────────────────────────────────────
      GoRoute(
        path: '/manager/login',
        name: 'manager-login',
        builder: (context, state) => const ManagerLoginScreen(),
      ),
      GoRoute(
        path: '/manager/forgot-password',
        name: 'manager-forgot-password',
        builder: (context, state) => const ManagerForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/manager/dashboard',
        name: 'manager-dashboard',
        builder: (context, state) => const ExecutiveDashboard(),
      ),
      GoRoute(
        path: '/manager/tasks',
        name: 'manager-tasks',
        builder: (context, state) => const TaskReviewScreen(),
      ),
      GoRoute(
        path: '/manager/points',
        name: 'manager-points',
        builder: (context, state) => const ManualAdjustmentScreen(),
      ),
      GoRoute(
        path: '/manager/roster',
        name: 'manager-roster',
        builder: (context, state) => const RosterScreen(),
      ),

      // ─── Branches ─────────────────────────────────────────────────────
      GoRoute(
        path: '/manager/branches',
        name: 'manager-branches',
        builder: (context, state) => const BranchesScreen(),
      ),
      GoRoute(
        path: '/manager/branches/create',
        name: 'manager-branches-create',
        builder: (context, state) => const CreateBranchScreen(),
      ),
      GoRoute(
        path: '/manager/branches/:id',
        name: 'manager-branch-detail',
        builder: (context, state) => BranchDetailScreen(
          branchId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/manager/branches/:id/edit',
        name: 'manager-branch-edit',
        builder: (context, state) => EditBranchScreen(
          branchId: state.pathParameters['id']!,
        ),
      ),

      // ─── Employees ────────────────────────────────────────────────────
      GoRoute(
        path: '/manager/employees',
        name: 'manager-employees',
        builder: (context, state) => const EmployeesScreen(),
      ),
      GoRoute(
        path: '/manager/employees/create',
        name: 'manager-employees-create',
        builder: (context, state) => const CreateEmployeeScreen(),
      ),
      GoRoute(
        path: '/manager/employees/:id',
        name: 'manager-employee-detail',
        builder: (context, state) => EmployeeDetailScreen(
          employeeId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/manager/employees/:id/edit',
        name: 'manager-employee-edit',
        builder: (context, state) => EditEmployeeScreen(
          employeeId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/manager/employees/:id/performance',
        name: 'manager-employee-performance',
        builder: (context, state) => EmployeePerformanceScreen(
          employeeId: state.pathParameters['id']!,
        ),
      ),

      // ─── Warning Letters (SP) ─────────────────────────────────────────
      GoRoute(
        path: '/manager/sp',
        name: 'manager-sp',
        builder: (context, state) => const WarningLettersScreen(),
      ),
      GoRoute(
        path: '/manager/sp/issue/:employeeId',
        name: 'manager-sp-issue',
        builder: (context, state) => IssueSPScreen(
          employeeId: state.pathParameters['employeeId']!,
          employeeName: state.uri.queryParameters['name'] ?? 'Employee',
          currentPoints: int.tryParse(state.uri.queryParameters['points'] ?? '0') ?? 0,
          currentSPLevel: int.tryParse(state.uri.queryParameters['spLevel'] ?? '0') ?? 0,
        ),
      ),
      GoRoute(
        path: '/manager/sp/:id',
        name: 'manager-sp-detail',
        builder: (context, state) => SPDetailScreen(
          spId: state.pathParameters['id']!,
        ),
      ),

      // ─── Point Reset ──────────────────────────────────────────────────
      GoRoute(
        path: '/manager/point-reset/monthly',
        name: 'manager-point-reset-monthly',
        builder: (context, state) => const MonthlyResetScreen(),
      ),
      GoRoute(
        path: '/manager/point-reset/yearly',
        name: 'manager-point-reset-yearly',
        builder: (context, state) => const YearlyResetScreen(),
      ),
      GoRoute(
        path: '/manager/point-reset/archive',
        name: 'manager-point-archive',
        builder: (context, state) => const PointArchiveScreen(),
      ),

      // ─── Shifts ───────────────────────────────────────────────────────
      GoRoute(
        path: '/manager/shifts',
        name: 'manager-shifts',
        builder: (context, state) => const ShiftsScreen(),
      ),
      GoRoute(
        path: '/manager/shifts/create',
        name: 'manager-shifts-create',
        builder: (context, state) => const CreateShiftScreen(),
      ),
      GoRoute(
        path: '/manager/shifts/swap',
        name: 'manager-shift-swap',
        builder: (context, state) => const ShiftSwapScreen(),
      ),
      GoRoute(
        path: '/manager/shifts/overtime',
        name: 'manager-shift-overtime',
        builder: (context, state) => const OvertimeScreen(),
      ),

      // ─── Inventory ────────────────────────────────────────────────────
      GoRoute(
        path: '/manager/inventory',
        name: 'manager-inventory',
        builder: (context, state) => const InventoryScreen(),
      ),
      GoRoute(
        path: '/manager/inventory/restock',
        name: 'manager-inventory-restock',
        builder: (context, state) => const RestockRequestScreen(),
      ),
      GoRoute(
        path: '/manager/inventory/opname',
        name: 'manager-inventory-opname',
        builder: (context, state) => const StockOpnameScreen(),
      ),
      GoRoute(
        path: '/manager/inventory/waste',
        name: 'manager-inventory-waste',
        builder: (context, state) => const WasteTrackingScreen(),
      ),

      // ─── Reports ──────────────────────────────────────────────────────
      GoRoute(
        path: '/manager/reports',
        name: 'manager-reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/manager/reports/generate',
        name: 'manager-reports-generate',
        builder: (context, state) => const GenerateReportScreen(),
      ),
      GoRoute(
        path: '/manager/reports/export',
        name: 'manager-reports-export',
        builder: (context, state) => const ExportScreen(),
      ),

      // ─── Announcements ────────────────────────────────────────────────
      GoRoute(
        path: '/manager/announcements',
        name: 'manager-announcements',
        builder: (context, state) => const AnnouncementsScreen(),
      ),
      GoRoute(
        path: '/manager/announcements/create',
        name: 'manager-announcements-create',
        builder: (context, state) => const CreateAnnouncementScreen(),
      ),
      GoRoute(
        path: '/manager/announcements/:id',
        name: 'manager-announcement-detail',
        builder: (context, state) => AnnouncementDetailScreen(
          announcementId: state.pathParameters['id']!,
        ),
      ),

      // ─── Sales ────────────────────────────────────────────────────────
      GoRoute(
        path: '/manager/sales',
        name: 'manager-sales',
        builder: (context, state) => const SalesScreen(),
      ),
      GoRoute(
        path: '/manager/sales/record',
        name: 'manager-sales-record',
        builder: (context, state) => const RecordSalesScreen(),
      ),
      GoRoute(
        path: '/manager/sales/analytics',
        name: 'manager-sales-analytics',
        builder: (context, state) => const SalesAnalyticsScreen(),
      ),

      // ─── Achievements ─────────────────────────────────────────────────
      GoRoute(
        path: '/manager/achievements',
        name: 'manager-achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/manager/achievements/create',
        name: 'manager-achievements-create',
        builder: (context, state) => const CreateAchievementScreen(),
      ),
      GoRoute(
        path: '/manager/achievements/:id',
        name: 'manager-employee-achievements',
        builder: (context, state) => EmployeeAchievementsScreen(
          employeeId: state.pathParameters['id']!,
        ),
      ),

      // ─── Task Templates ───────────────────────────────────────────────
      GoRoute(
        path: '/manager/task-templates',
        name: 'manager-task-templates',
        builder: (context, state) => const TaskTemplatesScreen(),
      ),
      GoRoute(
        path: '/manager/task-templates/create',
        name: 'manager-task-templates-create',
        builder: (context, state) => const CreateTemplateScreen(),
      ),

      // ─── Chat ─────────────────────────────────────────────────────────
      GoRoute(
        path: '/manager/chat',
        name: 'manager-chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/manager/chat/:id',
        name: 'manager-chat-room',
        builder: (context, state) => ChatRoomScreen(
          roomId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/manager/chat/history',
        name: 'manager-chat-history',
        builder: (context, state) => const ChatHistoryScreen(),
      ),

      // ─── Feedback ─────────────────────────────────────────────────────
      GoRoute(
        path: '/manager/feedback',
        name: 'manager-feedback',
        builder: (context, state) => const FeedbackScreen(),
      ),
      GoRoute(
        path: '/manager/feedback/analytics',
        name: 'manager-feedback-analytics',
        builder: (context, state) => const FeedbackAnalyticsScreen(),
      ),

      // ─── Analytics ────────────────────────────────────────────────────
      GoRoute(
        path: '/manager/analytics',
        name: 'manager-analytics',
        builder: (context, state) => const AnalyticsDashboardScreen(),
      ),
      GoRoute(
        path: '/manager/analytics/predictive',
        name: 'manager-analytics-predictive',
        builder: (context, state) => const PredictiveAnalyticsScreen(),
      ),

      // ─── Settings ─────────────────────────────────────────────────────
      GoRoute(
        path: '/manager/settings',
        name: 'manager-settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/manager/settings/users',
        name: 'manager-settings-users',
        builder: (context, state) => const UserManagementScreen(),
      ),
      GoRoute(
        path: '/manager/settings/audit',
        name: 'manager-settings-audit',
        builder: (context, state) => const AuditLogScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '404 - Halaman Tidak Ditemukan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Path: ${state.uri.path}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    ),
  );
}
