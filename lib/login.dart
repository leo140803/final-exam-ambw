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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Incorrect PIN'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:
            Colors.white,
        elevation: 0,
        title: Text(
          isSetup ? 'Set PIN' : 'Login',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),

          SizedBox(height: 20),
          Image.asset(
            'lib/assets/logo.png', 
            height: 200, 
          ),
          SizedBox(height: 40),
          TextField(
            cursorColor: Colors.black,
            controller: _pinController,
            decoration: InputDecoration(
              labelText: 'Enter Pin',
              labelStyle: TextStyle(
                  color:
                      Colors.black), 
              enabledBorder: OutlineInputBorder(
                // Normal state border
                borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.0), 
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                // Border when TextField is selected
                borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.0), 
                borderRadius: BorderRadius.circular(30.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide:
                    BorderSide(color: Colors.black, width: 2.0), 
              ),
            ),
            obscureText: true,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 18,
              color: Colors
                  .black, 
            ),
          ),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _login,
            child: Text(
              isSetup ? 'Set PIN' : 'Login',
              style: TextStyle(color: Colors.white), 
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    30.0), 
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 50, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
