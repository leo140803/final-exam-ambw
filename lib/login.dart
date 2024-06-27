import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'package:hive/hive.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _confirmPin;  // Variable untuk menyimpan PIN konfirmasi selama setup
  bool isSetup = false;  // Status apakah user perlu setup PIN
  String enteredPin = "";  // String untuk menyimpan PIN yang dimasukkan user

  @override
  void initState() {
    super.initState();
    _checkPinSetup();  // Memeriksa apakah PIN sudah disetup
  }

  // Fungsi untuk memeriksa apakah PIN sudah disetup
  void _checkPinSetup() async {
    var box = Hive.box('settings');  // Buka kotak Hive untuk pengaturan
    if (box.get('pin') == null) {
      setState(() {
        isSetup = true;  // Jika tidak ada PIN, set isSetup menjadi true
      });
    }
  }

  // Fungsi untuk login atau setup PIN
  void _login() async {
    var box = Hive.box('settings');
    if (isSetup) {
      if (_confirmPin == null) {
        _confirmPin = enteredPin;  // Jika belum ada konfirmasi PIN, simpan PIN pertama
        setState(() {
          enteredPin = "";
        });
      } else {
        if (_confirmPin == enteredPin) {
          box.put('pin', enteredPin);  // Jika PIN cocok, simpan ke database
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));  // Navigasi ke HomeScreen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('PINs do not match, try again')));  // Jika tidak cocok, tampilkan pesan error
          setState(() {
            // _confirmPin = null;
            enteredPin = "";
          });
          
        }
      }
    } else {
      if (box.get('pin') == enteredPin) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));  // Jika PIN benar, navigasi ke HomeScreen
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Incorrect PIN')));  // Jika salah, tampilkan pesan error
      }
    }
  }

  // Fungsi untuk menambahkan angka ke PIN yang dimasukkan
  void _addPinNumber(String number) {
    if (enteredPin.length < 4) {  // Batasi jumlah digit PIN sampai 4
      setState(() {
        enteredPin += number;  // Tambahkan angka ke enteredPin
      });
    }
  }

  // Fungsi untuk menghapus digit terakhir dari PIN
  void _deleteLastEntry() {
    if (enteredPin.isNotEmpty) {
      setState(() {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1);  // Hapus digit terakhir
      });
    }
  }

  // Fungsi untuk membangun tombol angka PIN
  Widget _buildPinNumberButton(String number) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextButton(
        onPressed: () => _addPinNumber(number),
        child: Text(number, style: TextStyle(fontSize: 24, color: Colors.black)),
        style: TextButton.styleFrom(
            shape: CircleBorder(),
            backgroundColor: Colors.grey[300],
            minimumSize: Size(60, 60)
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
          isSetup ? 'Set PIN' : 'Login',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  isSetup && _confirmPin != null ? 'Confirm PIN' : 'Enter PIN',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '●' * enteredPin.length,
                style: TextStyle(fontSize: 35, letterSpacing: 5),
              ),
              SizedBox(height: 20),
              for (var row in [
                [1, 2, 3],
                [4, 5, 6],
                [7, 8, 9]
              ])
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row
                      .map((e) => _buildPinNumberButton(e.toString()))
                      .toList(),
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
                              Size(60, 60)
                          ),
                    ),
                  ),
                  _buildPinNumberButton("0"),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: _deleteLastEntry,
                      child: Icon(Icons.backspace, size: 20, color: Colors.black),
                      style: TextButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.grey[300],
                          minimumSize: Size(60, 60)),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text('Enter', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
