import 'package:aquafusion/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   // Send OTP to the phone number
   // Send OTP to the phone number
 // Send OTP to Phone Number
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+63$phoneNumber', // Add country code (e.g., +63 for PH)
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolve OTP
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          onCodeSent(verificationId);
        },
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify OTP and Register the User
  Future<User?> verifyOtpAndRegister({
    required String verificationId,
    required String otp,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // Create credential using the OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      // Sign in the user
      UserCredential result = await _firebaseAuth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        // Save user info to Firestore
        await _saveUserToFirestore(
          uid: user.uid,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: user.phoneNumber ?? '',
        );
      }

      return user;
    } catch (e) {
      print('Error during OTP verification: $e');
      return null;
    }
  }

  // Save user to Firestore
  Future<void> _saveUserToFirestore({
    required String uid,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'phoneNumber': phoneNumber,
        'setup': false,
        'terms': true,
        'species': '',
        'lifestage': '',
        'feedingTable': '',
        'populationCount': 0,
        'averageBodyWeight': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('User saved to Firestore successfully!');
    } catch (e) {
      print('Error saving user to Firestore: $e');
    }
  }

    Future<void> updateUserTerms(String uid, bool agreed) async {
    try {
      await _firestore.collection('users').doc(uid).update({'term': agreed});
    } catch (e) {
      print('Error updating terms: $e');
    }
  }

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