import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log; 

//Registeration App
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  //to create the text controllers
  late final TextEditingController _email;
  late final TextEditingController _password;

//intitstate is called when the Homepage is called
  @override
  void initState() {
    //we need to link the controller tot he textfield
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  //then you have to dispose them when the homepage is closed
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Register')),
      ),
      body: Column(
            children: [
              //to have something like editText
              TextField(
                controller: _email,
                autocorrect: true,
                enableSuggestions: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter email'
                ),
                ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter password'
                ),
                ),
              TextButton(
                //add a function to the onPressed.
                onPressed: () async{
                  //get the text from the editText and put in a string
                  var email = _email.text;
                  var password = _password.text;
                  try {
                    //instantiate the firebase auth to get the function to create a user
                  //create instants of firebaseAuth
                  //using await makes the process start
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, 
                    password: password
                    );
                    devtools.log('Registered Suceessfully');
                  } on FirebaseAuthException catch (e) {  
                    devtools.log(e.code);  //to set authenticity
                    if (e.code == 'weak-password') {
                      devtools.log('Minimum of 6 characters');
                    } else if (e.code == 'email-already-in-use') {
                      devtools.log('Email is already in use');
                    } else if (e.code == 'invalid-email') {
                      devtools.log('Invalid email entered');
                    }
                  }                
                }, 
                child: const Text(
                  'Register',
                  )
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login/', 
                      (route) => false);
                }, 
                child: const Text('Already Registered? Sign In')
              ),
            ],
          ),
    );
  }
}