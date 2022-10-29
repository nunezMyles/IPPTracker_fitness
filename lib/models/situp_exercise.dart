import 'dart:convert';

class SitUpExercise {
  final String id;
  final String name;
  final String email;
  final String timing;
  final String reps;
  final String dateTime;
  final String type;

  SitUpExercise({
    required this.id,
    required this.name,
    required this.email,
    required this.timing,
    required this.reps,
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
      'reps': reps,
      'dateTime': dateTime,
      'type': type
    };
  }

  // json > dart object
  factory SitUpExercise.fromJson(Map<String, dynamic> map) {
    return SitUpExercise(
        id: map['_id'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        timing: map['timing'] ?? '',
        reps: map['reps'] ?? '',
        dateTime: map['dateTime'] ?? '',
        type: map['type'] ?? ''
    );
  }
}