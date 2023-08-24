import 'dart:async';
import 'package:boxapp/screens/sigup.dart';
import 'package:boxapp/services/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


Future<void> deleteUserAccount() async {
  User? userssn = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore oodb = FirebaseFirestore.instance;
  try {
    final getodbdelete = oodb.collection('user').doc(userssn?.uid);
    getodbdelete.delete();
    //deleteFCMtoken();
    await FirebaseAuth.instance.currentUser!.delete();
    //FirebaseAuth.instance.signOut();
  } on FirebaseAuthException catch (e) {
    debugPrint(e as String?);

    if (e.code == "requires-recent-login") {
      await _reauthenticateAndDelete();
    } else {
      // Handle other Firebase exceptions
    }
  } catch (e) {
    debugPrint(e as String?);

    // Handle general exception
  }

}

Future<void> deleteFCMtoken() async{
  await FirebaseMessaging.instance.deleteToken();

  debugPrint("delete token");
}

Future<void> checkfcmtoken() async{
  //final tokenn = await NotificationService.requestFirebaseToken();
  String? token = await FirebaseMessaging.instance.getToken();
  debugPrint("new token");
  debugPrint(token);
  var oldtoken;
  User? userss = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore oodb = FirebaseFirestore.instance;
  final getodb = oodb.collection('user').doc(userss?.uid);
  await getodb.get().then(
    (DocumentSnapshot doc) {
        oldtoken = doc.get("token");
        debugPrint("snap từ firebase");
        debugPrint(oldtoken);
    } 

  );
  if( oldtoken != token){
  //cập nhật lại token
  getodb.update({"token": token});
  //reload page ?
  }
}

var lengthnoti =0;
Future<void> _reauthenticateAndDelete() async {
  try {
    final providerData = FirebaseAuth.instance.currentUser?.providerData.first;

    if (AppleAuthProvider().providerId == providerData!.providerId) {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithProvider(AppleAuthProvider());
    } else if (GoogleAuthProvider().providerId == providerData.providerId) {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithProvider(GoogleAuthProvider());
    }

    await FirebaseAuth.instance.currentUser?.delete();
  } catch (e) {
    // Handle exceptions
  }
}

String? getdbpath() {
    User? userss = FirebaseAuth.instance.currentUser;
    if(userss != null){
      final emailuser = userss.email;
      var pathdb = emailuser?.replaceAll("@", "");
      pathdb = pathdb?.replaceAll('.', '');
      
      return pathdb;
    }else{
      return "1";
    }

}

// int snapshotValue(dataSnapshot)  {
//   dataSnapshot.value!.forEach((key, value) {
//      lengthnoti++;
//   });
//   return lengthnoti;
// }
// Future getlength(String userpath) async {
 
//   final ref = FirebaseDatabase.instance.ref(userpath);
//   DataSnapshot dataSnapshot = (await ref.once()).snapshot;
//       if(dataSnapshot.value != null){      
//           snapshotValue(dataSnapshot);
//       }  
// }



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {



  Future<void> _showAlertDialog() async {

   return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog( // <-- SEE HERE
          title: const Text('Delete Account'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure want to delete account?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const SignUpScreen()));
                deleteUserAccount();
              },
            ),
          ],
        );
      },
    );
  }
  
  User? userss = FirebaseAuth.instance.currentUser;

  @override
  void initState(){
    var pathusr = getdbpath();
    getlength(pathusr!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    checkfcmtoken();
    var pathusr = getdbpath();
    final usersStream = FirebaseDatabase.instance.ref(pathusr!);
    //getlength(pathusr);
    return Scaffold(
      appBar: AppBar(
        title:Row(  
        children:<Widget> [
          Image.asset("images/logo.png", width: 105,height: 45,alignment: Alignment.bottomLeft,),
          const Text("SAFEHAVEN PACKAGES", textAlign: TextAlign.left,),
        ]
        ),
      ),
      body: Column(
        children: <Widget> [
          const SizedBox(height: 10),
          Text('${userss?.email}', style: const TextStyle(fontSize: 20.0)),
          const SizedBox(height: 10, ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color.fromARGB(255, 0, 0, 0),
                              Color.fromARGB(255, 0, 0, 0),
                              Color.fromARGB(255, 0, 0, 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: const Size(120, 60),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(8.0),
                        textStyle: const TextStyle(fontSize: 20)
                      ),
                      onPressed:(){
                          //deleteFCMtoken();
                          FirebaseAuth.instance.signOut();
                          
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const SignUpScreen()));
                        }, 
                      child: const Text( "Sign Out"),
                  )
                  ]
                )
              ),
              ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color.fromARGB(255, 0, 0, 0),
                                  Color.fromARGB(255, 0, 0, 0),
                                  Color.fromARGB(255, 0, 0, 0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            fixedSize: const Size(180, 60),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                            textStyle: const TextStyle(fontSize: 20)
                          ),
                          onPressed:(){
                            _showAlertDialog();
                            
                          }, 
                          child: const Text("Delete Account")
                        ),
                      ]
                    )
                  )                 
            ],
          ),

          const SizedBox(height: 10 ),
          const Text("History Open Box", style: TextStyle(fontSize: 20.0)),
          const SizedBox(height: 10),
         
          Expanded( 
                  
            child:  FirebaseAnimatedList(
              query: usersStream ,    
              sort: (a, b) {
                var aInt = int.parse(a.child('Ts').value.toString());
                var bInt = int.parse(b.child('Ts').value.toString());
                return bInt - aInt;
              },
              itemBuilder: (  context, snapshot, animation, index) {
                if(!snapshot.exists){
                    const Text('Something went wrong');
                    return const CircularProgressIndicator();
                }
           
                if(index >= lengthnoti){
       
                  lengthnoti = index+1;
                  //String num = snapshot.child('Data').value.toString();
                  NotificationService.showNotification(title: "SafeHaven Packages", 
                                                       body: "Your SafeHaven Dropbox has been opened! Please be sure grab your packages that have been delivered");
                }
                var date_ = int.parse(snapshot.child('Ts').value.toString());
                final daytime = DateTime.fromMillisecondsSinceEpoch(date_);
                return Card(
                  color: const Color.fromARGB(59, 240, 237, 226),
                  child: ListTile(
                        leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        child: Text(snapshot.child('Data').value.toString(),
                        style: const TextStyle(color: Colors.black),
                        ),
                      ),
                        title: Text(daytime.toString()),
                      )
                );
               }
            ),         
        
          ),//expande
        ] //widget    
        ),//column
      );//scaffold
  } //buil 
}//class         
          



             
  

  

