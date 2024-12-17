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


  //forgot pw anonymously
  Future forgotPass(String email) async{
    try{
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  Future<void> signInWithPhoneNumber(String phoneNumber, Function(String) codeSentCallback) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
          throw Exception(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          codeSentCallback(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Code auto-retrieval timeout');
        },
      );
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<User?> verifyOTP(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Error verifying OTP: $e');
      return null;
    }
  }

  Future<dynamic> verifyPhoneNumber({required String phoneNumber, String? firstName, String? lastName}) async {
    try {
      // Example using Firebase Authentication
      print("Starting phone verification for $phoneNumber...");
      // Trigger verification (implement Firebase or other backend logic here)
    } catch (e) {
      print('Error during phone verification: $e');
      return null;
    }
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