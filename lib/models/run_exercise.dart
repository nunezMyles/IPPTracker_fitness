import 'dart:convert';

class RunExercise {
  final String id;
  final String name;
  final String email;
  final String timing;
  final String distance;
  final String dateTime;
  final String type;

  RunExercise({
    required this.id,
    required this.name,
    required this.email,
    required this.timing,
    required this.distance,
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
      'timing': timing,
      'distance': distance,
      'dateTime': dateTime,
      'type': type
    };
  }

  // json > dart object
  factory RunExercise.fromJson(Map<String, dynamic> map) {
    return RunExercise(
        id: map['_id'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        timing: map['timing'] ?? '',
        distance: map['distance'] ?? '',
        dateTime: map['dateTime'] ?? '',
        type: map['type'] ?? ''
    );
  }
}