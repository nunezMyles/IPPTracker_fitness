import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../widgets/showSnackBar.dart';
import 'package:http/http.dart' as http;

String webServerUri = 'https://helpful-seer-366001.as.r.appspot.com/'; // for local use http://localhost:3000

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch(response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.body)['msg']);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;
    default:
      showSnackBar(context, response.body);
  }
}