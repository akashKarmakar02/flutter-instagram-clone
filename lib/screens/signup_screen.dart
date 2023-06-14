import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/services/AuthService.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // svg image
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                  const SizedBox(height: 64),
                  // a circular widget to accept and show our selected profile pic
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage('https://www.photoshopbuzz.com/wp-content/uploads/change-color-part-of-image-psd4.jpg'),
                      ),
                      Positioned(
                        bottom: -10,
                          left: 80,
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.add_a_photo_rounded)
                          )
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  // text input for username
                  TextFieldInput(
                    hintText: "Enter Your Username",
                    textInputType: TextInputType.text,
                    textEditingControl: _usernameController,
                  ),
                  const SizedBox(height: 24),
                  // text input for email
                  TextFieldInput(
                    hintText: "Enter Your Email",
                    textInputType: TextInputType.emailAddress,
                    textEditingControl: _emailController,
                  ),
                  const SizedBox(height: 24),
                  // text input for password
                  TextFieldInput(
                    hintText: "Enter Your Password",
                    textInputType: TextInputType.text,
                    textEditingControl: _passwordController,
                    isPass: true,
                  ),
                  const SizedBox(height: 24),
                  // text input for bio
                  TextFieldInput(
                    hintText: "Enter Your Bio",
                    textInputType: TextInputType.text,
                    textEditingControl: _bioController,
                  ),
                  const SizedBox(height: 24),
                  // button for login
                  GestureDetector(
                    onTap: () async {
                      String result = await AuthService().signUpUser(
                          email: _emailController.text,
                          password: _passwordController.text,
                          username: _usernameController.text,
                          bio: _bioController.text
                      );
                      print(result);
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          color: blueColor
                      ),
                      child: const Text('Signup'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Transitioning to password

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Don't Have An Account?"),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
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
