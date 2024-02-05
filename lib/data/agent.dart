import 'package:hive/hive.dart';

part 'agent.g.dart';

const agentKey = 'agent';

@HiveType(typeId: 0)
class Agent {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;

  Agent({required this.id, required this.name});

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
