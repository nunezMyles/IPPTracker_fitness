import 'package:mongo_dart/mongo_dart.dart';



class DBConnection {

  getCollection() async {
    var db = await Db.create("mongodb+srv://myles:246810@cluster0.bkyonlz.mongodb.net/?retryWrites=true&w=majority");
    await db.open();
    var userCollection = db.collection('users');
    return userCollection;
  }


}