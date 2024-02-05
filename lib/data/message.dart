import 'package:hive/hive.dart';

part 'message.g.dart';

const messageKey = 'message';

@HiveType(typeId: 1)
class Message {
  @HiveField(0)
  bool sentByMe;
  @HiveField(1)
  String text;
  @HiveField(2)
  DateTime time;

  Message({
    required this.sentByMe,
    required this.text,
    required this.time,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sentByMe: json['sentByMe'],
      text: json['text'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() => {
        'sentByMe': sentByMe,
        'text': text,
        'time': time.toIso8601String(),
      };
}
