import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mip_app/model/userModel.dart';

class LoginContoller with ChangeNotifier {
  var googleSignInNow = GoogleSignIn();

  GoogleSignInAccount? googleSignInAccount;
  UserModel? userModel;

  allowUserToLogin() async {
    print('object02');
    kIsWeb
        ? await (googleSignInNow.signInSilently())
        : await (googleSignInNow.signIn());

    if (kIsWeb && googleSignInAccount == null)
      googleSignInAccount = await (googleSignInNow.signIn());
    print('object03');

    this.userModel = UserModel(
        displayName: this.googleSignInAccount!.displayName,
        email: this.googleSignInAccount!.email,
        photoURL: this.googleSignInAccount!.photoUrl);
    notifyListeners();
  }

  allowUserToLogoutW() async {
    this.googleSignInAccount = await googleSignInNow.signOut();

    userModel = null;
    notifyListeners();
  }
}
