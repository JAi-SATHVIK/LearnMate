import 'package:flutter/material.dart';
import 'package:flutter_final_2/Gemini/BotScreen.dart';


class DoubtSolvingScreen extends StatefulWidget {
  @override
  _DoubtSolvingScreenState createState() => _DoubtSolvingScreenState();
}

class _DoubtSolvingScreenState extends State<DoubtSolvingScreen> {
  @override
  void initState() {
    super.initState();
    navigateToBotScreen();
  }

  void navigateToBotScreen() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    });
  }

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Center(
        child: Text('Error! Please try again.'),
      ),
    );
  }
}
