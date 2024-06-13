import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(ColorProvider.colorPrimary),
        title: const Text("Delete Account"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            30.height,
            const Text("Temporarily Deactivate your account instead of Deleting",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,

            ),
              textAlign: TextAlign.center,
            ),
            20.height,
            const Text("Your profile will be temporarily hidden until you activate it again logging back in.",
            textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20
              ),
            ),

            50.height,
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                  foregroundColor: WidgetStateProperty.all(Colors.white)
                ),
                onPressed: (){},
                child: const Text("Deactivate Account"),
              ),
            ),
            12.height,
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                    foregroundColor: WidgetStateProperty.all(Colors.white)
                ),
                onPressed: (){
                  Future.delayed(const Duration(milliseconds: 200),(){
                    Fluttertoast.showToast(
                        msg: "Your request has been submitted, We will get back to you soon.",

                        timeInSecForIosWeb: 1,
                        fontSize: 16.0
                    );
                  });

                },
                child: const Text("Delete My Account"),
              ),
            )


          ],
        ),
      ),
    );
  }
}
