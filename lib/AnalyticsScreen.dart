import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AnalyticsScreen extends StatelessWidget {
  final CollectionReference quizResults =
      FirebaseFirestore.instance.collection('quizResults');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: quizResults.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          // Lists to store correct, wrong, and unattempted questions, and accuracy
          List<int> correctAnswersList = [];
          List<int> wrongAnswersList = [];
          List<int> unattemptedQuestionsList = [];
          List<double> accuracyList = [];
          // Iterate over each document and accumulate data in lists
          for (int i = 0; i < documents.length; i++) {
            correctAnswersList.add(documents[i]['correctAnswers'] ?? 0);
            wrongAnswersList.add(documents[i]['wrongAnswers'] ?? 0);
            unattemptedQuestionsList
                .add(documents[i]['unattemptedQuestions'] ?? 0);
            accuracyList.add(double.parse('${documents[i]['accuracy'] ?? 0}'));
          }
          // Calculate the total correct, wrong, and unattempted questions
          int totalCorrectQuestions =
              correctAnswersList.fold(0, (prev, current) => prev + current);
          int totalWrongQuestions =
              wrongAnswersList.fold(0, (prev, current) => prev + current);
          int totalUnattemptedQuestions = unattemptedQuestionsList.fold(
              0, (prev, current) => prev + current);
          // Calculate the average accuracy
          double averageAccuracy = accuracyList.isNotEmpty
              ? accuracyList.reduce((a, b) => a + b) / documents.length
              : 0.0;
          // Calculate the number of tests taken
          int numberOfTests = documents.length;
          // Calculate the total questions for the overview tab
          int total = totalCorrectQuestions +
              totalWrongQuestions +
              totalUnattemptedQuestions;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Show the total correct, wrong, and unattempted questions, and the average accuracy
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Analytics Overview',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildStatisticRowWithProgress(
                          'Total Correct Answers',
                          totalCorrectQuestions.toString(),
                          totalCorrectQuestions,
                          total,
                          Colors.green,
                        ),
                        _buildStatisticRowWithProgress(
                          'Total Wrong Answers',
                          totalWrongQuestions.toString(),
                          totalWrongQuestions,
                          total,
                          Colors.red,
                        ),
                        _buildStatisticRowWithProgress(
                          'Total Unattempted Questions',
                          totalUnattemptedQuestions.toString(),
                          totalUnattemptedQuestions,
                          total,
                          Colors.yellow,
                        ),
                        _buildStatisticRowWithIcon(
                          'Average Accuracy',
                          '${(averageAccuracy).toStringAsFixed(2)}%',
                          Icons.star,
                        ),
                        _buildStatisticRow(
                          'Number of Tests Taken',
                          numberOfTests.toString(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Iterate over each document in reverse order and display its data in styled boxes
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final reversedIndex = documents.length - 1 - index;
                    final testDocument = documents[reversedIndex];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.assignment,
                                        color: Colors.indigo,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Test ${reversedIndex + 1}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              _buildDataRow(
                                'Subject Name',
                                testDocument['subjectName'] ?? 'N/A',
                              ),
                              _buildDataRow(
                                'Chapter Name',
                                testDocument['chapterName'] ?? 'N/A',
                              ),
                              _buildDataRow(
                                'Correct Questions',
                                '${testDocument['correctAnswers'] ?? 0}',
                              ),
                              _buildDataRow(
                                'Wrong Questions',
                                '${testDocument['wrongAnswers'] ?? 0}',
                              ),
                              _buildDataRow(
                                'Unattempted Questions',
                                '${testDocument['unattemptedQuestions'] ?? 0}',
                              ),
                              _buildDataRow(
                                'Accuracy',
                                '${testDocument['accuracy'] ?? 0}%',
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildStatisticRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticRowWithProgress(
      String label, String value, int completed, int total, Color color) {
    double progress = total != 0 ? completed / total : 0.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticRowWithIcon(
      String label, String value, IconData iconData) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                color: Colors.indigo,
              ),
              SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }
}