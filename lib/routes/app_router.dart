import 'package:go_router/go_router.dart'; 
import 'app_routes.dart'; 
import '../features/auth/screens/splash_screen.dart'; 
import '../features/auth/screens/login_screen.dart'; 
import '../features/dashboard/screens/dashboard_screen.dart'; 
import '../features/inventory/screens/inventory_screen.dart'; 
import '../features/sales/screens/new_sale_screen.dart'; 
import '../features/customers/screens/customers_screen.dart'; 
import '../features/reports/screens/reports_screen.dart'; 
import '../features/settings/screens/settings_screen.dart'; 
 
class AppRouter { 
  AppRouter._(); 
  static final GoRouter router = GoRouter( 
    initialLocation: AppRoutes.splash, 
    routes: [ 
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()), 
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()), 
      GoRoute(path: AppRoutes.dashboard, builder: (_, __) => const DashboardScreen()), 
      GoRoute(path: AppRoutes.inventory, builder: (_, __) => const InventoryScreen()), 
      GoRoute(path: AppRoutes.newSale, builder: (_, __) => const NewSaleScreen()), 
      GoRoute(path: AppRoutes.customers, builder: (_, __) => const CustomersScreen()), 
      GoRoute(path: AppRoutes.reports, builder: (_, __) => const ReportsScreen()), 
      GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsScreen()), 
    ], 
  ); 
}