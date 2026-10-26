import 'package:flutter/material.dart'; 
import '../../../core/database/database_helper.dart'; 
import '../../../core/theme/app_colors.dart'; 
 
class CustomersScreen extends StatefulWidget { 
  const CustomersScreen({super.key}); 
  @override 
  State<CustomersScreen> createState() => _CustomersScreenState(); 
} 
 
class _CustomersScreenState extends State<CustomersScreen> { 
  List<Map<String, dynamic>> _customers = []; 
 
  @override 
  void initState() { super.initState(); _load(); } 
 
  Future<void> _load() async { 
    final data = await DatabaseHelper.instance.getCustomers(); 
    if (!mounted) return; 
    setState(() => _customers = data); 
  } 
 
  void _showAddDialog() { 
    final name = TextEditingController(); 
    final phone = TextEditingController(); 
    showDialog(context: context, builder: (_) => AlertDialog( 
      title: const Text('Add Customer'), 
      content: Column(mainAxisSize: MainAxisSize.min, children: [ 
        TextField(controller: name, decoration: const InputDecoration(hintText: 'Name')), 
        TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const 
InputDecoration(hintText: 'Phone')), 
      ]), 
      actions: [ 
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), 
        ElevatedButton(onPressed: () async { 
          if (name.text.isEmpty) return; 
          await DatabaseHelper.instance.insertCustomer({'name': name.text, 'phone': phone.text, 
'email': null, 'createdAt': DateTime.now().toIso8601String()}); 
          if (!mounted) return; 
          Navigator.pop(context); 
          _load(); 
        }, child: const Text('Save')), 
      ], 
    )); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: AppColors.background, 
      appBar: AppBar(title: const Text('Customers')), 
      floatingActionButton: FloatingActionButton(onPressed: _showAddDialog, child: const 
Icon(Icons.person_add)), 
      body: _customers.isEmpty ? const Center(child: Text('No customers yet')) : ListView.builder( 
        padding: const EdgeInsets.all(16), itemCount: _customers.length, 
        itemBuilder: (_, i) { 
          final c = _customers[i]; 
          return Card( 
            child: ListTile( 
              leading: CircleAvatar(child: Text(c['name'][0])), 
              title: Text(c['name']), 
              subtitle: Text(c['phone'] ?? 'No phone'), 
              trailing: IconButton(icon: const Icon(Icons.delete, color: AppColors.error), onPressed: () 
async { 
                await DatabaseHelper.instance.deleteCustomer(c['id']); 
                _load(); 
              }), 
            ), 
          ); 
        }, 
      ), 
    ); 
  } 
}