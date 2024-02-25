import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomeScreen.dart';

class TestsScreen extends StatelessWidget {
  final String cls2;

  TestsScreen({super.key, required this.cls2});

  final Map<String, Map<String, List<String>>> data = {
    'Class 1': {
      'Mathematics': [
        'Shapes and Space',
        'Numbers from One to Nine',
        // Other chapters
      ],
      'Environmental Studies': [
        'My Family',
        'I Am Lucky!',
        // Other chapters
      ],
    },
    'Class 2': {
      'Mathematics': [
        'What Is Long, What Is Round?',
        'Counting in Groups',
        // Other chapters
      ],
      'Environmental Studies': [
        'Super Senses',
        'A Snake Charmer’s Story',
        // Other chapters
      ],
    },
    'Class 8': {
    'Science': [
      'Chapter 1: Crop Production and Management',
      'Chapter 2: Microorganisms: Friend and Foe',
      'Chapter 3: Combustion and Flame',
      'Chapter 4: Conservation of Plants and Animals',
      'Chapter 5: Reproduction in Animals',
      'Chapter 6: Reaching the Age of Adolescence',
      'Chapter 7: Force and Pressure',
      'Chapter 8: Friction',
      'Chapter 9: Sound',
      'Chapter 10: Chemical Effects of Electric Current',
      'Chapter 11: Some Natural Phenomena',
      'Chapter 12: Light',
    ],
    'Mathematics': [
      'Chapter 1: Rational Numbers',
      'Chapter 2: Linear Equations in One Variable',
      'Chapter 3: Understanding Quadrilaterals',
      'Chapter 4: Practical Geometry',
      'Chapter 5: Data Handling',
      'Chapter 6: Squares and Square Roots',
      'Chapter 7: Cubes and Cube Roots',
      'Chapter 8: Comparing Quantities',
      'Chapter 9: Algebraic Expressions and Identities',
      'Chapter 10: Visualising Solid Shapes',
      'Chapter 11: Mensuration',
      'Chapter 12: Exponents and Powers',
      'Chapter 13: Direct and Inverse Proportions',
      'Chapter 14: Factorisation',
    ],
    'Social Science': [
      'Chapter 1: Introduction to Political Science',
      'Chapter 2: Introduction to Public Administration',
      'Chapter 3: Introduction to Public Policy',
      'Chapter 4: Introduction to International Relations',
      'Chapter 5: Introduction to Economics',
    ]
  },

  };

  @override
  Widget build(BuildContext context) {
    final subjects = data[cls2] ?? {};
    return SubjectScreen(cls: cls2, subjects: subjects);
  }
}

class SubjectScreen extends StatelessWidget {
  final String cls;
  final Map<String, List<String>> subjects;

  const SubjectScreen({super.key, required this.cls, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$cls Subjects',
          style: const TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
        backgroundColor:
            const Color.fromARGB(255, 56, 34, 216), // Set app bar color
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the icon (back button) color to white
        ),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          String subject = subjects.keys.elementAt(index);
          List<String> chapters = subjects[subject] ?? [];
          return Card(
            elevation: 4, // Add elevation for card effect
            margin: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 16), // Add margin
            child: ListTile(
              title: Text(
                subject,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing:
                  const Icon(Icons.arrow_forward), // Add trailing arrow icon
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChapterScreen(
                      cls2: cls,
                      subjectName: subject,
                      chapters: chapters,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ChapterScreen extends StatelessWidget {
  final String cls2;
  final String subjectName;
  final List<String> chapters;

  const ChapterScreen({
    super.key,
    required this.cls2,
    required this.subjectName,
    required this.chapters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$cls2 - $subjectName',
          style: const TextStyle(color: Colors.white), // Text color
        ),
        backgroundColor:
            const Color.fromARGB(255, 85, 0, 221), // AppBar background color
        iconTheme:
            const IconThemeData(color: Colors.white), // Back button color
        shadowColor: Colors.yellow,
      ),
      body: ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          String chapterName = chapters[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        cls2: cls2,
                        subjectName: subjectName,
                        chapterName: chapterName,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.assignment,
                          color: Color.fromARGB(255, 59, 22, 207), size: 32.0),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Chapter ${index + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              chapterName,
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Material(
                        elevation: 4.0, // Elevation of "Attempt Now" text
                        borderRadius: BorderRadius.circular(12.0),
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Attempt Now",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 47, 23, 228)),
                              ),
                            ),
                            Icon(Icons.arrow_forward,
                                color: Color.fromARGB(255, 47, 23, 228)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String cls2;
  final String subjectName;
  final String chapterName;

  const QuizScreen({
    super.key,
    required this.cls2,
    required this.subjectName,
    required this.chapterName,
  });

  @override
  // ignore: library_private_types_in_public_api
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;

 List<Map<String, dynamic>> questions = [
  {
    'question': 'Which of the following activities is NOT a part of crop production?',
    'options': ['Harvesting', 'Weeding', 'Sowing', 'Baking'],
    'correctAnswer': 'Baking',
    'userAnswer': '',
  },
  {
    'question': 'What is the process of loosening and turning of soil called?',
    'options': ['Ploughing', 'Irrigation', 'Harvesting', 'Weeding'],
    'correctAnswer': 'Ploughing',
    'userAnswer': '',
  },
  {
    'question': 'Which nutrient is essential for the healthy growth of plants and is found in fertilizers?',
    'options': ['Oxygen', 'Nitrogen', 'Carbon dioxide', 'Hydrogen'],
    'correctAnswer': 'Nitrogen',
    'userAnswer': '',
  },
  {
    'question': 'Which method of irrigation involves supplying water directly to the roots of plants drop by drop?',
    'options': ['Drip irrigation', 'Sprinkler irrigation', 'Flooding', 'Furrow irrigation'],
    'correctAnswer': 'Drip irrigation',
    'userAnswer': '',
  },
  {
    'question': 'Which of the following is NOT a chemical method of controlling pests?',
    'options': ['Using insecticides', 'Using fungicides', 'Using neem leaves', 'Using pesticides'],
    'correctAnswer': 'Using neem leaves',
    'userAnswer': '',
  },
  {
    'question': 'What is the process of separating the grain from the harvested crop called?',
    'options': ['Weeding', 'Threshing', 'Harvesting', 'Sowing'],
    'correctAnswer': 'Threshing',
    'userAnswer': '',
  },
  {
    'question': 'Which of the following is a storage structure used for keeping grains safe from pests and moisture?',
    'options': ['Silo', 'Greenhouse', 'Shed', 'Field'],
    'correctAnswer': 'Silo',
    'userAnswer': '',
  },
  {
    'question': 'What is the term for the removal of weeds from the fields?',
    'options': ['Harvesting', 'Threshing', 'Weeding', 'Sowing'],
    'correctAnswer': 'Weeding',
    'userAnswer': '',
  },
  {
    'question': 'Which nutrient is added to the soil through the process of green manuring?',
    'options': ['Nitrogen', 'Phosphorus', 'Potassium', 'Calcium'],
    'correctAnswer': 'Nitrogen',
    'userAnswer': '',
  },
  {
    'question': 'Which of the following is NOT a method of protecting crops from pests and diseases?',
    'options': ['Crop rotation', 'Intercropping', 'Mulching', 'Overgrazing'],
    'correctAnswer': 'Overgrazing',
    'userAnswer': '',
  },
];

  void checkAnswer(String selectedAnswer) {
    if (selectedAnswer == questions[currentQuestionIndex]['correctAnswer']) {
      correctAnswers++;
    } else {
      wrongAnswers++;
    }
    questions[currentQuestionIndex]['userAnswer'] = selectedAnswer;
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResult(
            correctAnswers: correctAnswers,
            wrongAnswers: wrongAnswers,
            questions: questions,
            startTime: DateTime.now(),
            endTime: DateTime.now(),
            subjectName: widget.subjectName,
            chapterName: widget.chapterName,
          ),
        ),
      );
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('${widget.subjectName} - ${widget.chapterName}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            )),
        backgroundColor: const Color.fromARGB(255, 85, 0, 221),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20), // Add space above the "Question"
            Text(
              'Question ${currentQuestionIndex + 1}:',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16), // Add space below the "Question"
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            questions[currentQuestionIndex]['question']
                                as String,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: (questions[currentQuestionIndex]
                                    ['options'] as List<String>)
                                .map((option) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    checkAnswer(option);
                                    nextQuestion();
                                  },
                                  // ignore: sort_child_properties_last
                                  child: Text(option),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    backgroundColor:
                                        const Color.fromARGB(255, 93, 93, 93),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: currentQuestionIndex > 0 ? previousQuestion : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 85, 0, 221),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: const Size(150, 50),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: currentQuestionIndex < questions.length - 1
                      ? nextQuestion
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 85, 0, 221),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: const Size(150, 50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 80.0, right: 1.0),
        child: SizedBox(
          width: 100,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizResult(
                    correctAnswers: correctAnswers,
                    wrongAnswers: wrongAnswers,
                    questions: questions,
                    startTime: DateTime.now(),
                    endTime: DateTime.now(),
                    subjectName: widget.subjectName,
                    chapterName: widget.chapterName,
                  ),
                ),
              );
            },
            label:
                const Text('End Quiz', style: TextStyle(color: Colors.white)),
            backgroundColor: const Color.fromARGB(255, 85, 0, 221),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}

// ignore: must_be_immutable
class QuizResult extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
  final List<Map<String, dynamic>> questions;
  final DateTime startTime;
  final DateTime endTime;
  final String subjectName;
  final String chapterName;
  // ignore: prefer_typing_uninitialized_variables
  var numberOfTests; //////////////////////////////////////////

  QuizResult({
    super.key,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.questions,
    required this.startTime,
    required this.endTime,
    required this.subjectName,
    required this.chapterName,
  });

  @override
  Widget build(BuildContext context) {
    int totalQuestions = questions.length;
    int unattemptedQuestions = totalQuestions - (correctAnswers + wrongAnswers);

    double accuracy = (correctAnswers / totalQuestions) * 100;
    // ignore: unused_local_variable
    Duration timeTaken = endTime.difference(startTime);

    // Save quiz results to Firebase
    FirebaseFirestore.instance.collection('quizResults').add({
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'unattemptedQuestions': unattemptedQuestions,
      'accuracy': accuracy,
      'startTime': startTime,
      'endTime': endTime,
      'subjectName': subjectName,
      'chapterName': chapterName,
    }).then((value) {
      // ignore: avoid_print
      print("Quiz result saved successfully!");
    }).catchError((error) {
      // ignore: avoid_print
      print("Failed to save quiz result: $error");
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Result',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: const Color.fromARGB(255, 85, 0, 221),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // ignore: sized_box_for_whitespace
            Container(
              height: 20,
              child: const Row(),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Questions: $totalQuestions',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 1),
            Text(
              'Correct Answers: $correctAnswers / $totalQuestions',
              style: const TextStyle(fontSize: 18, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            Text(
              'Wrong Answers: $wrongAnswers / $totalQuestions',
              style: const TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            Text(
              'Unattempted Questions: $unattemptedQuestions / $totalQuestions',
              style: const TextStyle(
                  fontSize: 18, color: Color.fromARGB(255, 255, 128, 0)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Bullet(color: Colors.green),
                SizedBox(width: 8),
                Text('Correct'),
                SizedBox(width: 16),
                Bullet(color: Colors.red),
                SizedBox(width: 8),
                Text('Wrong'),
                SizedBox(width: 16),
                Bullet(color: Color.fromARGB(255, 255, 128, 0)),
                SizedBox(width: 8),
                Text('Unattempted'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(questions.length, (index) {
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Question ${index + 1}: ${questions[index]['question']}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: (questions[index]['options']
                                          as List<String>?)
                                      ?.map((option) {
                                    bool isCorrect = option ==
                                        questions[index]['correctAnswer'];
                                    bool isUnattempted =
                                        questions[index]['userAnswer'].isEmpty;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isCorrect
                                              ? const Color.fromARGB(
                                                  255, 24, 138, 28)
                                              : (isUnattempted
                                                  ? const Color.fromARGB(
                                                      255, 255, 255, 255)
                                                  : (option ==
                                                          questions[index]
                                                              ['userAnswer']
                                                      ? Colors.red
                                                      : Colors.white)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: isCorrect
                                                  ? Colors.white
                                                  : (isUnattempted
                                                      ? const Color.fromARGB(
                                                          255, 0, 0, 0)
                                                      : Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList() ??
                                  [],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                },
                // ignore: sort_child_properties_last
                child: const Text('Back to Home'),
                style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: const Color.fromARGB(255, 66, 33, 197),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ))),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  void _showFirebaseData(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Firebase Data',
              style: TextStyle(color: Colors.black)),
          // ignore: sized_box_for_whitespace
          content: Container(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('quizResults')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(
                            'Correct Answers: ${data['correctAnswers']} / ${data['correctAnswers'] + data['wrongAnswers'] + data['unattemptedQuestions']}',
                            style: const TextStyle(color: Colors.black)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Wrong Answers: ${data['wrongAnswers']} / ${data['correctAnswers'] + data['wrongAnswers'] + data['unattemptedQuestions']}',
                                style: const TextStyle(color: Colors.black)),
                            Text('Accuracy: ${data['accuracy']}%',
                                style: const TextStyle(color: Colors.black)),
                            Text(
                                'Unattempted Questions: ${data['unattemptedQuestions']} / ${data['correctAnswers'] + data['wrongAnswers'] + data['unattemptedQuestions']}',
                                style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(color: Colors.blue)),
            ),
          ],
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      },
    );
  }
}

class Bullet extends StatelessWidget {
  final Color color;

  const Bullet({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
