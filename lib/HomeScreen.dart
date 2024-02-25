
import 'package:flutter/material.dart';
import 'package:flutter_final_2/AnalyticsScreen.dart';
import 'package:flutter_final_2/FeedBack.dart';
import 'package:flutter_final_2/ClassesScreen.dart';
import 'package:flutter_final_2/DoubtSolvingScreen.dart';

import 'package:flutter_final_2/myaccount1.dart';
import 'package:flutter_final_2/LibraryScreen.dart';
import 'package:flutter_final_2/TestScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedClass = '';
  late String greeting;

  @override
  void initState() {
    super.initState();
    // Initialize the greeting
    greeting = _getGreeting();
  }

  String _getGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 18) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:const Color.fromARGB(255, 85, 0, 221),
        actions: [
          IconButton(
            icon:const Icon(Icons.class_outlined, color: Colors.white),
            onPressed: () {
              _showClassListPopup(context);
            },
          ),
        ],
        title: Row(
          children: [
           const Text(
              'Dashboard',
              style: TextStyle(
                  color: Colors.white, fontStyle: FontStyle.italic),
            ),
            const SizedBox(width: 8),
            if (selectedClass.isNotEmpty)
              Text(
                '- $selectedClass',
                style: const TextStyle(
                    color: Colors.white, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          color:const  Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.school,
                      color: Colors.deepPurple,
                      size: 32,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Learn',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              buildNavItem(Icons.home, 'Home', context),
              buildNavItem(Icons.assignment_turned_in, 'Test', context),
              buildNavItem(Icons.class_outlined, 'Classes', context),
              buildNavItem(Icons.library_books, 'Library', context),
              buildNavItem(Icons.analytics, 'Analytics', context),
              buildNavItem(Icons.help, 'Doubt Solving', context),
              buildNavItem(Icons.feed_outlined, 'Feedback', context),
              buildNavItem(Icons.account_circle, 'My Account', context),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 85, 0, 221),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(249),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const SizedBox(height: 20),
                  Text(
                    '$greeting!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                 const Text(
                    'Trending Now!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                 const  SizedBox(height: 10),
                  const Text(
                    'Discover what features your friends\n are loving the most!',
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
           const  SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  TrendingContainer(
                    gradientColors:const [
                      Color.fromARGB(255, 89, 0, 255),
                      Color.fromARGB(255, 152, 103, 243)
                    ],
                    title: '📊 Check your results',
                    subtitle:
                        'Prepare for upcoming tests with "Warm-up tests," offering precise analytics and practice\nquestions.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnalyticsScreen()),
                      );
                    },
                  ),
                 const SizedBox(width: 16),
                  TrendingContainer(
                    gradientColors:const [
                      Color(0xFF11998E),
                      Color(0xFF38EF7D)
                    ],
                    title: '📚 Attend your classes', // Updated line
                    subtitle:
                        'Prepare for classes with "Interactive sessions," featuring live classes and quizzes for effective learning.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ClassesScreen(cls: selectedClass)),
                      );
                    },
                  ),
                 const SizedBox(width: 16),
                  // Add more TrendingContainers here
                ],
              ),
            ),
           const SizedBox(height: 40),
           const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'REVISE NOW!',
                    style: TextStyle(
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              '  Revise your incorrectly answered & skipped questions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
           const  SizedBox(height: 1),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  QuizContainer(
                    gradientColors:const [
                      Color.fromARGB(255, 250, 187, 105),
                      Color(0xFFEF629F)
                    ],
                    title: ' Tests Attempted',
                    description: '                                   📝 23',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 7),
                  QuizContainer(
                    gradientColors:const [
                      Color.fromARGB(255, 165, 104, 243),
                      Color.fromARGB(255, 110, 25, 156)
                    ],
                    title: '📋Past Tests ',
                    description: 'Accuracy = 75%', // Removed textBoxText
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoubtSolvingScreen()),
                      );
                    },
                  ),
                 const SizedBox(width: 16),
                  // Add more QuizContainers here
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Reach out to us!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  AdditionalContainer(
                    gradientColors:const  [
                      Color(0xFF12C2E9),
                      Color(0xFFC471ED)
                    ],
                    title: 'Feedback',
                    buttonText: 'REACH OUT TO US VIA MAIL...',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HelpScreen()),
                      );
                    },
                  ),
                 const  SizedBox(width: 16),
                  // Add more AdditionalContainers here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(
      IconData icon, String text, BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.deepPurple,
        size: 28,
      ),
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            navigateToScreen(context, text);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        navigateToScreen(context, text);
      },
    );
  }

  Widget buildFeedbackNavItem(
      IconData icon, String text, BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.deepPurple,
        size: 28,
      ),
      title: Row(
        children: [
          Text(
            text,
            style:const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 10), // Adjust spacing as needed
          Container(
            padding:const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black), // Border color
              borderRadius: BorderRadius.circular(5),
            ),
            child:const Icon(
              Icons.mail,
              color: Colors.black, // Icon color
              size: 20,
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HelpScreen()),
        );
      },
    );
  }

  void navigateToScreen(BuildContext context, String text) {
    switch (text) {
      case 'Feedback':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HelpScreen()),
        );
        break;
      case 'Classes':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ClassesScreen(cls: selectedClass)),
        );
        break;
      case 'Library':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LibraryScreens()),
        );
        break;
      case 'Analytics':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AnalyticsScreen()),
        );
        break;
      case 'Test':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TestsScreen(cls2: selectedClass)),
        );
      case 'Doubt Solving':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoubtSolvingScreen()),
        );
        break;
      case 'My Account':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyAccountScreen()),
        );
        break;
    }
  }

  void _showClassListPopup(BuildContext context) {
    final classes = List.generate(10, (index) => 'Class ${index + 1}');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:const Text('Select a class'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: classes.map((className) {
                return ListTile(
                  title: Text(className),
                  onTap: () {
                    setState(() {
                      selectedClass = className;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class TrendingContainer extends StatelessWidget {
  final List<Color> gradientColors;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const TrendingContainer({super.key, 
    required this.gradientColors,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 170,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset:const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style:const TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.left,
                style:const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizContainer extends StatelessWidget {
  final List<Color> gradientColors;
  final String title;
  final String description;
  final VoidCallback onTap;

  const QuizContainer({super.key, 
    required this.gradientColors,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin:const EdgeInsets.only(right: 16),
          width: 180,
          height: 145, // Decreased height
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset:const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style:const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.left,
                  style:const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
       const SizedBox(height: 10),
      ],
    );
  }
}

class AdditionalContainer extends StatelessWidget {
  final List<Color> gradientColors;
  final String title;
  final String buttonText;
  final VoidCallback onTap;

  const AdditionalContainer({super.key, 
    required this.gradientColors,
    required this.title,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:const EdgeInsets.only(right: 16),
        width: 380,
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset:const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style:const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
             const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black), // Border color
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.mail,
                    color: Colors.black, // Icon color
                  ),
                  const SizedBox(width: 8),
                  Text(
                    buttonText,
                    style:const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}