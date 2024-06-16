import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PinSettingsScreen extends StatefulWidget {
  @override
  _PinSettingsScreenState createState() => _PinSettingsScreenState();
}

class _PinSettingsScreenState extends State<PinSettingsScreen> {
  TextEditingController _oldPinController = TextEditingController();
  TextEditingController _newPinController = TextEditingController();
  TextEditingController _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _changePin() async {
    if (_formKey.currentState!.validate()) {
      var box = Hive.box('settings');
      String currentPin = box.get('pin', defaultValue: '');
      if (_oldPinController.text == currentPin) {
        if (_newPinController.text == _confirmPinController.text) {
          await box.put('pin', _newPinController.text);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("PIN changed successfully")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("New PIN does not match")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Incorrect old PIN")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change PIN"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _oldPinController,
                decoration: InputDecoration(labelText: 'Enter your old PIN'),
                obscureText: true,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old PIN';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newPinController,
                decoration: InputDecoration(labelText: 'Enter a new PIN'),
                obscureText: true,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new PIN';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPinController,
                decoration: InputDecoration(labelText: 'Confirm your new PIN'),
                obscureText: true,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new PIN';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePin,
                child: Text(
                  'Change PIN',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }
}
