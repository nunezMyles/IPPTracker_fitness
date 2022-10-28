import 'dart:convert';

class IpptTraining {
  final String id;
  final String name;
  final String email;
  final String age;
  final String runTiming;
  final String pushupReps;
  final String situpReps;
  final String score;
  final String dateTime;
  final String type;

  IpptTraining({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.runTiming,
    required this.pushupReps,
    required this.situpReps,
    required this.score,
    required this.dateTime,
    required this.type
  });

  // (1) serialize to JSON format when sending to server
  String toJson() => json.encode(toMap());

  // (2)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'runTiming': runTiming,
      'pushupReps': pushupReps,
      'situpReps': situpReps,
      'score': score,
      'dateTime': dateTime,
      'type': type
    };
  }

  // json > dart object
  factory IpptTraining.fromJson(Map<String, dynamic> map) {
    return IpptTraining(
        id: map['_id'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        age: map['age'] ?? '',
        runTiming: map['runTiming'] ?? '',
        pushupReps: map['pushupReps'] ?? '',
        situpReps: map['situpReps'] ?? '',
        score: map['score'] ?? '',
        dateTime: map['dateTime'] ?? '',
        type: map['type'] ?? ''
    );
  }
}