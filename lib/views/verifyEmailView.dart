import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
            Text('Please Verify your email address'),
            TextButton(
              onPressed: () async {
                //1. get the current user
                final theUser = FirebaseAuth.instance.currentUser;
                //2. send email verfication, mind you the user can be null so use the '?'
                await theUser?.sendEmailVerification();
              }, 
              child: Text('Send email verification'),
              ),
          ],
        ),
    );
  }
}