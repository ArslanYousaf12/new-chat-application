import 'dart:io';
import 'package:chat_app_course/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  File? _selectedImage;
  bool _isAuthenticating = false;
  String _username = '';

  void _saveForm() async {
    final isvalid = _formKey.currentState!.validate();
    if (!isvalid || !_isLogin && _selectedImage == null) {
      return;
    }

    print(_selectedImage);
    _formKey.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredential = await _firebase.signInWithEmailAndPassword(
            email: _email, password: _password);
        print(userCredential);
      } else {
        final userCredential = await _firebase.createUserWithEmailAndPassword(
            email: _email, password: _password);
        final imageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');
        await imageRef.putFile(_selectedImage!);
        final imageUrl = await imageRef.getDownloadURL();
        print(imageUrl);
        await FirebaseFirestore.instance
            .collection('user_data')
            .doc(userCredential.user!.uid)
            .set({
          'name': _username,
          'Email': _email,
          'Image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error == '') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message!)));
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!_isLogin)
                              UserImagePicker(
                                onPickedImage: (pickedImage) {
                                  _selectedImage = pickedImage;
                                },
                              ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email Addresss',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please Enter the Valid Email Address';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _email = newValue!;
                              },
                            ),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                ),
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 4) {
                                    return 'Please Enter the at least 4 characer long username';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _username = newValue!;
                                },
                              ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Password Must be valid and  6 character long';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _password = newValue!;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (_isAuthenticating)
                              const CircularProgressIndicator(),
                            if (!_isAuthenticating)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                onPressed: _saveForm,
                                child: Text(_isLogin ? 'Login' : 'SignUp'),
                              ),
                            if (!_isAuthenticating)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                    ? 'Create an Account'
                                    : 'Already have a account'),
                              )
                          ],
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
