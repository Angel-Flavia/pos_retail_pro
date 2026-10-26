import 'package:flutter/material.dart'; 
import 'package:intl/intl.dart'; 
import '../../../core/database/database_helper.dart'; 
import '../../../core/theme/app_colors.dart'; 
 
class InventoryScreen extends StatefulWidget { 
  const InventoryScreen({super.key}); 
  @override 
  State<InventoryScreen> createState() => _InventoryScreenState(); 
} 
 
class _InventoryScreenState extends State<InventoryScreen> { 
  List<Map<String, dynamic>> _products = []; 
  String _search = ''; 
 
  @override 
  void initState() { super.initState(); _load(); } 
 
  Future<void> _load() async { 
    final data = await DatabaseHelper.instance.getProducts(); 
    if (!mounted) return; 
    setState(() => _products = data); 
  } 
 
  void _showAddDialog() { 
    final name = TextEditingController(); 
    final price = TextEditingController(); 
    final stock = TextEditingController(); 
    showDialog(context: context, builder: (_) => AlertDialog( 
      title: const Text('Add Product'), 
      content: Column(mainAxisSize: MainAxisSize.min, children: [ 
        TextField(controller: name, decoration: const InputDecoration(hintText: 'Name')), 
        TextField(controller: price, keyboardType: TextInputType.number, decoration: const 
InputDecoration(hintText: 'Price')), 
        TextField(controller: stock, keyboardType: TextInputType.number, decoration: const 
InputDecoration(hintText: 'Stock')), 
      ]), 
      actions: [ 
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), 
        ElevatedButton(onPressed: () async { 
          if (name.text.isEmpty) return; 
          await DatabaseHelper.instance.insertProduct({'name': name.text, 'category': 'General', 
'price': double.tryParse(price.text) ?? 0, 'stock': int.tryParse(stock.text) ?? 0}); 
          if (!mounted) return; 
          Navigator.pop(context); 
          _load(); 
        }, child: const Text('Save')), 
      ], 
    )); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final fmt = NumberFormat('#,###', 'en'); 
    final filtered = _products.where((p) => 
p['name'].toString().toLowerCase().contains(_search.toLowerCase())).toList(); 
    return Scaffold( 
      backgroundColor: AppColors.background, 
      appBar: AppBar(title: const Text('Inventory')), 
      floatingActionButton: FloatingActionButton(onPressed: _showAddDialog, child: const 
Icon(Icons.add)), 
      body: Column(children: [ 
        Padding(padding: const EdgeInsets.all(16), child: TextField(decoration: const 
InputDecoration(hintText: 'Search...', prefixIcon: Icon(Icons.search)), onChanged: (v) => 
setState(() => _search = v))), 
        Expanded(child: filtered.isEmpty ? const Center(child: Text('No products')) : 
ListView.builder( 
          padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: filtered.length, 
          itemBuilder: (_, i) { 
            final p = filtered[i]; 
            return Card( 
              margin: const EdgeInsets.only(bottom: 8), 
              child: ListTile( 
                title: Text(p['name']), 
                subtitle: Text('Stock: ${p['stock']}'), 
                trailing: Text('UGX ${fmt.format(p['price'])}', style: const TextStyle(fontWeight: 
FontWeight.bold)), 
              ), 
            ); 
          }, 
        )), 
      ]), 
    ); 
  } 
}