import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ownnotes/firebase_options.dart';

//Login View
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

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
        title: const Center(child: Text('Login')),
      ),
      //wrap the whole columm with the futurebuilder
      //so that the app can communicate with firebase before things are displayed
      //this whole process is to handle connectivity
      body: FutureBuilder(
        future: Firebase.initializeApp(
          //to get the current platorm the app is installed in and use the app id to talk to t he firebase
                  options: DefaultFirebaseOptions.currentPlatform
                ),
        //snapshot is a way of geting the result of your future 
        //
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //after adding the missing cases, we can delete all except done
            
            case ConnectionState.done:
              return Column(
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
                //to handle exception and prevent crash
                try {
                  //instantiate the firebase auth to get the function to create a user
                //create instants of firebaseAuth
                //using await makes the process start
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email, 
                  password: password
                  );
                  print('Login successful');
                } 
                //to read the exact error and work on it
                //it has a email and password exception
                on FirebaseAuthException catch (e) {
                  if (e.code == 'invalid-login-credentials') {
                    print('invalid-login-credentials');
                  } else {
                    print(e.code);
                  }
                }                 
              }, 
              child: const Text(
                'Login',
                )
              ),
          ],
        );
        //default signifies anything else that has not been handled
        default:
        return const Text('Loading');
          }
        },
      ),
    );
  }
}