import 'package:flutter/material.dart';
import '../screens/spotify_screen.dart';

showAlertDialog(BuildContext context) {
  TextEditingController playlistUriController = TextEditingController();
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel", style: TextStyle(color: Colors.white)),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Add", style: TextStyle(color: Colors.white)),
    onPressed:  () {
      if (playlistUriController.text.isNotEmpty) {
        play(playlistUriController.text.substring(34, 56));
      }
      Navigator.of(context).pop();
    },
  );



  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: const Color.fromARGB(255, 46, 46, 46).withOpacity(0.9),
    title: const Text("Add new playlist", style: TextStyle(color: Colors.white)),
    content: TextField(
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        labelText: 'Enter shared link',
        labelStyle: TextStyle(color: Colors.white70),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      controller: playlistUriController,
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}