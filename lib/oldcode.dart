
// // import 'package:boxapp/screens/sigup.dart';
// // import 'package:boxapp/services/firebase_helper.dart';
// // import 'package:boxapp/services/notification.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_database/firebase_database.dart';
// // import 'package:firebase_database/ui/firebase_animated_list.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/material.dart';


// // Future<void> deleteUserAccount() async {
// //   User? userssn = FirebaseAuth.instance.currentUser;
// //   final FirebaseFirestore oodb = FirebaseFirestore.instance;
// //   try {
// //     final getodbdelete = oodb.collection('user').doc(userssn?.uid);
// //     getodbdelete.delete();
// //     deleteFCMtoken();
// //     await FirebaseAuth.instance.currentUser!.delete();
// //     //FirebaseAuth.instance.signOut();
// //   } on FirebaseAuthException catch (e) {
// //     debugPrint(e as String?);

// //     if (e.code == "requires-recent-login") {
// //       await _reauthenticateAndDelete();
// //     } else {
// //       // Handle other Firebase exceptions
// //     }
// //   } catch (e) {
// //     debugPrint(e as String?);

// //     // Handle general exception
// //   }

// // }
// // Future<void> deleteFCMtoken() async{
// //   await FirebaseMessaging.instance.deleteToken();

// //   debugPrint("delete token");
// // }
// // Future<void> checkfcmtoken() async{
// //   //final tokenn = await NotificationService.requestFirebaseToken();
// //   String? token = await FirebaseMessaging.instance.getToken();
// //   debugPrint("new token");
// //   debugPrint(token);
// //   var oldtoken;
// //   User? userss = FirebaseAuth.instance.currentUser;
// //   final FirebaseFirestore oodb = FirebaseFirestore.instance;
// //   final getodb = oodb.collection('user').doc(userss?.uid);
// //   await getodb.get().then(
// //     (DocumentSnapshot doc) {
// //         oldtoken = doc.get("token");
// //         debugPrint("snap từ firebase");
// //         debugPrint(oldtoken);
// //     } 
// //   );
// //   if( oldtoken != token){
// //       //cập nhật lại token
// //      getodb.update({"token": token});
// //      //reload page ?

// //   }
// // }


// // Future<void> _reauthenticateAndDelete() async {
// //   try {
// //     final providerData = FirebaseAuth.instance.currentUser?.providerData.first;

// //     if (AppleAuthProvider().providerId == providerData!.providerId) {
// //       await FirebaseAuth.instance.currentUser!
// //           .reauthenticateWithProvider(AppleAuthProvider());
// //     } else if (GoogleAuthProvider().providerId == providerData.providerId) {
// //       await FirebaseAuth.instance.currentUser!
// //           .reauthenticateWithProvider(GoogleAuthProvider());
// //     }

// //     await FirebaseAuth.instance.currentUser?.delete();
// //   } catch (e) {
// //     // Handle exceptions
// //   }
// // }

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({Key? key}) : super(key: key);

// //   @override
// //   State<HomeScreen> createState() => _HomeScreen();
// // }


// // String? getdbpath() {
// //     User? userss = FirebaseAuth.instance.currentUser;
// //     if(userss != null){
// //       final emailuser = userss.email;
// //       var pathdb = emailuser?.replaceAll("@", "");
// //       pathdb = pathdb?.replaceAll('.', '');
      
// //       return pathdb;
// //     }else{
// //       return "1";
// //     }

// // }


// // class _HomeScreen extends State<HomeScreen> {
// //   Future<void> _showAlertDialog() async {
// //     return showDialog<void>(
// //       context: context,
// //       barrierDismissible: false, // user must tap button!
// //       builder: (BuildContext context) {
// //         return AlertDialog( // <-- SEE HERE
// //           title: const Text('Delete Account'),
// //           content: const SingleChildScrollView(
// //             child: ListBody(
// //               children: <Widget>[
// //                 Text('Are you sure want to delete account?'),
// //               ],
// //             ),
// //           ),
// //           actions: <Widget>[
// //             TextButton(
// //               child: const Text('No'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //             TextButton(
// //               child: const Text('Yes'),
// //               onPressed: () {
// //                 deleteUserAccount();
// //                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const SignUpScreen()));
// //                           //xoa tren database
// //                           //xóa fcm
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   User? userss = FirebaseAuth.instance.currentUser;
// //   @override
// //   Widget build(BuildContext context) {
// //     checkfcmtoken();
// //     var pathusr = getdbpath();
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Home'),
// //         centerTitle: true,
// //       ),
// //       body: SafeArea(
       
// //         child: Column(  
// //         //mainAxisSize: MainAxisSize.min,
// //           children: <Widget>[
            
// //             const SizedBox(height: 10),
// //             Text('${userss?.email}', style: TextStyle(fontSize: 20.0)),
// //             const SizedBox(height: 10, ),
// //              Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: [
// //                 ClipRRect(
// //                   borderRadius: BorderRadius.circular(4),
// //                   child: Stack(
// //                     children: <Widget>[
// //                       Positioned.fill(
// //                         child: Container(
// //                           decoration: const BoxDecoration(
// //                             gradient: LinearGradient(
// //                               colors: <Color>[
// //                                 Color(0xFF0D47A1),
// //                                 Color(0xFF1976D2),
// //                                 Color(0xFF42A5F5),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       TextButton(
// //                         style: TextButton.styleFrom(
// //                           fixedSize: const Size(120, 40),
// //                           foregroundColor: Colors.white,
// //                           padding: const EdgeInsets.all(8.0),
// //                           textStyle: const TextStyle(fontSize: 20)
// //                         ),
// //                         onPressed:(){
// //                             //deleteFCMtoken();
// //                             FirebaseAuth.instance.signOut();
                            
// //                             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const SignUpScreen()));
// //                           }, 
// //                         child: const Text( "Sign Out"),
// //                     )
// //                     ]
// //                   )
// //                 ),
// //                 ClipRRect(
// //                   borderRadius: BorderRadius.circular(4),
// //                   child: Stack(
// //                     children: <Widget>[
// //                       Positioned.fill(
// //                         child: Container(
// //                           decoration: const BoxDecoration(
// //                             gradient: LinearGradient(
// //                               colors: <Color>[
// //                                 Color(0xFF0D47A1),
// //                                 Color(0xFF1976D2),
// //                                 Color(0xFF42A5F5),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                        TextButton(
// //                         style: TextButton.styleFrom(
// //                           fixedSize: const Size(180, 40),
// //                           foregroundColor: Colors.white,
// //                           padding: const EdgeInsets.all(8.0),
// //                           textStyle: const TextStyle(fontSize: 20)
// //                         ),
// //                         onPressed:(){
// //                           _showAlertDialog();
                          
// //                         }, 
// //                         child: const Text("Delete Account")
// //                       ),
// //                     ]
// //                   )
// //                 ) 
// //               ],
// //             ), 
            
// //             const SizedBox(height: 10, ),
// //             const Text("History Open Box", style: TextStyle(fontSize: 20.0)),
// //             const SizedBox(height: 10, ),
            
// //             Expanded( 
                   
// //               child:  FirebaseAnimatedList(
         
// //                 query: FirebaseDatabase.instance.ref(pathusr), 
                
// //                 itemBuilder: ( context, snapshot, animation, index) {
// //                   var date_ = int.parse(snapshot.child('Ts').value.toString());
// //                   var date = DateTime.fromMillisecondsSinceEpoch(date_);
// //                     /**                   
// //                      if (index == myindex)
// //                     {
// //                       NotificationService.showNotification(
// //                       title:(snapshot.child('Data').value.toString()),
// //                       body: (snapshot.child('Ts').value.toString()),
// //                       );
// //                       myindex ++;
// //                     } */
// //                   return                   // 
// //                     ListTile(
// //                         // shape: RoundedRectangleBorder( 
// //                         //   side: const BorderSide(width: 1),
// //                         //   borderRadius: BorderRadius.circular(1),
// //                         // ),
// //                         leading: CircleAvatar(
// //                           backgroundColor: const Color(0xff6ae792),
// //                           child: Text(
// //                             (snapshot.child('Data').value.toString()),
// //                             style: TextStyle(color: Colors.black),
// //                           ),
// //                         ),
// //                     title: Text(date.toString()),
// //                     shape: const Border(
// //                           bottom: BorderSide(),
// //                       ),
// //                   );
                  
// //                 }
                      
// //               ),
                  

// //               ),
                 
// //           ]
// //         ),
// //       ),  
// //     );
// //   }
// // }



// Widget titleSection = Container(
//   padding: const EdgeInsets.all(32),
//   child: Row(
//     children: [
//       Expanded(
//         /*1*/
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /*2*/
//             Container(
//               padding: const EdgeInsets.only(bottom: 8),
//               child: const Text(
//                 'Oeschinen Lake Campground',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Text(
//               'Kandersteg, Switzerland',
//               style: TextStyle(
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       ),
//       /*3*/
//       Icon(
//         Icons.star,
//         color: Colors.red[500],
//       ),
//       const Text('41'),
//     ],
//   ),
// );