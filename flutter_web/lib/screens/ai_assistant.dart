import 'dart:ffi';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

late bool isLoading=false;
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
  TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _chatMessages = [];
  ScrollController _scrollController = ScrollController();

  void _addMessage(String message, bool isUser) {
  final newMessage = ChatMessage(
    text: message,
    isUser: isUser,
  );

  setState(() {
    _chatMessages.add(newMessage);
  });

  // Scroll to the end of the list after adding the new message
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  });
}

  void _sendMessage() async {
    String userMessage = _messageController.text;
    _messageController.clear();
    
    // Add the user's message to the chat
    _addMessage(userMessage, true);

    // Send the user's message to ChatGPT API
    String chatGptResponse = await _getChatGptResponse(userMessage);
         setState(() {
           isLoading=false;
         });
    // Add ChatGPT's response to the chat
    _addMessage(chatGptResponse, false);
  }

  Future<String> _getChatGptResponse(String userMessage) async {
    final apiKey = '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'; // Replace with your actual GPT-3.5 Turbo API key
  final endpoint = 'https://api.openai.com/v1/chat/completions';

  final response = await http.post(
    Uri.parse(endpoint),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      "model": "gpt-3.5-turbo-16k-0613",
      "messages": [
        {"role": "system", "content": "you are an assistant"},
        {"role": "user", "content": userMessage},
      ],
      "temperature": 0,
        "max_tokens": 256,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0,
    }),
  );
print('Response Status Code: ${response.statusCode}');
print('Response Body: ${response.body}');
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final responseMessage = data['choices'][0]['message']['content'];
    return responseMessage;
  } else {
    throw Exception('Failed to fetch response');
  }
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
       appBar: AppBar(
      title: Text(isLoading ? 'Typing' : 'Chat with AI',),
    
       // Set the icon color to black
    ),
        body:  Column(
            children: <Widget>[
              
             _chatMessages.isEmpty? Expanded(
               child: SingleChildScrollView(
                 child: Container(
                  child: Center(
                    child:Column(children: [
                      LottieBuilder.asset('assets/animation_ChatBot.json'),
                      Text("AI Assistant",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,),),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text("Note: Chats will not be saved so copy if someting is important"),
                      )
                      ]
                    ),
                  ),
                 ),
               ),
             ):Expanded(
                child: ListView.builder(
                  itemCount: _chatMessages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message = _chatMessages[index];
                    return ChatBubble(
                      text: message.text,
                      isUser: message.isUser,
                    );
                  },
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask a Question',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30)
                ),
              ),
              maxLines: null, // Allows for an unlimited number of lines
              textInputAction: TextInputAction.newline, // Enables newline action button
              keyboardType: TextInputType.multiline,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: (){
                        isLoading=true;
                          setState(() {
                            _sendMessage();
                          });
                           
            
                      },
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

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  ChatBubble({
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child:  Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16.0,color: isUser?Colors.white : Colors.black ),
        ),
      ),
    );
  }
}