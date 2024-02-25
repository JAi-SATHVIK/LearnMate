import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ClassesScreen extends StatelessWidget {
  final String cls;

  ClassesScreen({required this.cls});

  final Map<String, Map<String, List<String>>> data = {
    'Class 1': {
      'Mathematics': [
        'Shapes and Space',
        'Numbers from One to Nine',
        'Addition',
        'Subtraction',
        'Numbers from Ten to Twenty',
        'Time',
        'Measurement',
        'Numbers from Twenty One to Fifty'
      ],
      'Environmental Studies': [
        'My Family',
        'I Am Lucky!',
        'My Body',
        'I Love My Family',
        'Food I Like',
        'Clothes We Wear',
        'Things I Use',
        'Helping Each Other',
        'Work We Do',
        'Plants Around Us',
        'Animals Around Us'
      ],
    },
    'Class 2': {
      'Mathematics': [
        'What Is Long, What Is Round?',
        'Counting in Groups',
        'How Much Can You Carry?',
        'Counting in Tens',
        'Patterns',
        'Footprints'
      ],
      'Environmental Studies': [
        'Super Senses',
        'A Snake Charmer’s Story',
        'From Tasting to Digesting',
        'Mangoes Round the Year',
        'Seeds and Seeds',
        'Every Drop Counts',
        'Experiments with Water',
        'A Treat for Mosquitoes',
        'Up You Go!'
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final subjects = data[cls] ?? {};
    return SubjectScreen(cls: cls, subjects: subjects);
  }
}

class SubjectScreen extends StatelessWidget {
  final String cls;
  final Map<String, List<String>> subjects;

  SubjectScreen({required this.cls, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$cls Subjects',
          style: TextStyle(color: Colors.white,),
        ),
        backgroundColor: const Color.fromARGB(255, 80, 7, 207),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          String subject = subjects.keys.elementAt(index);
          List<String> chapters = subjects[subject] ?? [];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChapterScreen(cls: cls, selectedSubject: subject, chapters: chapters),
                ),
              );
            },
            child: Card(
              elevation: 5, // Added elevation
              color: Color.fromARGB(255, 255, 255, 255),
              child: ListTile(
                leading: Icon(Icons.subject),
                title: Text(
                  subject,
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0, // Elevated the text size
                  ),
                ),
                trailing: Icon(Icons.arrow_forward, color: Colors.deepPurple), // Icons in deep purple
              ),
            ),
          );
        },
      ),
    );
  }
}
class ChapterScreen extends StatelessWidget {
  final String cls;
  final String selectedSubject;
  final List<String> chapters;

  ChapterScreen({required this.cls, required this.selectedSubject, required this.chapters});

  Future<List<String>> fetchVideos(String chapter) async {
    final String apiKey = 'AIzaSyBnL4qgGDArdLSL7hA0LRGLRL_RvehhoJc';
    final String baseUrl = 'https://www.googleapis.com/youtube/v3/search';

    final response = await http.get(
      Uri.parse('$baseUrl?part=snippet&maxResults=10&q=$cls+$selectedSubject+$chapter&type=video&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<String> videoIds = [];

      for (var item in data['items']) {
        videoIds.add(item['id']['videoId']);
      }

      return videoIds;
    } else {
      throw Exception('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$cls Chapters - $selectedSubject',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color.fromARGB(255, 93, 0, 255),
      ),
      body: ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              fetchVideos(chapters[index]).then((videos) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoListScreen(videos),
                  ),
                );
              });
            },
            child: Card(
              elevation: 3, // Added elevation
              color: Color.fromARGB(255, 255, 255, 255),
              child: Container(
                padding: EdgeInsets.all(8), // Increased padding
                child: ListTile(
                  leading: Icon(Icons.video_collection_rounded, color: Color.fromARGB(255, 85, 0, 255)), // Icons in deep purple
                  title: Text(
                    chapters[index],
                    style: TextStyle(
                      color: Colors.black, // Text color elevated
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0, // Elevated the text size
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward, color: Colors.deepPurple), // Icons in deep purple
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class VideoListScreen extends StatelessWidget {
  final List<String> videoIds;

  VideoListScreen(this.videoIds);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CLASSES',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        shadowColor: Colors.yellow,
        backgroundColor: const Color.fromARGB(255, 93, 0, 255),

         leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: videoIds.length,
        itemBuilder: (context, index) {
          return VideoTile(videoId: videoIds[index]);
        },
      ),
    );
  }
}

class VideoTile extends StatelessWidget {
  final String videoId;

  VideoTile({required this.videoId});

  Future<String> fetchVideoTitle(String videoId) async {
    final String apiKey = 'AIzaSyBnL4qgGDArdLSL7hA0LRGLRL_RvehhoJc'; // Replace with your YouTube API key
    final String baseUrl = 'https://www.googleapis.com/youtube/v3/videos';

    final response = await http.get(
      Uri.parse('$baseUrl?part=snippet&id=$videoId&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['items'][0]['snippet']['title'];
    } else {
      throw Exception('Failed to load video title');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchVideoTitle(videoId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Display a loading indicator while fetching the video title
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final String videoTitle = snapshot.data ?? '';
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: videoId,
                      flags: YoutubePlayerFlags(
                        autoPlay: false,
                        mute: false,
                        disableDragSeek: false,
                        loop: false,
                        isLive: false,
                        forceHD: false,
                        enableCaption: true,
                      ),
                    ),
                    showVideoProgressIndicator: true,
                  ),
                  SizedBox(height: 8), // Add some vertical space between video and title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      videoTitle,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
