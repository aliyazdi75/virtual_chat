import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'data/agent.dart';
import 'data/message.dart';
import 'presentation/screens/chat.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(AgentAdapter())
    ..registerAdapter(MessageAdapter());
  var agentBox = await Hive.openBox<Agent>('agentBox');
  var messageBox = await Hive.openBox<Message>('messageBox');
  runApp(MyApp(
    agentBox: agentBox,
    messageBox: messageBox,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.agentBox,
    required this.messageBox,
  });

  final Box<Agent> agentBox;
  final Box<Message> messageBox;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Flutter Virtual Chat Page',
        agentBox: agentBox,
        messageBox: messageBox,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.agentBox,
    required this.messageBox,
  });

  final String title;
  final Box<Agent> agentBox;
  final Box<Message> messageBox;

  Future<void> _makeAnAgentDialog(BuildContext context) async {
    var nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Agent'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Agent Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('CREATE'),
              onPressed: () {
                var name = nameController.text;
                if (name.isNotEmpty) {
                  var agent = Agent(id: DateTime.now().toString(), name: name);
                  agentBox.put(agentKey, agent);
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: agentBox.listenable(),
      builder: (context, agentBox, child) {
        var agent = agentBox.get(agentKey);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(title),
          ),
          body: Center(
            child: agent == null
                ? const Text(
                    'Please add an agent',
                  )
                : ChatPage(messageBox: messageBox),
          ),
          floatingActionButton: agent != null
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    _makeAnAgentDialog(context);
                  },
                  tooltip: 'Add an agent',
                  child: const Icon(Icons.add),
                ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
