import 'package:beatapp/custom_view/edit_text.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/input_formatters.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text('Prahari (Beat Policing)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorProvider.transparent_black,
                  fontSize: SizeProvider.size_24,
                ),
              ),
            ),
            24.height,
            Image.asset(
              "assets/images/ic_launcher.png",
              height: SizeProvider.size_150,
              width: SizeProvider.size_150,
            ),
            const EditText(
              hintText: "Enter Full Name",
              labelText: "Full Name",
            ),
            EditText(
              hintText: "Enter mobile number",
              labelText: "Mobile number",
              maxLength: 10,
              inputFormatters: digitOnly,
            ),
            const EditText(
              hintText: "Enter Your Email",
              labelText: "Email",
            ),
            const EditText(
              hintText: "Enter New Password",
              labelText: "Password",
            ),
            const EditText(
              hintText: "Enter Confirm Password",
              labelText: "Confirm Password",
            ),
            12.height,
            ElevatedButton(onPressed: (){},
                child: const Text("Sign Up"))
          ],
        ),
      ),
    );
  }
}
