import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'threedots.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  Future<String> sendMessage(String message) async {
    const String url =
        'https://api.openai.com/v1/chat/completions'; // OpenAI APIのエンドポイント
    const String apiKey =
        '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'; // 自分のOpenAI APIキーに置き換える

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo', // 使用するGPTモデルを指定
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': message},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(const Utf8Decoder().convert(response.bodyBytes));
      final replies = data['choices'][0]['message']['content'];
      return replies;
    } else {
      throw Exception('メッセージ送信失敗');
    }
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "user",
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    try {
      final response = await sendMessage(message.text);

      ChatMessage botMessage = ChatMessage(
        text: response,
        sender: "Sweet ChatBot",
      );

      setState(() {
        _messages.insert(0, botMessage);
        _isTyping = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: const InputDecoration.collapsed(
              hintText: "ここに質問を入力して下さいね",
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: _sendMessage,
        ),
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color primaryColor = theme.primaryColor;
    Color secondaryColor = theme.primaryColor.withOpacity(0.6);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
          context,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shokutomo Chat'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Show the dialog box when a message is tapped
                      _showTitleInputDialog(context, _messages[index].text);
                    },
                    child: _messages[index],
                  );
                },
              ),
            ),
            if (_isTyping) const ThreeDots(),
            const Divider(
              height: 1.0,
            ),
            const Divider(height: 1.0),
            _buildTextComposer(),
          ],
        ),
      ),
    );
  }

  void _showTitleInputDialog(BuildContext context, String message) {
    String title = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('myレシピに保存'),
          content: TextField(
            onChanged: (value) {
              title = value;
            },
            decoration: const InputDecoration(
              hintText: 'レシピ名を入力してください',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog box
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                // Save the title and close the dialog box
                Navigator.pop(context);
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final String sender;

  const ChatMessage({
    required this.text,
    required this.sender,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color primaryColor = theme.primaryColor;

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment:
            sender == "user" ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: sender == "user" ? primaryColor : Colors.grey,
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
