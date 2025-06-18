import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class UtilsApp {
  static void showSnackBar(BuildContext context, String message, int seconds) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: seconds),
      ),
    );
  }

  static showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder:(context){
          return Center(
            child: Container(
              height: 100,
              width: 100,
              padding: const EdgeInsets.all(10),
              decoration:const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xff450154),
                  ),
                  SizedBox(height: 5,),
                  // Text("Cargando", style: TextStyle(
                  //   fontSize: 12,
                  //   color: Color(0xff450154),
                  // ),)
                ],
              ),
            ),
          );
        });
  }

  static dismissProgressBar(BuildContext context) {
    Navigator.of(context).pop();
  }
}

