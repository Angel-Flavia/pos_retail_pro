import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:intl/intl.dart'; 
import 'package:uuid/uuid.dart'; 
import '../../../core/database/database_helper.dart'; 
import '../../../core/services/location_service.dart'; 
import '../../../core/theme/app_colors.dart'; 
 
class NewSaleScreen extends StatefulWidget { 
  const NewSaleScreen({super.key}); 
  @override 
  State<NewSaleScreen> createState() => _NewSaleScreenState(); 
} 
 
class _NewSaleScreenState extends State<NewSaleScreen> { 
  List<Map<String, dynamic>> _products = []; 
  final Map<int, int> _cart = {}; 
  bool _processing = false; 
 
  @override 
  void initState() { super.initState(); _load(); } 
 
  Future<void> _load() async { 
    final data = await DatabaseHelper.instance.getProducts(); 
    if (!mounted) return; 
    setState(() => _products = data); 
  } 
 
  double get _subtotal { 
    double t = 0; 
    _cart.forEach((id, qty) { 
      final p = _products.firstWhere((e) => e['id'] == id); 
      t += (p['price'] as num) * qty; 
    }); 
    return t; 
  } 
 
  Future<void> _checkout() async { 
    if (_cart.isEmpty || _processing) return; 
    setState(() => _processing = true); 
    final loc = await LocationService.getCurrentLocation(); 
    final sub = _subtotal; 
    final tax = sub * 0.18; 
    final total = sub + tax; 
     
    final items = _cart.entries.map((e) { 
      final p = _products.firstWhere((x) => x['id'] == e.key); 
      return {'id': p['id'], 'name': p['name'], 'price': p['price'], 'qty': e.value}; 
    }).toList(); 
 
    await DatabaseHelper.instance.insertSale({ 
      'uuid': const Uuid().v4(), 'total': total, 'tax': tax, 'subtotal': sub, 
      'paymentMethod': 'Cash', 'items': items.toString(), 
      'createdAt': DateTime.now().toIso8601String(), 
      'latitude': loc?.latitude, 'longitude': loc?.longitude, 'isSynced': 0, 
    }); 
 
    for (var e in _cart.entries) { await DatabaseHelper.instance.decreaseStock(e.key, e.value); } 
     
    if (!mounted) return; 
    ScaffoldMessenger.of(context).showSnackBar( 
      const SnackBar(content: Text('Sale Complete!'), backgroundColor: AppColors.success) 
    ); 
    context.pop(); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final fmt = NumberFormat('#,###', 'en'); 
    return Scaffold( 
      appBar: AppBar(title: const Text('New Sale')), 
      body: Row(children: [ 
        Expanded(flex: 3, child: ListView.builder( 
          padding: const EdgeInsets.all(16), itemCount: _products.length, 
          itemBuilder: (_, i) { 
            final p = _products[i]; 
            return Card( 
              child: ListTile( 
                title: Text(p['name']), 
                subtitle: Text('UGX ${fmt.format(p['price'])}'), 
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [ 
                  IconButton( 
                    icon: const Icon(Icons.remove_circle_outline),  
                    onPressed: () => setState(() {  
                      if (_cart.containsKey(p['id'])) {  
                        _cart[p['id']] = _cart[p['id']]! - 1;  
                        if (_cart[p['id']] == 0) _cart.remove(p['id']);  
                      }  
                    }) 
                  ), 
                  Text('${_cart[p['id']] ?? 0}'), 
                  IconButton( 
                    icon: const Icon(Icons.add_circle_outline),  
                    onPressed: () => setState(() {  
                      if ((p['stock'] as int) > (_cart[p['id']] ?? 0)) {  
                        _cart[p['id']] = (_cart[p['id']] ?? 0) + 1;  
                      }  
                    }) 
                  ), 
                ]), 
              ), 
            ); 
          }, 
        )), 
        Container( 
          width: 250, color: Colors.white, padding: const EdgeInsets.all(16), 
          child: Column(children: [ 
            const Text('Cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), 
            const Divider(), 
            Expanded(child: ListView(children: _cart.entries.map((e) {  
              final p = _products.firstWhere((x) => x['id'] == e.key);  
              return Text('${e.value}x ${p['name']}');  
            }).toList())), 
            const Divider(), 
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ 
              const Text('Subtotal:'),  
              Text('UGX ${fmt.format(_subtotal)}') 
            ]), 
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ 
              const Text('Tax (18%):'),  
              Text('UGX ${fmt.format(_subtotal * 0.18)}') 
            ]), 
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ 
              const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),  
              Text('UGX ${fmt.format(_subtotal * 1.18)}', style: const TextStyle(fontWeight: 
FontWeight.bold, color: AppColors.primary)) 
            ]), 
            const SizedBox(height: 16), 
            ElevatedButton( 
              onPressed: _cart.isEmpty || _processing ? null : _checkout, 
              child: _processing ? const CircularProgressIndicator(color: Colors.white) : const 
Text('Complete Sale'), 
            ), 
          ]), 
        ), 
      ]), 
    ); 
  } 
}