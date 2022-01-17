import 'dart:convert';

import 'package:flutter_nodejs/config.dart';
import 'package:flutter_nodejs/models/login_request_model.dart';
import 'package:flutter_nodejs/models/login_response_model.dart';
import 'package:flutter_nodejs/models/register_request_model.dart';
import 'package:flutter_nodejs/models/register_response_model.dart';
import 'package:flutter_nodejs/services/shared_service.dart';
import 'package:http/http.dart' as http;

class APIService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async{
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiUrl, Config.loginAPI);

    var response = await client.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()),
    );

    if(response.statusCode == 200) {

      //Shared
      await SharedService.setLoginDetails(loginResponseJson(response.body));

      return true;
    } else{
      return  false;
    }
  }

  static Future<RegisterResponseModel> register(RegisterRequestModel model) async{
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiUrl, Config.registerAPI);

    var response = await client.post(
      url, 
      headers: requestHeaders, 
      body: jsonEncode(model.toJson()),
    );

    return registerResponseModel(response.body);
  }

static Future<String> getUserProfile() async{

  var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": "Basic ${loginDetails!.data.token}"
    };

    var url = Uri.http(Config.apiUrl, Config.userProfileAPI);

    var response = await client.get(
      url, headers: 
      requestHeaders,
    );

    if(response.statusCode == 200) {

      //Shared
      return response.body;

     
    } else{
      return  "";
    }
  }


}