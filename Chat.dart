import 'package:flutter/material.dart';

void main() {
  runApp(ChatBotApp());
}

class ChatBotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.insert(0, ChatMessage(text: "Which word do you need help with?", isUser: false));
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage userMessage = ChatMessage(
      text: text,
      isUser: true,
    );
    List<String> suggestedWords = generateSuggestedWords(text);
    ChatMessage botMessage = ChatMessage(
      text: "Did you mean any of these?",
      isUser: false,
      suggestedWords: suggestedWords,
    );
    setState(() {
      _messages.insert(0, userMessage);
      _messages.insert(0, botMessage);
    });
    // You can add logic here to handle the user input, like sending it to a chatbot API
  }

  List<String> generateSuggestedWords(String word) {
    // Here you can implement your logic to generate suggested words based on the input word
    // For simplicity, I'm providing some example words
    List<String> exampleWords = ['apples', 'bananas', 'oranges'];
    return exampleWords;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: 'Enter your word',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final List<String>? suggestedWords;

  ChatMessage({required this.text, required this.isUser, this.suggestedWords});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isUser)
                Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    child: Text('Bot'),
                  ),
                ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: isUser ? Radius.circular(20.0) : Radius.circular(0.0),
                      topRight: isUser ? Radius.circular(0.0) : Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(color: isUser ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ],
          ),
          if (!isUser && suggestedWords != null)
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: suggestedWords!.map((word) {
                  return Container(
                    margin: EdgeInsets.only(top: 5.0, left: 5.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                        print('User selected: $word');
                      },
                      child: Text(word),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
