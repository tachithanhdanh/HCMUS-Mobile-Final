// views/settings_page.dart
import 'package:flutter/material.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsViewModel _viewModel = SettingsViewModel();
  bool _notificationsEnabled = true;
  String _language = 'en';

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    _viewModel.updateNotifications(value);
  }

  void _changeLanguage(String? languageCode) {
    if (languageCode != null) {
      setState(() {
        _language = languageCode;
      });
      _viewModel.updateLanguage(languageCode);
    }
  }

  void _logout() {
    _viewModel.logout();
    Navigator.pushReplacementNamed(context, '/login_signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          ListTile(
            title: Text('Language'),
            trailing: DropdownButton<String>(
              value: _language,
              items: [
                DropdownMenuItem(child: Text('English'), value: 'en'),
                DropdownMenuItem(child: Text('Vietnamese'), value: 'vi'),
                // Thêm ngôn ngữ khác nếu cần
              ],
              onChanged: _changeLanguage,
            ),
          ),
          ListTile(
            title: Text('Privacy Policy'),
            onTap: () {
              // Điều hướng đến Privacy Policy
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
