// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ownnotes/constants/routes.dart';
import 'dart:developer' as devtools show log;

//creating a different class for verfying the mail
//so this will just be a popup on top of the homepage
class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    //create a view to send the mail
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Verify Email')),
      ),
      body: Column(
          children: [
            const Text('We have sent you an email verification. Please open it to verify your account'),
            const Text('If you have not received a verification mail yet, click this button below'),
            TextButton(
              onPressed: () async {
                //1. get the current user
                final theUser = FirebaseAuth.instance.currentUser;
                //2. send email verfication, mind you the user can be null so use the '?'
                await theUser?.sendEmailVerification();
                if (theUser?.emailVerified??false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute, 
                    (_) => false,
                  );
                } else {
                  devtools.log('Please verify your email');
                }
              }, 
              child: const Text('Send email verification'),
              ),
              //just incase the user makes a mistake
              TextButton(
                onPressed: () async{
                  //log the user out
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute, 
                    (route) => false,
                  );
                }, 
                child: const Text('Restart'),
              ),
          ],
        ),
    );
  }
}