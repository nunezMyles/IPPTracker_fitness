class Entry {
  //static String table = "entries";
  //int id;
  String date;
  String duration;
  double speed;
  double distance;

  Entry({
    //required this.id,
    required this.date,
    required this.duration,
    required this.speed,
    required this.distance
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'date': date,
      'duration': duration,
      'speed': speed,
      'distance': distance
    };

    //map['id'] = id;

    return map;
  }

  static Entry fromMap(Map<String, dynamic> map) {
    return Entry(
        //id: map['id'],
        date: map['date'],
        duration: map['duration'],
        speed: map['speed'],
        distance: map['distance']);
  }
}