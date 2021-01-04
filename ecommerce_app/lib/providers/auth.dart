import 'package:ecommerce_app/models/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if(_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null){
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    const url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAXGY2yZttoXsUUz_vnyFCxBOjpRjmOg5I";
    try{
      final response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        print(json.decode(response.body));
        throw HttpException(responseData['error']['message']);
      }
      // set my token information
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
          Duration(seconds:
          int.parse(responseData["expiresIn"]
          ))
      );
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    }catch(error){
      throw error;
    }
  }

  Future<bool> tryAutologging() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(prefs.get('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if(expiryDate.isAfter(DateTime.now())){
      return false;
    }
    _token = extractedUserData['expiryDate'];
    _userId = extractedUserData['userId'];
    _expiryDate = extractedUserData['expiryDate'];
    notifyListeners();
    _setAutoLogout();
    return true;
  }

  Future<void> login(String email, String password) async {
    const url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAXGY2yZttoXsUUz_vnyFCxBOjpRjmOg5I";
    try{
      final response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        print(json.decode(response.body));
        throw HttpException(responseData['error']['message']);
      }
      // set my token information
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
          Duration(seconds:
          int.parse(responseData["expiresIn"]
          ))
      );
      _setAutoLogout();
      notifyListeners();
    }catch(error){
      throw error;
    }
    //print(json.decode(response.body));
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null){
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void _setAutoLogout() {
    if (_authTimer != null){
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}