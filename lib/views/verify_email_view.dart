// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ownnotes/constants/routes.dart';
import 'package:ownnotes/service/auth/auth_service.dart';

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
                await AuthService.firebase().sendEmailVerification();
                // if (theUser?.emailVerified??false) {
                //   Navigator.of(context).pushNamedAndRemoveUntil(
                //     loginRoute, 
                //     (_) => false,
                //   );
                // } else {
                //   devtools.log('Please verify your email');
                // }
              }, 
              child: const Text('Send email verification'),
              ),
              //just incase the user makes a mistake
              TextButton(
                onPressed: () async{
                  //log the user out
                  await AuthService.firebase().logout();
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