import 'package:flutter/material.dart'; 
import '../../../core/theme/app_colors.dart'; 
 
class SettingsScreen extends StatelessWidget { 
  const SettingsScreen({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: AppColors.background, 
      appBar: AppBar(title: const Text('Settings')), 
      body: ListView( 
        padding: const EdgeInsets.all(16), 
        children: [ 
          const ListTile( 
            leading: CircleAvatar(child: Icon(Icons.person)), 
            title: Text('Business Owner'), 
            subtitle: Text('owner@business.com'), 
            trailing: Icon(Icons.chevron_right), 
          ), 
          const Divider(), 
          ListTile( 
            leading: const Icon(Icons.store, color: AppColors.primary), 
            title: const Text('Business Profile'), 
            onTap: () {}, 
          ), 
          ListTile( 
            leading: const Icon(Icons.payment, color: AppColors.primary), 
            title: const Text('Payment Settings'), 
            onTap: () {}, 
          ), 
          ListTile( 
            leading: const Icon(Icons.security, color: AppColors.primary), 
            title: const Text('Security & Privacy'), 
            onTap: () {}, 
          ), 
          const Divider(), 
          const ListTile( 
            leading: Icon(Icons.info_outline), 
            title: Text('App Version'), 
            trailing: Text('1.0.0'), 
          ), 
        ], 
      ), 
); 
} 
}