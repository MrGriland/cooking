import 'dart:convert';
import 'package:cooking/network/cookie.dart';
import 'package:http/http.dart' as http;

import 'address.dart';
class NetworkService {
  Map<String, String> headers = {"content-type": "application/x-www-form-urlencoded"};

  void _setCookie(http.Response response) {
    UserCookie.cookie = response.headers['set-cookie']!.split("=").elementAt(7).split(";").elementAt(0);
  }

  Future<bool> login(String email, String password) {
    return http.post(Uri.parse("http://"+Address.address+"/CookingServerAuth/Account/Login"), body: {"Email": email, "Password": password, "RememberMe": "false"}, encoding: Encoding.getByName('utf-8'), headers: headers).then((http.Response response) {
      final int statusCode = response.statusCode;
      if(response.statusCode == 302 && response.headers['set-cookie']!.split("=").elementAt(7).split(";").elementAt(0).isNotEmpty) {
        _setCookie(response);
        return true;
      }
      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      return false;
      //return _decoder.convert(res);
    });
  }

  Future<bool> register(String email, String password) {
    return http.post(Uri.parse("http://"+Address.address+"/CookingServerAuth/Account/Register"), body: {"Email": email, "Password": password, "ConfirmPassword": password}, encoding: Encoding.getByName('utf-8'), headers: headers).then((http.Response response) {
      final int statusCode = response.statusCode;
      if(response.statusCode == 302 && response.headers['set-cookie']!.split("=").elementAt(7).split(";").elementAt(0).isNotEmpty) {
        _setCookie(response);
        return true;
      }
      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      return false;
      //return _decoder.convert(res);
    });
  }

  Future<bool> logout() {
    Map<String, String> logoutheaders = {"content-type": "application/x-www-form-urlencoded"};
    logoutheaders["Cookie"] = ".AspNet.ApplicationCookie="+UserCookie.cookie;
    return http.post(Uri.parse("http://"+Address.address+"/CookingServerAuth/Account/LogOff"), encoding: Encoding.getByName('utf-8'), headers: logoutheaders).then((http.Response response) {
      final int statusCode = response.statusCode;
      if(response.statusCode == 200) {
        UserCookie.cookie = "";
        return true;
      }
      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      return false;
      //return _decoder.convert(res);
    });
  }
}