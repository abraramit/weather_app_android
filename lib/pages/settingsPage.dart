import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/helper_function.dart';
import 'package:weather_app/weather_provider.dart';

class Settingspage extends StatefulWidget {
  static const String routeName = '/SettingsPage';

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  bool _isChecked = false;

  @override
  void initState() {
    getTempStatus().then((value) {
      setState(() {
        _isChecked = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView(
        children: [
          Consumer<WeatherProvider>(
            builder:(context, provider, _) => SwitchListTile(
              activeColor: Colors.orangeAccent,
              title: const Text('Show temperature in Fahrenheit'),
              subtitle: const Text(
                'Default is Celsius, If you turn on then it will show temperature in Fahrenheit',
              ),
              value: _isChecked,
              onChanged: (value) async{
                setState(() {
                  _isChecked = value;
                });
                await setTempStatus(value);
                provider.reload();
              },
            ),
          ),
        ],
      ),
    );
  }
}
