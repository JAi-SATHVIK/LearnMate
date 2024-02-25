
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_final_2/Gemini/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatModel> chatList = [];
  final TextEditingController controller = TextEditingController();
  File? image;

  void onSendMessage() async {
    late ChatModel model;

    if (image == null) {
      model = ChatModel(isMe: true, message: controller.text);
    } else {
      final imageBytes = await image!.readAsBytes();

      String base64EncodedImage = base64Encode(imageBytes);

      model = ChatModel(
        isMe: true,
        message: controller.text,
        base64EncodedImage: base64EncodedImage,
      );
    }

    setState(() {
      chatList.add(model);
      controller.clear();
    });

    final geminiModel = await sendRequestToGemini(model);

    setState(() {
      chatList.add(geminiModel);
    });
  }

  void selectImage() async {
    final picker =
        // ignore: invalid_use_of_visible_for_testing_member, deprecated_member_use
        await ImagePicker.platform.getImage(source: ImageSource.gallery);

    if (picker != null) {
      image = File(picker.path);
    }
  }

  Future<ChatModel> sendRequestToGemini(ChatModel model) async {
    String url = "";
    Map<String, dynamic> body = {};

    if (model.base64EncodedImage == null) {
      url =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${GeminiApiKey.api_key}";

      body = {
        "contents": [
          {
            "parts": [
              {"text": model.message},
            ],
          },
        ],
      };
    } else {
      url =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=${GeminiApiKey.api_key}";

      body = {
        "contents": [
          {
            "parts": [
              {"text": model.message},
              {
                "inline_data": {
                  "mime_type": "image/jpeg",
                  "data": model.base64EncodedImage,
                }
              }
            ],
          },
        ],
      };
    }

    Uri uri = Uri.parse(url);

    final result = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    // ignore: avoid_print
    print(result.statusCode);
    // ignore: avoid_print
    print(result.body);

    final decodedJson = json.decode(result.body);

    String message =
        decodedJson['candidates'][0]['content']['parts'][0]['text'];

    return ChatModel(isMe: false, message: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Chat with JAI"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return ChatBubble(
                    chatModel: chatList[index],
                    isLast: index == chatList.length - 1,
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          icon: const Icon(Icons.upload_file),
                        ),
                        hintText: "Message",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    onSendMessage();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatModel {
  final bool isMe;
  final String message;
  final String? base64EncodedImage;

  ChatModel({
    required this.isMe,
    required this.message,
    this.base64EncodedImage,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatModel chatModel;
  final bool isLast;

  const ChatBubble({
    Key? key,
    required this.chatModel,
    required this.isLast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 8.0 : 0.0,
      ),
      child: Align(
        alignment:
            chatModel.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(8),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: chatModel.isMe ? Colors.blue[200] : Colors.green[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: chatModel.isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!chatModel.isMe)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 165, 163, 163),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: const Icon(Icons.chat_bubble, size: 20),
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: chatModel.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (chatModel.base64EncodedImage != null)
                      Image.memory(
                        base64Decode(chatModel.base64EncodedImage!),
                        height: 100,
                        width: 100,
                      ),
                    Text(
                      chatModel.message,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              if (chatModel.isMe)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 156, 156, 156),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: const Icon(Icons.person, size: 20),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}