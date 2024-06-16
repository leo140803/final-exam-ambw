import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'package:hive/hive.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool isSetup = false;

  @override
  void initState() {
    super.initState();
    _checkPinSetup();
  }

  void _checkPinSetup() async {
    var box = Hive.box('settings');
    if (box.get('pin') == null) {
      setState(() {
        isSetup = true;
      });
    }
  }

  void _login() async {
    var box = Hive.box('settings');
    if (isSetup) {
      box.put('pin', _pinController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      // Check PIN
      if (box.get('pin') == _pinController.text) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Incorrect PIN')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSetup ? 'Set PIN' : 'Enter PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _pinController,
              decoration: InputDecoration(labelText: 'PIN'),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text(isSetup ? 'Set PIN' : 'Login'),
            ),
          ],
        ),
      ),
    );
  }
}
