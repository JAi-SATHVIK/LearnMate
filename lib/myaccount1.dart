import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_final_2/signin.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // ignore: unused_field
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = _auth.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  // ignore: unused_element
  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      setState(() {
        _currentUser = null;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          'My Account',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon:const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white, // Set color to white
        ),
        backgroundColor:const Color.fromARGB(255, 73, 1, 198),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_currentUser != null) ...[
              _buildInfoItem('Email: ${_currentUser!.email}',
                  hasBottomBorder: true),
              _buildInfoItem('User UID: ${_currentUser!.uid}',
                  hasBottomBorder: true),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red,
                    padding:const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  child:const Text(
                    'Logout',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text, {required bool hasBottomBorder}) {
    return Container(
      padding:const EdgeInsets.all(10),
      margin:const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: hasBottomBorder
              ? const BorderSide(color: Colors.grey)
              : BorderSide.none,
        ),
      ),
      child: Text(
        text,
        style:const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
