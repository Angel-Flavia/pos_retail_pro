import 'package:flutter/material.dart'; 
import 'package:intl/intl.dart'; 
import '../../../core/database/database_helper.dart'; 
import '../../../core/theme/app_colors.dart'; 
 
class ReportsScreen extends StatefulWidget { 
  const ReportsScreen({super.key}); 
  @override 
  State<ReportsScreen> createState() => _ReportsScreenState(); 
} 
 
class _ReportsScreenState extends State<ReportsScreen> { 
  List<Map<String, dynamic>> _sales = []; 
 
  @override 
  void initState() { super.initState(); _load(); } 
 
  Future<void> _load() async { 
    final data = await DatabaseHelper.instance.getSales(); 
    if (!mounted) return; 
    setState(() => _sales = data); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final fmt = NumberFormat('#,###', 'en'); 
    double total = 0; 
    for (var s in _sales) { total += (s['total'] as num); } 
 
    return Scaffold( 
      backgroundColor: AppColors.background, 
      appBar: AppBar(title: const Text('Reports')), 
      body: Column( 
        children: [ 
          Container( 
            margin: const EdgeInsets.all(16), 
            padding: const EdgeInsets.all(20), 
            width: double.infinity, 
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: 
BorderRadius.circular(16)), 
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [ 
                const Text('Total Revenue', style: TextStyle(color: Colors.white70)), 
                Text('UGX ${fmt.format(total)}', style: const TextStyle(color: Colors.white, fontSize: 32, 
fontWeight: FontWeight.bold)), 
              ], 
            ), 
          ), 
          const Padding( 
            padding: EdgeInsets.symmetric(horizontal: 16), 
            child: Align(alignment: Alignment.centerLeft, child: Text('Recent Transactions', style: 
TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), 
          ), 
          Expanded( 
            child: _sales.isEmpty  
              ? const Center(child: Text('No sales yet')) 
              : ListView.builder( 
                  padding: const EdgeInsets.all(16), 
                  itemCount: _sales.length, 
                  itemBuilder: (_, i) { 
                    final s = _sales[i]; 
                    return Card( 
                      child: ListTile( 
                        leading: const Icon(Icons.receipt, color: AppColors.success), 
                        title: Text('UGX ${fmt.format(s['total'])}'), 
                        subtitle: Text('${s['paymentMethod']} - ${s['createdAt'].toString().substring(0, 
10)}'), 
                      ), 
                    ); 
                  }, 
                ), 
          ), 
        ], 
      ), 
    ); 
  } 
}