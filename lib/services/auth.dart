import 'package:aquafusion/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _userFromFirebase(User? user){
    return user != null ? UserModel(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }


  //sign in anonymously
  Future signInAnon() async{
    try{
      UserCredential result = await _firebaseAuth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebase(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in with email n pass
  Future signInEmailAndPassword(String email, String pass) async{
    try{
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
      User? user = result.user;
      return _userFromFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email n pass
  Future registerEmailAndPassword(String email, String pass, String first, String last,String phone) async{
    try{
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
      User? user = result.user;
      print(user!.uid);
      await _firestore.collection('users').doc(user.uid).set({
        'firstName': first.trim(),
        'lastName': last.trim(),
        'setup': false,
        'phoneNumber': phone.trim(),
        'species': '',
        'lifestage': '',
        'feedingTable': '',
        'populationCount': 0,
        'averageBodyWeight': 0,
        'email': user.email,
        'createdAt': DateTime.now(),
      });
          return _userFromFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //check setup
//  Future<bool?> checkUserSetup() async {
//     try{
//       User? user = _firebaseAuth.currentUser;
//       if (user != null) {
//         DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

//         // Check if setup is completed
//         bool setupCompleted = userDoc['setup'] ?? false;
//         return setupCompleted;
//       }
//     }catch(e){
//       print(e.toString());
//       return null;
//     }
//   }

  //sign out
  Future signOut() async{
    try{
      return await _firebaseAuth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}