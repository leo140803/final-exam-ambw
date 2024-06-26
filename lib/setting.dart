import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class PinSettingsScreen extends StatefulWidget {
  @override
  _PinSettingsScreenState createState() => _PinSettingsScreenState();
}

class _PinSettingsScreenState extends State<PinSettingsScreen> {
  String enteredPin = ""; // Holds the currently entered PIN
  String? newPin; // Holds the new PIN to be set
  bool isConfirming = false; // Flag to check if in confirmation mode
  bool isOldPinCorrect =
      false; // Flag to check if the entered old PIN is correct

  void _addPinNumber(String number) {
    if (enteredPin.length < 4) {
      // Limit the PIN length to 4 digits
      setState(() {
        enteredPin += number;
      });
    }
  }

  // Function to delete the last entered digit
  void _deleteLastEntry() {
    if (enteredPin.isNotEmpty) {
      setState(() {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1);
      });
    }
  }

  // Function to verify the old PIN against stored value
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
        enteredPin = ""; // Reset the entered PIN for another attempt
      });
    }
  }

  // Function to set or confirm the new PIN
  void _setNewPin() {
    if (newPin == null) {
      newPin = enteredPin;
      enteredPin = "";
      isConfirming = true;
      print("New PIN set, please confirm.");
    } else if (newPin == enteredPin) {
      Hive.box('settings').put('pin', enteredPin); // Update the stored PIN
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("PIN changed successfully")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PINs do not match, try again")));
      setState(() {
        enteredPin = "";
        isConfirming = false; // Reset confirmation status
      });
    }
  }

  // Function to handle the submission based on current state
  void _submitPin() {
    if (!isOldPinCorrect) {
      _verifyOldPin();
    } else {
      _setNewPin();
    }
  }

  // Helper function to build a numeric button for the PIN
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

  // Helper function to build the backspace button
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
                          minimumSize: Size(60, 60)),
                    ),
                  ),
                  _buildPinNumberButton("0"),
                  _buildBackspaceButton(),
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
