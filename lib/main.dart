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
          //  final user = FirebaseAuth.instance.currentUser;
          //  print(user);
          //  //to know if user is verified
          //  //so if the user verification can be read as true or false bcus it cannot be null
          //  if (user?.emailVerified??false) {
          //   //so if the initialization is done, it will just say done for now
          //   return const Text('Done');
          //  } else {
          //   print('Please verify');
          //   //to display the verify email view just like a pop-up on hte main screen
          //   return const VerifyEmailView();
          //  }

          //trial 
          return const LoginView();
           //default signifies anything else that has not been handled
        default:
        //this is to make things look better display a circular 
        return const CircularProgressIndicator();
          }
        },
      );
  }
}

