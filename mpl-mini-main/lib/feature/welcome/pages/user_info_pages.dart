import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/common/extension/custon_theme_extension.dart';
import 'package:whatsapp/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp/feature/auth/widgets/Custom_Icon.dart';
import 'package:whatsapp/feature/auth/widgets/custom_text_field.dart';
import 'package:whatsapp/feature/auth/widgets/short_h_bar.dart';
import 'package:whatsapp/MyHomePage.dart';
import 'package:whatsapp/mainCallScreen.dart.dart';
import 'package:whatsapp/mainChatScreen.dart.dart';

import 'name.dart';

//import 'package:whatsapp/feature/welcome/pages/lib/mainChatScreen.dart.dart';

final _firebase = FirebaseAuth.instance;

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    print(_enteredEmail);
    print(_enteredPassword);
    if (_isLogin) {
      try {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print(userCredentials);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => Name()));
      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {}
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message ?? "Authentication Failed"),
        ));
      }
    } else {
      try {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print(userCredentials);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => Name()));
      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {}
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message ?? "Authentication Failed"),
        ));
      }
    }
  }







  final TextEditingController _nameController = TextEditingController();
  final DatabaseReference _userRef =
  FirebaseDatabase.instance.reference().child('users');


  File? _image;
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  imagePickerTypeBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ShortHBar(),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Profile Photo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  CustomIconButton(
                    onTap: () => Navigator.pop(context),
                    icon: Icons.close,
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ),
              // Divider(
              //   color: context.theme.greyColor!.withOpacity(2),
              // ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  ImagePickerIcon(
                    onTap: () {
                      // Handle onTap logic for camera
                      getImageFromCamera();
                    },
                    icon: Icons.camera_alt_rounded,
                    text: 'Camera',
                  )
                ],
              )
            ],
          );
        });
  }

  ImagePickerIcon(
      {required VoidCallback onTap,
      required IconData icon,
      required String text}) {
    return Column(
      children: [
        CustomIconButton(
          onTap: onTap,
          icon: icon,
          iconColor: Colors.green,
          minWidth: 50,
          border: Border.all(color: context.theme.greyColor!.withOpacity(1)),
        )
      ],
    );
  }

  void saveUserInfo() {
    String name = _nameController.text.trim();
    if (name.isNotEmpty) {
      _userRef.push().set({
        'name': name,
        // Add other fields if needed
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User information saved successfully')),
        );
        // Navigate to next screen or perform other actions
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save user information')),
        );
        // Handle errors
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SvgPicture.asset(
                //     'assets/icons/openai-wordmark.svg',
                //     height: 30
                // ),
                SizedBox(
                    height: 130
                ),
                // Spacer(),
                Text(
                  _isLogin ? 'Welcome Back' : "Create your account",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.only(top: 5, left: 10, right: 20, bottom: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(142, 142, 142, 1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 1,
                      ),
                    ),
                    hintText: 'Please enter your Email',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(224, 224, 224, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  textAlign: TextAlign.start,
                  // controller: _pincodeController,
                  cursorColor: Colors.blue,
                  // inputFormatters: [
                  //   LengthLimitingTextInputFormatter(6),
                  //   FilteringTextInputFormatter.digitsOnly,
                  // ],
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid E-mail Address';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _enteredEmail = value!;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.only(top: 5, left: 10, right: 20, bottom: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(142, 142, 142, 1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.green, // Assuming MyColors.blue is not defined
                        width: 1,
                      ),
                    ),
                    hintText: 'Please enter your Password',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(224, 224, 224, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  textAlign: TextAlign.start,
                  // controller: _pincodeController,
                  cursorColor: Colors.blue, // Assuming MyColors.blue is not defined

                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'Password must be atleast 6 characters long...';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPassword = value!;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      disabledBackgroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(
                      _isLogin ? "Login" : "SignUp",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // onPressed: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => AuthScreen(),
                    //     ),
                    //   );
                    // },
                    // child: Text(
                    //   'Continue',
                    //   style: TextStyle(
                    //     color: MyColors.white,
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.w500,
                    //     fontFamily: 'Nunito',
                    //   ),
                    // ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account ?",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin ? " Sign Up" : ' Login',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class ImagePickerIcon extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String text;

  const ImagePickerIcon({
    required this.onTap,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomIconButton(
          onTap: onTap,
          icon: icon,
          iconColor: Colors.green,
          minWidth: 50,
          border: Border.all(color: context.theme.greyColor!.withOpacity(1)),
        )
      ],
    );
  }
}
