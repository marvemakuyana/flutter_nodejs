import 'package:flutter/material.dart';
import 'package:flutter_nodejs/models/register_request_model.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:flutter/gestures.dart';

import '../config.dart';
import '../services/api_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;
  String? password;
  String? email;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('#283B71'),
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _registerUI(context),
          ) ,
          inAsyncCall: isAPIcallProcess,
          opacity: 0.3,
          key: UniqueKey(),
          ),
        ),
    );
  }

  Widget _registerUI(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white
                ]
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/ShoppingApplogo.png",
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              bottom: 30,
              top: 50,
            ),
            child: Text('Register',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white
            ),
            ),
          ),
          FormHelper.inputFieldWidget(
            context, 
            const Icon(Icons.person), 
            "username", 
            "UserName",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Username can\'t be empty";
              }
              return null;
            }, 
            (onSavedVal) {
              username = onSavedVal;
            },
            borderFocusColor: Colors.white,
            prefixIconColor: Colors.white,
            borderColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.white.withOpacity(0.7),
            borderRadius: 10
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FormHelper.inputFieldWidget(
              context, 
              const Icon(Icons.person), 
              "password", 
              "Password",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "Password can\'t be empty";
                }
                return null;
              }, 
              (onSavedVal) {
                password = onSavedVal;
              },
              borderFocusColor: Colors.white,
              prefixIconColor: Colors.white,
              borderColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.7),
              borderRadius: 10,
              obscureText: hidePassword,
              suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.white.withOpacity(0.7),
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility
                ),
              ),
              
              ),
            ),
             FormHelper.inputFieldWidget(
            context, 
            const Icon(Icons.person), 
            "email", 
            "Email",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Email can\'t be empty";
              }
              return null;
            }, 
            (onSavedVal) {
              email = onSavedVal;
            },
            borderFocusColor: Colors.white,
            prefixIconColor: Colors.white,
            borderColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.white.withOpacity(0.7),
            borderRadius: 10
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: FormHelper.submitButton(
                'Register', 
                (){
                   if(validateAndSave()){
                    setState(() {
                        isAPIcallProcess = true;
                    });

                    RegisterRequestModel model = RegisterRequestModel(
                      username: username!,
                      password: password!,
                      email: email!
                    );

                    APIService.register(model).then((response) {
                       setState(() {
                        isAPIcallProcess = false;
                    });

                      if(response.data != null){

                        FormHelper.showSimpleAlertDialog(
                          context, 
                          Config.appName,
                           "Registration Successfull. Please login to the account.", 
                           "OK",
                            (){
                             
                        Navigator.pushNamedAndRemoveUntil(
                          context, 
                          '/login',
                           (route) => false
                          );
                            }
                          );

                      }
                      else{
                        FormHelper.showSimpleAlertDialog(
                          context, 
                          Config.appName,
                          response.message, 
                           "OK",
                            (){
                              Navigator.pop(context);
                            }
                          );
                      }
                    });
                  }
                },
                btnColor: HexColor('#283B71'),
                borderColor: Colors.white,
                txtColor: Colors.white,
                borderRadius: 10
              ),
            ),
            const SizedBox(height: 20,),
           
        ]
        ),
    );
  }
  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }
}
