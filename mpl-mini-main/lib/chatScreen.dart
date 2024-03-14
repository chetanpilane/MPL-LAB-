import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textController = TextEditingController();
  List<Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/whatsapp-bg.jpeg'), // Replace with the actual path or network image URL
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/user_avatar.jpg'), // Replace with the actual path or network image URL
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        'Online',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.call),
                  onPressed: () {
                    // Handle voice call action
                    print('Voice Call');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.videocam),
                  onPressed: () {
                    print('Video Call');
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return MessageWidget(
                    isMe: _messages[index].isMe,
                    message: _messages[index].text,
                  );
                },
              ),
            ),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.emoji_emotions),
            onPressed: () {
              // Handle emoji icon action
              print('Emoji Icon');
            },
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.pin),
            onPressed: () {
              // Handle pin icon action
              print('Pin Icon');
            },
          ),
          IconButton(
            icon: Icon(Icons.attach_money),
            onPressed: () {
              // Handle rupees icon action
              print('Rupees Icon');
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              // Handle camera icon action
              print('Camera Icon');
            },
          ),
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 20.0,
            child: IconButton(
              icon: Icon(Icons.keyboard_voice),
              onPressed: () {
                // Handle voice message icon action
                print('Voice Message Icon');
              },
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String messageText = _textController.text.trim();
    if (messageText.isNotEmpty) {
      Message message = Message(isMe: true, text: messageText);
      setState(() {
        _messages.add(message);
        _textController.clear();
      });

      // Simulate a response after a delay (you can replace this with actual logic)
      Future.delayed(Duration(seconds: 1), () {
        Message response = Message(isMe: false, text: 'Received: $messageText');
        setState(() {
          _messages.add(response);
        });
      });
    }
  }
}

class MessageWidget extends StatelessWidget {
  final bool isMe;
  final String message;

  const MessageWidget({required this.isMe, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class Message {
  final bool isMe;
  final String text;

  Message({required this.isMe, required this.text});
}
