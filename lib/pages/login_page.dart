import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nodejs/config.dart';
import 'package:flutter_nodejs/models/login_request_model.dart';
import 'package:flutter_nodejs/services/api_services.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;
  String? password;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('#283B71'),
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _loginUI(context),
          ) ,
          inAsyncCall: isAPIcallProcess,
          opacity: 0.3,
          key: UniqueKey(),
          ),
        ),
    );
  }

  Widget _loginUI(BuildContext context){
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
            child: Text('Login',
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
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 25),
                child: RichText(
                  text:  TextSpan(
                    style: const TextStyle(color: Colors.grey, fontSize: 14.0),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Forget Password?',
                        style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          print('Forget Password');
                        },
                      )
                    ]
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: FormHelper.submitButton(
                'Login', 
                (){
                  if(validateAndSave()){
                    setState(() {
                        isAPIcallProcess = true;
                    });

                    LoginRequestModel model = LoginRequestModel(
                      username: username!,
                      password: password!
                    );

                    APIService.login(model).then((response) {
                       setState(() {
                        isAPIcallProcess = false;
                    });

                      if(response){
                        Navigator.pushNamedAndRemoveUntil(
                          context, 
                          '/home',
                           (route) => false
                          );
                      }
                      else{
                        FormHelper.showSimpleAlertDialog(
                          context, 
                          Config.appName,
                           "Invalid Username/Password!", 
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
            const Center(
              child: Text('OR', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),),
            ),
            const SizedBox(height: 20,),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 25),
                child: RichText(
                  text:  TextSpan(
                    style: const TextStyle(color: Colors.grey, fontSize: 14.0),
                    children: <TextSpan>[
                      const TextSpan(text: "Don't have an account" ),
                      TextSpan(
                        text: 'Sign up',
                        style:  const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.pushNamed(context, '/register');
                        },
                      )
                    ]
                  ),
                ),
              ),
            ),
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