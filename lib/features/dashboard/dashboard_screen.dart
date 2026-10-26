import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:intl/intl.dart'; 
import '../../../core/database/database_helper.dart'; 
import '../../../core/theme/app_colors.dart'; 
import '../../../routes/app_routes.dart'; 
 
class DashboardScreen extends StatefulWidget { 
  const DashboardScreen({super.key}); 
  @override 
  State<DashboardScreen> createState() => _DashboardScreenState(); 
} 
 
class _DashboardScreenState extends State<DashboardScreen> { 
  double _todaySales = 0; 
  int _productCount = 0; 
  int _salesCount = 0; 
 
  @override 
  void initState() { super.initState(); _load(); } 
 
  Future<void> _load() async { 
    final sales = await DatabaseHelper.instance.getTodayTotal(); 
    final products = await DatabaseHelper.instance.getProducts(); 
    final allSales = await DatabaseHelper.instance.getSales(); 
    if (!mounted) return; 
    setState(() { _todaySales = sales; _productCount = products.length; _salesCount = 
allSales.length; }); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final fmt = NumberFormat('#,###', 'en'); 
    return Scaffold( 
      backgroundColor: AppColors.background, 
      body: SafeArea( 
        child: RefreshIndicator( 
          onRefresh: _load, 
          child: SingleChildScrollView( 
            physics: const AlwaysScrollableScrollPhysics(), 
            padding: const EdgeInsets.all(24), 
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [ 
                Row(children: [ 
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: 
[Text('Good Morning,', style: Theme.of(context).textTheme.bodyMedium), Text('Business 
Owner', style: Theme.of(context).textTheme.headlineMedium)])), 
                  IconButton(icon: const Icon(Icons.settings), onPressed: () => 
context.push(AppRoutes.settings)), 
                ]), 
                const SizedBox(height: 24), 
                Container( 
                  width: double.infinity, padding: const EdgeInsets.all(20), 
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: 
BorderRadius.circular(16)), 
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                    const Text("Today's Sales", style: TextStyle(color: Colors.white70, fontSize: 14)), 
                    const SizedBox(height: 8), 
                    Text('UGX ${fmt.format(_todaySales)}', style: const TextStyle(color: Colors.white, 
fontSize: 28, fontWeight: FontWeight.bold)), 
                  ]), 
                ), 
                const SizedBox(height: 16), 
                Row(children: [ 
                  Expanded(child: _statCard('Products', _productCount.toString(), Icons.inventory_2)), 
                  const SizedBox(width: 12), 
                  Expanded(child: _statCard('Sales', _salesCount.toString(), Icons.receipt_long)), 
                ]), 
                const SizedBox(height: 24), 
                _actionTile('New Sale', Icons.add_shopping_cart, AppRoutes.newSale, 
AppColors.primary), 
                _actionTile('Inventory', Icons.inventory_2_outlined, AppRoutes.inventory, 
AppColors.secondary), 
                _actionTile('Customers', Icons.people_outline, AppRoutes.customers, 
AppColors.warning), 
                _actionTile('Reports', Icons.bar_chart, AppRoutes.reports, AppColors.error), 
              ], 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _statCard(String label, String value, IconData icon) { 
    return Container( 
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), 
border: Border.all(color: AppColors.border)), 
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
        Icon(icon, color: AppColors.primary, size: 28), 
        const SizedBox(height: 8), 
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), 
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)), 
      ]), 
    ); 
  } 
 
  Widget _actionTile(String title, IconData icon, String route, Color color) { 
    return Padding( 
      padding: const EdgeInsets.only(bottom: 12), 
      child: InkWell( 
        onTap: () async { await context.push(route); _load(); }, 
        borderRadius: BorderRadius.circular(16), 
        child: Container( 
          padding: const EdgeInsets.all(16), 
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), 
border: Border.all(color: AppColors.border)), 
          child: Row(children: [ 
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: 
color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: 
color)), 
            const SizedBox(width: 16), 
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), 
            const Spacer(), 
            const Icon(Icons.chevron_right, color: AppColors.textLight), 
          ]), 
        ), 
      ), 
    ); 
  } 
}