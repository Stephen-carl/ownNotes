//to handle error dialog
import 'package:flutter/material.dart';

//create a function to show error code
Future<void> showErrorDialog(BuildContext context, String text) {
  //create a dialog and display
  return showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text('An error ocurred'),
        //the text is the sstring text define in the function argument
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              //to dismiss the alertDialog
              Navigator.of(context).pop();
            }, 
            child: const Text('OK'),
          ),
        ],
      );
    });
}