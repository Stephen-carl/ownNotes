import 'package:flutter/material.dart';
import 'package:ownnotes/views/login_view.dart';
import 'views/register_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ownnotes/firebase_options.dart';
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
    ),
  );
}

//the homepage will help to iniitialize firebase 
//to get rid of the app always initializing during the routes
class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Home')),
      ),
      //so that the app can communicate with firebase before things are displayed
      //this whole process is to handle initialization
      body: FutureBuilder(
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
           //to know if user is verified
           //so if the user verification can be read as true or false bcus it cannot be null
           if (user?.emailVerified??false) {
            print('You are verified');
           } else {
            print('You need to verify your email first');
           }
            //so if the initialization is done, it will just say done for now
              return Text('Done');
        //default signifies anything else that has not been handled
        default:
        return const Text('Loading');
          }
        },
      ),
    );
  }
}