import 'package:flutter/material.dart';
import 'package:ownnotes/views/login_view.dart';
import 'views/register_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ownnotes/firebase_options.dart';
import 'package:ownnotes/views/verifyEmailView.dart';
void main() {
  //this is to bind firebase with the application before any major is done
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Homepage(),
      routes: {
        '/login/': (context) => const  LoginView(),
        '/register/': (context) => const RegisterView(),
        '/verify-Email/':(context) => const VerifyEmailView()
      },
    ),
  );
}

//the homepage will help to iniitialize firebase 
//to get rid of the app always initializing during the routes
class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          //to get the current platorm the app is installed in and use the app id to talk to t he firebase
                  options: DefaultFirebaseOptions.currentPlatform
                ),
        //snapshot is a way of geting the result of your future 
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            //get the current user
           final user = FirebaseAuth.instance.currentUser;
           //now what i want to do is to check if the current user is verified
           //else let them verify
           if (user != null) {
            //and if the user is verified
            if (user.emailVerified) {
              print('Email is verified');
            } //if not verified
            else {
              return const VerifyEmailView();
            } //else if there is no user loggedn
           } else {
            return const LoginView();
           }

           //if it is done
           return const Text('Done');
           //default signifies anything else that has not been handled
        default:
        //this is to make things look better display a circular 
        return const CircularProgressIndicator();
          }
        },
      );
  }
}

