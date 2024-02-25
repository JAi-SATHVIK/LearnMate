import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_final_2/HomeScreen.dart';
import 'package:flutter_final_2/CreateAccountScreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ignore: prefer_final_fields
  TextEditingController _emailController = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _passwordController = TextEditingController();

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

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        return user;
      }
    } catch (error) {
      // ignore: avoid_print
      print('Google sign-in error: $error');
    }
    return null;
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to HomeScreen after successful sign-in
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } catch (error) {
      // ignore: avoid_print
      print('Failed to sign in with Email & Password: $error');
      // Handle sign-in failure
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to sign in. Please check your email and password.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button
        title:const Text(
          'LEARN MATE...',
          style: TextStyle(fontStyle: FontStyle.normal,
           fontWeight: FontWeight.bold,
           fontSize: 40,
           color: Colors.white),
           
        ),
        centerTitle: true,
        backgroundColor:const Color.fromARGB(255, 85, 0, 221),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentUser != null) // Check if user is logged in
              Text(
                'Welcome, ${_currentUser!.email}',
                style:const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration:const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email, 
                color: Color.fromARGB(255, 85, 0, 221)),
              ),
            ),
           const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration:const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock,color: Color.fromARGB(255, 85, 0, 221)),
              ),
              obscureText: true,
            ),
           const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _signInWithEmailAndPassword(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor:const Color.fromARGB(255, 85, 0, 221),
                    padding:const EdgeInsets.symmetric(vertical: 15, horizontal: 55),
                  ),
                  child:const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateAccountScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor:const Color.fromARGB(255, 85, 0, 221),
                    padding:const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  child:const Text(
                    'Create account',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                User? user = await _signInWithGoogle();
                if (user == null) {
                  // Handle sign-in failure
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                    content: Text('Failed to sign in with Google.'),
                  )
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor:const Color.fromARGB(255, 85, 0, 221),
                padding:const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle),
                  SizedBox(width: 10),
                  Text('Sign in with Google'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}