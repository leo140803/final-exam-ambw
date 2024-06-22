import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PinSettingsScreen extends StatefulWidget {
  @override
  _PinSettingsScreenState createState() => _PinSettingsScreenState();
}

class _PinSettingsScreenState extends State<PinSettingsScreen> {
  String enteredPin = "";
  String? newPin;
  bool isConfirming = false;
  bool isOldPinCorrect = false;

  void _addPinNumber(String number) {
    if (enteredPin.length < 4) {
      setState(() {
        enteredPin += number;
      });
      print("Current PIN Entry: $enteredPin");
    }
  }

  void _deleteLastEntry() {
    if (enteredPin.isNotEmpty) {
      setState(() {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1);
      });
    }
  }

  void _verifyOldPin() {
    var box = Hive.box('settings');
    String currentPin = box.get('pin', defaultValue: '');
    if (enteredPin == currentPin) {
      print("Old PIN correct, setting new PIN.");
      setState(() {
        isOldPinCorrect = true;
        enteredPin = "";
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Incorrect old PIN")));
      setState(() {
        enteredPin = ""; // Ensure we reset this for re-entry
      });
    }
  }

  void _setNewPin() {
    if (newPin == null) {
      setState(() {
        newPin = enteredPin;
        enteredPin = "";
        isConfirming = true;
      });

      print("New PIN set, please confirm.");
    } else if (newPin == enteredPin) {
      Hive.box('settings').put('pin', enteredPin);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("PIN changed successfully")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PINs do not match, try again")));
      setState(() {
        enteredPin = "";
        isConfirming = true;
      });
    }
  }

  void _submitPin() {
    if (!isOldPinCorrect) {
      _verifyOldPin();
    } else if (!isConfirming) {
      _setNewPin();
    } else {
      _setNewPin();
    }
  }

  Widget _buildPinNumberButton(String number) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () => _addPinNumber(number),
        child:
            Text(number, style: TextStyle(fontSize: 24, color: Colors.black)),
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[300],
          shape: CircleBorder(),
          padding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: _deleteLastEntry,
        child: Icon(Icons.backspace, color: Colors.black),
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[300],
          shape: CircleBorder(),
          padding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
            isConfirming
                ? "Confirm New PIN"
                : isOldPinCorrect
                    ? "Set New PIN"
                    : "Enter Old PIN",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                isOldPinCorrect
                    ? (isConfirming ? "Confirm New PIN" : "Enter New PIN")
                    : "Enter Old PIN",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '●' * enteredPin.length,
                style: TextStyle(fontSize: 50, letterSpacing: 5),
              ),
              SizedBox(height: 20),
              for (var row in [
                ["1", "2", "3"],
                ["4", "5", "6"],
                ["7", "8", "9"],
              ])
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((e) => _buildPinNumberButton(e)).toList(),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () {},
                      child: Text("",
                          style: TextStyle(fontSize: 24, color: Colors.black)),
                      style: TextButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white,
                          minimumSize:
                              Size(60, 60) // Adjust the size as necessary
                          ),
                    ),
                  ),
                  _buildPinNumberButton("0"),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: _deleteLastEntry,
                      child:
                          Icon(Icons.backspace, size: 20, color: Colors.black),
                      style: TextButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.grey[300],
                          minimumSize: Size(60, 60)),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: _submitPin,
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
