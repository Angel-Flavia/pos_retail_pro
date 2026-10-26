import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import '../../../core/theme/app_colors.dart'; 
import '../../../routes/app_routes.dart'; 
 
class SplashScreen extends StatefulWidget { 
  const SplashScreen({super.key}); 
  @override 
  State<SplashScreen> createState() => _SplashScreenState(); 
} 
 
class _SplashScreenState extends State<SplashScreen> { 
  @override 
  void initState() { 
    super.initState(); 
    Future.delayed(const Duration(seconds: 2), () { 
      if (mounted) context.go(AppRoutes.login); 
    }); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: Colors.white, 
      body: SafeArea( 
        child: Padding( 
          padding: const EdgeInsets.symmetric(horizontal: 24), 
          child: Column( 
            children: [ 
              const Spacer(flex: 2), 
              Container( 
                width: 100, height: 100, 
                decoration: BoxDecoration( 
                  color: AppColors.primary, 
                  borderRadius: BorderRadius.circular(24), 
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, 
offset: const Offset(0, 10))], 
                ), 
                child: const Icon(Icons.shopping_cart_outlined, size: 56, color: Colors.white), 
              ), 
              const SizedBox(height: 32), 
              Text('POS Retail Pro', style: 
Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 28, fontWeight: 
FontWeight.bold)), 
              const SizedBox(height: 12), 
              Text('Manage your business\nanytime, anywhere', textAlign: TextAlign.center, style: 
Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15)), 
              const Spacer(flex: 3), 
              SizedBox( 
                width: double.infinity, height: 54, 
                child: ElevatedButton(onPressed: () => context.go(AppRoutes.login), child: const 
Text('Get Started')), 
              ), 
              const SizedBox(height: 24), 
              Text('Version 1.0.0', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: 
AppColors.textLight)), 
              const SizedBox(height: 24), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
}