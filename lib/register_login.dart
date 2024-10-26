import 'package:bloom/form.dart';
import 'package:bloom/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

// class SignInLogic extends StatelessWidget {
//   final GoogleSignIn googleSignIn = GoogleSignIn(
//       serverClientId:
//           "727309139299-ci9a322djv5p9b129g8539bf1s5pjevs.apps.googleusercontent.com");
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final box = GetStorage(); // Initialize GetStorage

//   Future<void> handleGoogleSignIn(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//       if (googleUser == null) {
//         // The user canceled the sign-in
//         return;
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       UserCredential userCredential =
//           await auth.signInWithCredential(credential);

//       // User is now signed in with Google
//       final User? user = userCredential.user;
//       if (user != null) {
//         String email = user.email ?? '';

//         // Check if the user exists in Firestore
//         final userDoc =
//             FirebaseFirestore.instance.collection('users').doc(email);
//         final userSnapshot = await userDoc.get();
//         if (userSnapshot.exists) {
//           // User exists
//           final userData = userSnapshot.data();
//           if (userData != null) {
//             // Save user data to GetStorage
//             box.write('userData', userData);
//             Navigator.pushReplacementNamed(context, "/home");
//           }
//         } else {
//           // User does not exist, add email to GetStorage
//           box.write('userEmail', email);
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => RoleSelectionScreen(email: email)),
//           );
//         }
//       }
//     } catch (error) {
//       print("Error during Google Sign-In: $error");
//     }
//   }

//   Future<File> getImageFileFromAssets(String imagePath) async {
//     final byteData = await rootBundle.load(imagePath);

//     final file = File(
//         '${(await getTemporaryDirectory()).path}/${path.basename(imagePath)}');
//     await file.writeAsBytes(byteData.buffer
//         .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

//     return file;
//   }

//   Future<bool> sendEmail() async {
//     String username = 'swapnil.gdsc9@gmail.com';
//     String password = 'jgcc huyb fomc tbay';

//     final smtpServer = gmail(username, password);
//     print("Started to send email");

//     File imageFile = await getImageFileFromAssets('assets/images/433.png');
//     // Uncomment and initialize other images if needed
//     // File theDevilWorks = await getImageFileFromAssets('assets/TheDevilWorks.png');
//     // File circle = await getImageFileFromAssets('assets/welcomeMail/circle.png');
//     // File section2 = await getImageFileFromAssets('assets/welcomeMail/section2.png');
//     // File jumpRightIn = await getImageFileFromAssets('assets/welcomeMail/jumpRightIn.png');
//     // File appStore = await getImageFileFromAssets('assets/welcomeMail/appStore.png');
//     // File playStore = await getImageFileFromAssets('assets/welcomeMail/playStore.png');

//     final message = Message()
//       ..from = Address(username, 'Mumbai Hacks')
//       ..recipients.add('swapnilsanap987@gmail.com')
//       ..subject = 'Welcome to Mumbai Hacks Proj'
//       ..html = '''
//     <!DOCTYPE html>
//     <!-- Your HTML content here -->
//     '''
//       ..attachments = [
//         FileAttachment(imageFile)
//           ..location = Location.inline
//           ..cid = 'image1@your-emails.com',
//         // Add other attachments here if needed
//         // FileAttachment(theDevilWorks)
//         //   ..location = Location.inline
//         //   ..cid = 'image2@your-emails.com',
//         // FileAttachment(circle)
//         //   ..location = Location.inline
//         //   ..cid = 'image3@your-emails.com',
//         // FileAttachment(section2)
//         //   ..location = Location.inline
//         //   ..cid = 'image4@your-emails.com',
//         // FileAttachment(jumpRightIn)
//         //   ..location = Location.inline
//         //   ..cid = 'image5@your-emails.com',
//         // FileAttachment(appStore)
//         //   ..location = Location.inline
//         //   ..cid = 'image6@your-emails.com',
//         // FileAttachment(playStore)
//         //   ..location = Location.inline
//         //   ..cid = 'image7@your-emails.com',
//       ];

//     try {
//       final sendReport = await send(message, smtpServer);
//       print('Message sent: ' + sendReport.toString());
//       await send(message, smtpServer);
//       print("Email Sent successfully");
//       return true;
//     } catch (e) {
//       print('Message not sent. Error: $e');
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             sendEmail();
//             handleGoogleSignIn(context);
//           },
//           child: const Text('Sign In with Google'),
//         ),
//       ),
//     );
//   }
// }

class RegisterLogin extends StatefulWidget {
  const RegisterLogin({super.key});

  @override
  _RegisterLoginState createState() => _RegisterLoginState();
}

class _RegisterLoginState extends State<RegisterLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isRegisterMode = false;
  final box = GetStorage();
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _authenticate(BuildContext context) async {
    if (_isRegisterMode) {
      if (_passwordController.text != _confirmPasswordController.text) {
        _showLottieAnimation(context, 'error');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match.'),
            backgroundColor: primaryRed,
          ),
        );
        return;
      }

      try {
        // _showLottieAnimation(context, 'confetti');

        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        final User? user = userCredential.user;
        if (user != null) {
          String email = user.email ?? '';

          // Check if the user exists in Firestore
          final userDoc =
              FirebaseFirestore.instance.collection('users').doc(email);
          final userSnapshot = await userDoc.get();
          if (userSnapshot.exists) {
            // User exists
            final userData = userSnapshot.data();
            if (userData != null) {
              _showLottieAnimation(context, 'tickAnimation');

              box.write('userData', userData);
              Navigator.pushReplacementNamed(context, "/home");
            }
          } else {
            box.write('userEmail', email);
            print('User registered: ${userCredential.user?.email}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registered successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => RoleSelectionScreen(email: email)),
            );
          }
        }
      } catch (e) {
        _showLottieAnimation(context, 'error');

        print('Failed to register: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to register: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Handle login
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        final User? user = userCredential.user;
        if (user != null) {
          _showLottieAnimation(context, 'tickAnimation');

          String uid = user.uid ?? '';

          final userDoc =
              FirebaseFirestore.instance.collection('users').doc(uid);
          final userSnapshot = await userDoc.get();
          if (userSnapshot.exists) {
            final userData = userSnapshot.data();
            if (userData != null) {
              box.write('userData', userData);
              Navigator.pushReplacementNamed(context, "/home");
            }
          } else {
            _showLottieAnimation(context, 'error');

            print('User does not exist in Firestore');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User does not exist.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        _showLottieAnimation(context, 'error');

        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = "User does not exist.";
        } else if (e.code == 'wrong-password') {
          errorMessage = "Incorrect password.";
        } else if (e.code == 'network-request-failed') {
          errorMessage =
              "No internet connection. Please check your connection.";
        } else {
          errorMessage = "Failed to sign in: ${e.message}";
        }
        print('Failed to sign in: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        _showLottieAnimation(context, 'error');

        print('Failed to sign in: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showLottieAnimation(BuildContext context, String animationType) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Lottie.asset(
              'assets/lottie/$animationType.json',
              width: 300,
              height: 300,
              repeat: false,
              onLoaded: (composition) {
                // Use the composition duration to delay closing
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).pop();
                });
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: primaryWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    _isRegisterMode ? "Register" : "Login",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryBlack,
                        letterSpacing: 5),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    hintText: "Email",
                    icon: IconlyBold.message,
                    controller: _emailController,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Password",
                    icon: IconlyBold.lock,
                    controller: _passwordController,
                    obscureText: !_isConfirmPasswordVisible,

                    toggleVisibility: _toggleConfirmPasswordVisibility,
                    //  obscureText: true,
                  ),
                  if (_isRegisterMode) ...[
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: "Confirm Password",
                      icon: Icons.lock,
                      controller: _confirmPasswordController,
                      //  obscureText: true,
                      obscureText: !_isPasswordVisible,

                      toggleVisibility: _togglePasswordVisibility,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isRegisterMode
                            ? "Already have an account? "
                            : "Don't have an account? ",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: primaryBlack,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isRegisterMode = !_isRegisterMode;
                          });
                        },
                        child: Text(
                          _isRegisterMode ? "Login" : "Create Account",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: orange,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _authenticate(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _isRegisterMode ? "Register" : "Login",
                        style: const TextStyle(
                            color: primaryWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback? toggleVisibility;
  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.obscureText,
    this.toggleVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      // ignore: unrelated_type_equality_checks
      obscureText: obscureText,
      style: const TextStyle(color: primaryBlack),
      cursorColor: Colors.amber,
      decoration: InputDecoration(
          label: Text(
            hintText,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(
              icon,
              color: primaryBlack,
              size: 25,
            ),
          ),
          suffixIcon: (hintText == "Confirm Password" || hintText == "Password")
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: obscureText ? primaryBlack : orange,
                  ),
                  onPressed: toggleVisibility,
                )
              : null),
      keyboardType: hintText == "Max attendee"
          ? TextInputType.number
          : TextInputType.text,
    );
  }
}
