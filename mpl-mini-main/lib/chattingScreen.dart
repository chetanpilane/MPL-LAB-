import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bubble/bubble.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/constants.dart';

class MyHomePage extends StatefulWidget {
  final String name;
  final String message;

  MyHomePage(this.name, this.message);
  // const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _apiUser = const types.User(id: 'api_user_id');
  final String openAiApiKey =
      // "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";
      //"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";
  final TextEditingController userInputController = TextEditingController();
  String responseMessage = '';
  bool darkTheme = false;

  void saveResponseLocally(String response) {
    final box = GetStorage();
    box.write('responseMessage', response);
  }

  String getLocalResponse() {
    final box = GetStorage();
    return box.read('responseMessage') ?? '';
  }

  @override
  void initState() {
    super.initState();

    String localResponse = getLocalResponse();

    setState(() {
      responseMessage = localResponse;
    });
  }

  Future<void> _launchWebsite(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkTheme ? MyColors.secondaryDark : MyColors.black,
        title: Text(
          widget.name,
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Chat(
        messages: _messages,
        theme: darkTheme ? DarkChatTheme() : DefaultChatTheme(),
        onAttachmentPressed: _handleAttachmentPressed,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: _user,
        scrollToUnreadOptions: const ScrollToUnreadOptions(
          lastReadMessageId: 'lastReadMessageId',
          scrollOnOpen: true,
        ),
        bubbleBuilder: _bubbleBuilder,

      ),
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Widget _bubbleBuilder(
      Widget child, {
        required message,
        required nextMessageInGroup,
      }) {
    final isUserMessage = _user.id == message.author.id;

    return Bubble(
      child: child,
      color: isUserMessage
          ? (darkTheme ? MyColors.bluePurple : MyColors.black)
          : (darkTheme ?  MyColors.secondaryDark : MyColors.greyTextBox),
      margin: nextMessageInGroup
          ? const BubbleEdges.symmetric(horizontal: 6)
          : null,
      nip: nextMessageInGroup
          ? BubbleNip.no
          : isUserMessage
          ? BubbleNip.leftBottom
          : BubbleNip.rightBottom,
    );
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: randomString(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);

      // Send the user's message to the API
      await _makeApiRequest(result.path);
    }
  }

  Future<void> _makeApiRequest(String userMessage) async {
    try {
      final response = await Dio().post(
        'https://api.openai.com/v1/chat/completions',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $openAiApiKey",
          },
        ),
        data: {
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "Pretend to be My friend ${widget.name} whoes last conversation with me was : ${widget.message}. I will hence forth ask you questions please answer them being ${widget.name}. The question is : $userMessage"}
          ],
        },
      );

      final apiResponse = response.data["choices"][0]["message"]["content"];
      setState(() {
        responseMessage = apiResponse;
        _addMessage(types.TextMessage(
          author: _apiUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: randomString(),
          text: apiResponse,
        ));
      });

      // Save the response locally
      saveResponseLocally(apiResponse);
    } catch (e) {
      setState(() {
        responseMessage = "Error: $e";
      });
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
          _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
          (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
          _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
          (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);

    _makeApiRequest(message.text);
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
