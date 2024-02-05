import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:virtual_chat/data/message.dart';
import 'package:virtual_chat/presentation/widgets/message.dart';
import 'package:virtual_chat/services/openai.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.messageBox,
  });

  final Box<Message> messageBox;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController chatController;
  late OpenAIService openAIService;
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    chatController = TextEditingController();
    openAIService =
        OpenAIService('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');
  }

  void sendMessage() async {
    var text = chatController.text;
    final message = Message(
      sentByMe: true,
      text: text,
      time: DateTime.now(),
    );
    setState(() {
      widget.messageBox.put(message.time.toString(), message);
      messages.add(message);
    });

    final String response = await openAIService.getResponse(text);
    final responseMessage = Message(
      sentByMe: false,
      text: response,
      time: DateTime.now(),
    );

    setState(() {
      widget.messageBox.put(responseMessage.time.toString(), responseMessage);
      messages.add(responseMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        widget.messageBox.values.isEmpty
            ? const Center(
                child:
                    Text('You don\'t have any messages with the agent here :('))
            : Expanded(
                child: ListView(
                  children: widget.messageBox.values
                      .map(
                        (message) => Directionality(
                          textDirection: message.sentByMe
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 12.0),
                            child: MessageWidget(message: message),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: chatController,
                  autofocus: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onFieldSubmitted: (_) => sendMessage,
                  decoration: const InputDecoration(
                      hintText: 'Chat here with the agent'),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: sendMessage,
            ),
          ],
        ),
      ],
    );
  }
}
